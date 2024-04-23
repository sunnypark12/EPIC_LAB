import os
from pathlib import Path

def group_tasks(task_folders):
    # Placeholder for the actual task grouping logic
    # For demonstration, let's just return the task names
    return task_folders

# Select the ProcessedData folder (replace 'path_to_ProcessedData' with the actual path)
input_dir = Path('/Users/sunho/Desktop/VIP_EPIC/ToolBox/CodePython/Segmentation')
subject = 'AB01'

# Get the list of task directories for the subject
task_paths = [p for p in (input_dir / subject).iterdir() if p.is_dir()]
tasks = [p.name for p in task_paths if not p.name.startswith('.')]

# Group tasks (implement your own logic in the group_tasks function)
groups = group_tasks(tasks)
unique_groups = set(groups)  # Get unique groups

print(f'{subject} tasks include:')
for group in unique_groups:
    print(group)