import numpy as np
import os
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.widgets import Button
from scipy.interpolate import interp1d, CubicSpline
from scipy.signal import find_peaks
from sklearn.decomposition import PCA
import matplotlib.cm as cm
import tkinter as tk
from tkinter import scrolledtext

# Function to segment gait cycle with padding
def segment_gc(time, gc, padding=0.1):
    peaks, _ = find_peaks(gc, distance=100)
    segments = []

    for i in range(len(peaks) - 1):
        start = peaks[i]
        end = peaks[i + 1]
        
        # Add padding before the start and after the end
        start_pad = max(0, start - int((end - start) * padding))
        end_pad = min(len(time) - 1, end + int((end - start) * padding))
        
        segments.append((time[start_pad], time[end_pad]))
    
    return segments

def plot_3x3_plots(data_dir, trials, legs, trial_title, flyaway_on=False, compare_mode=0):
    print(f"Received {trials} trials and {legs} legs.")  # Debug input sizes

    # Print directory being checked
    print("Checking directory:", data_dir)
    all_dirs = os.listdir(data_dir)
    print("All directories found:", all_dirs)

    filepath = '/Users/sunho/Desktop/toolbox/AB01/AB01_AB1_V1_TM_LG_NX_S2_t1_filled_ID.sto'
    sto_data = pd.read_csv(filepath, sep='\t', skiprows=6)
    time_column = sto_data['time'].values

    def on_click(event):
        # When the canvas is clicked, check if the click was on an Axes
        if event.inaxes in axs:
            fig._current_ax = event.inaxes
    
    fig, axs = plt.subplots(3, 3, figsize=(12, 12))
    fig.suptitle(trial_title)
    fig._current_ax = None
    
    fig.canvas.mpl_connect('button_press_event', on_click)

    data_info = [
        ('hip_flexion_r_moment', 'Hip Flexion Moment'),
        ('hip_adduction_r_moment', 'Hip Adduction Moment'),
        ('hip_rotation_r_moment', 'Hip Rotation Moment'),
        ('knee_angle_r_moment', 'Knee Angle Moment'),
        ('ankle_angle_r_moment', 'Ankle Angle Moment'),
        ('subtalar_angle_r_moment', 'Subtalar Angle Moment'),
        ('mtp_angle_r_moment', 'MTP Angle Moment')
    ]
    
    ax_button_zoom_in = plt.axes([0.82, 0.94, 0.08, 0.04])
    btn_zoom_in = Button(ax_button_zoom_in, 'Zoom In', color='powderblue', hovercolor='darkturquoise')
    def zoom_in_x(event):
        if fig._current_ax:  # Check if a subplot is selected
            xlim = fig._current_ax.get_xlim()
            fig._current_ax.set_xlim(xlim[0], xlim[1] * 0.75)
            fig.canvas.draw()

    btn_zoom_in.on_clicked(zoom_in_x)

    ax_button_zoom_out = plt.axes([0.91, 0.94, 0.08, 0.04])
    btn_zoom_out = Button(ax_button_zoom_out, 'Zoom Out', color='powderblue', hovercolor='darkturquoise')
    def zoom_out_x(event):
        if fig._current_ax:  # Check if a subplot is selected
            xlim = fig._current_ax.get_xlim()
            fig._current_ax.set_xlim(xlim[0], xlim[1] * 1.33)
            fig.canvas.draw()

    btn_zoom_out.on_clicked(zoom_out_x)
    
    ax_button_gdi = plt.axes([0.7, 0.94, 0.1, 0.04])
    btn_gdi = Button(ax_button_gdi, 'GDI Calculator', color='powderblue', hovercolor='darkturquoise')

    def calculate_gdi(event):
        gdi_results = compute_gdi(sto_data)
        print(gdi_results)
    btn_gdi.on_clicked(calculate_gdi)

    for idx, (column, title) in enumerate(data_info):
        row, col = divmod(idx, 3)
        if column in sto_data.columns:
            time = time_column
            values = sto_data[column].values
            
            # Segment the gait cycles with padding
            gc_channel = values  # Assuming gc_channel contains the gait cycle data
            segments = segment_gc(time, gc_channel, padding=0.1)
            
            times = []
            values_list = []
            for start, end in segments:
                mask = (time >= start) & (time <= end)
                times.append(time[mask])
                values_list.append(values[mask])
            
            ensemble_avg_and_plot(axs[row, col], times, values_list, title)
    
    plt.tight_layout(pad=3.0)
    plt.show()

def normalize_gait_cycle(time, values):
    time_normalized = np.linspace(0, 100, 100)  # Normalize to 0-100% gait cycle
    interpolator = interp1d(np.linspace(0, 100, len(values)), values, kind='linear', fill_value="extrapolate")
    values_normalized = interpolator(time_normalized)
    return time_normalized, values_normalized

def ensemble_avg_and_plot(ax, times, values_list, title, xlabel='Gait Cycle (%)', ylabel='Moment (Nm/kg)'):
    all_normalized_data = []
    
    # Process each set of time and values
    for time, values in zip(times, values_list):
        time_normalized, normalized_data = normalize_gait_cycle(time, values)
        all_normalized_data.append(normalized_data)
    
    # Stack all normalized data for ensemble averaging
    all_normalized_data = np.vstack(all_normalized_data)
    
    # Calculate mean and std deviation
    mean_vals = np.mean(all_normalized_data, axis=0)
    std_dev = np.std(all_normalized_data, axis=0)
    
    # Plot individual gait cycles in light grey
    for normalized_data in all_normalized_data:
        ax.plot(time_normalized, normalized_data, color='lightgrey', alpha=0.5)

    # Plot mean cycle as a solid line
    ax.plot(time_normalized, mean_vals, color='black', linewidth=2, label=title)
    
    # Highlight areas near the mean with a colored gradient
    cmap = cm.get_cmap('viridis')
    for i, normalized_data in enumerate(all_normalized_data):
        distance = np.linalg.norm(normalized_data - mean_vals)
        normalized_distance = distance / np.max(np.linalg.norm(all_normalized_data - mean_vals, axis=1))
        color = cmap(1 - normalized_distance)  # Darker if closer to mean
        ax.plot(time_normalized, normalized_data, color=color, alpha=0.5, linewidth=0.5)
    
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.legend()

def compute_gdi(sto_data):
    # Extract kinematic data
    kinematic_data = sto_data[['hip_flexion_r_moment', 'hip_adduction_r_moment', 'hip_rotation_r_moment',
                               'knee_angle_r_moment', 'ankle_angle_r_moment', 'subtalar_angle_r_moment',
                               'mtp_angle_r_moment']].values

    # Normalize gait cycle
    time_column = sto_data['time'].values
    normalized_data = []
    for column in kinematic_data.T:
        time_normalized, values_normalized = normalize_gait_cycle(time_column, column)
        normalized_data.append(values_normalized)
    
    normalized_data = np.array(normalized_data).T

    # Dimension reduction using PCA
    pca = PCA(n_components=3)
    pca.fit(normalized_data)
    principal_components = pca.transform(normalized_data)

    # Normative dataset (example, you should replace this with actual normative data)
    normative_data = np.random.normal(size=(100, 7))  # Replace with real normative data
    normative_normalized = []
    for column in normative_data.T:
        _, values_normalized = normalize_gait_cycle(np.arange(len(column)), column)
        normative_normalized.append(values_normalized)
    normative_normalized = np.array(normative_normalized).T

    # Apply PCA to normative data
    normative_pca = pca.transform(normative_normalized)

    # Calculate mean and std deviation of normative PCA components
    normative_mean = np.mean(normative_pca, axis=0)
    normative_std = np.std(normative_pca, axis=0)

    # Calculate GDI
    gdi_scores = np.zeros(principal_components.shape[0])
    for i in range(principal_components.shape[0]):
        z_scores = (principal_components[i] - normative_mean) / normative_std
        gdi_scores[i] = 100 - np.linalg.norm(z_scores)
    
    gdi = np.mean(gdi_scores)

    # Calculate symmetry index
    symmetry_index = np.abs((principal_components[:, 0] - principal_components[:, 1]) / (principal_components[:, 0] + principal_components[:, 1]))

    # Calculate regularity score (coefficient of variation)
    regularity_score = np.std(principal_components, axis=0) / np.mean(principal_components, axis=0)

    results = {
        'GDI': gdi,
        'Symmetry Index': symmetry_index,
        'Regularity Score': regularity_score
    }
    return results

# def show_gdi_results(results):
#     result_text = (
#         f"GDI: {results['GDI']:.2f}\n\n"
#         f"Symmetry Index:\n{np.array_str(results['Symmetry Index'], precision=2, suppress_small=True)}\n\n"
#         f"Regularity Score:\n{np.array_str(results['Regularity Score'], precision=2, suppress_small=True)}"
#     )

#     root = tk.Tk()
#     root.title("GDI Results")

#     frame = tk.Frame(root, padx=10, pady=10)
#     frame.pack(fill=tk.BOTH, expand=True)

#     result_label = tk.Label(frame, text="GDI Results", font=("Arial", 14))
#     result_label.pack(pady=5)

#     result_textbox = scrolledtext.ScrolledText(frame, wrap=tk.WORD, width=60, height=20, font=("Arial", 12))
#     result_textbox.insert(tk.INSERT, result_text)
#     result_textbox.config(state=tk.DISABLED)
#     result_textbox.pack(pady=5)

#     root.mainloop()


def show_simple_popup():
    root = tk.Tk()
    root.title("Simple Popup")

    frame = tk.Frame(root, padx=10, pady=10)
    frame.pack(fill=tk.BOTH, expand=True)

    root.mainloop()


# Example usage
data_dir = "/Users/sunho/Desktop/toolbox"
trials = ["AB01_AB1_V1_TM_LG_NX_S2_t1"]
legs = ["right"]
trial_title = "Biomechanical Data Analysis"
plot_3x3_plots(data_dir, trials, legs, trial_title)

