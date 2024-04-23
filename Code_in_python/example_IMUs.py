import numpy as np

def transform_imus(imu_names, transformation_parameters):
    # This function needs the actual transformation logic applied to IMUs
    # For now, it just prints the inputs
    print("Transforming IMUs:", imu_names)
    print("With parameters:\n", transformation_parameters)

# List of IMU names
imu_names = ['LThigh', 'LThigh2', 'RThigh', 'LShank', 'LFoot']

# Corresponding transformation parameters
transformation_parameters = np.array([
    [9.5, -73.5, -60.0],
    [130, -250, 0],
    [9.5, -73.5, 60.0],
    [13.5, -110.7, -60.0],
    [110.0, 10.0, 0.0]
])

# Call the function
transform_imus(imu_names, transformation_parameters)
