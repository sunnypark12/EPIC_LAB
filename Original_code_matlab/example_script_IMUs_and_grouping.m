%% Tranforming IMUs
TransformIMUs({'LThigh','LThigh2','RThigh','LShank','LFoot'},[9.5, -73.5, -60.0;...
    130, -250, 0; 9.5, -73.5, 60.0; 13.5, -110.7, -60.0; 110.0, 10.0, 0.0]);
%creates a new set of IMUs positioned in the opensim coordinates in each row (mm)
%this is performed for each trial of the dataset and written to table within that folder

%% Grouping Activities (get the groupings for subject AB01s activities)
inputDir = uigetdir(pwd, 'Select the ProcessedData folder');
subject = 'AB01';
tasks = dir(fullfile(inputDir,subject)); % read the directory
tasks = {tasks([tasks(:).isdir]).name}; % get the folder names
tasks = tasks(~(contains(tasks,'.')|contains(tasks,'..'))); % only keep pertinent folders
groups = GroupTasks(tasks); % example of how to use the grouping code
unique_groups = unique(groups); % get the unique groups
fprintf('%s tasks include:\n',subject); % begin printing the unique groups
for ii = 1:length(unique_groups)
    fprintf('%s\n',unique_groups{ii});
end