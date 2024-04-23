import numpy as np
import os
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.widgets import Button
from scipy.interpolate import interp1d
from scipy.interpolate import CubicSpline

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
    for idx, (column, title) in enumerate(data_info):
        row, col = divmod(idx, 3)
        if column in sto_data.columns:
            time = time_column
            values = sto_data[column].values
            ensemble_avg_and_plot(axs[row, col], [time], [values], title)



    plt.tight_layout(pad=3.0)
    plt.show()

def normalize_gait_cycle(time, values):
    if len(np.unique(time)) != len(time):
        unique_times, indices = np.unique(time, return_index=True)
        values = values[indices]
        time = unique_times
        
    time_normalized = np.linspace(time.min(), time.max(), 100)  # Adjust to interpolate within the range of existing data points
    interpolator = CubicSpline(time, values)  # CubicSpline usage
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
    
    # Plot mean and std deviation
    ax.plot(time_normalized, mean_vals, color='c', linewidth=2, label=title)
    ax.fill_between(time_normalized, mean_vals - std_dev, mean_vals + std_dev, color='lightblue', alpha=0.2)
    
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.legend()

# Example usage
data_dir = "/Users/sunho/Desktop/toolbox"
trials = ["AB01_AB1_V1_TM_LG_NX_S2_t1"]
legs = ["right"]
trial_title = "Biomechanical Data Analysis"
plot_3x3_plots(data_dir, trials, legs, trial_title)
