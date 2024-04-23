function TransformIMUs(segments,positions,varargin)
%% Transform IMUs
%This function creates a new set of IMUs at locations specified by the user

%INPUTS (Name, Value)
%Required
% segments (m x 1 cell array of strings): a list of the body segments where new IMUs are to are to be calculated
%   e.g. {'LThigh','LThigh2','RThigh','LShank','LFoot'}
% positions (m x 3 array of positions): a three dimensional (x,y,z) position of the new IMU for each of the segments
%   this position is measured in mm in the segment reference frame from OpenSim
%   e.g. [9.5, -73.5, -60.0; 130, -250, 0; 9.5, -73.5, 60.0; 13.5, -110.7, -60.0; 110.0, 10.0, 0.0]
%Optional
% inputDir (string or char): sets the directory to read data from (default get via gui)
% outputExt (char): sets the output suffix for the file (default: _imu_new)
% subjects (cell array): sets the subjects to transform (default all subjects)
% trialNames (cell array): sets the trials to transform (default all trials)
% overwrite (boolean): flag for overwriting previous files (default: false)

%OUTPUTS
% no direct returns from this function, but csv files are written in each folder of the dataset


p = inputParser;
addRequired(p,'segments',@iscellstr);
addRequired(p,'positions',@ismatrix);
addParameter(p,'inputDir',''); %default get user input see below
addParameter(p,'outputExt','_imu_new',@ischar);
addParameter(p,'subjects',{},@iscellstr); %default use all subjects see below
addParameter(p,'trialNames',{},@iscellstr); %default use all trials see below
addParameter(p,'overwrite',false);
p.parse(segments, positions, varargin{:});

segments = p.Results.segments;
positions = p.Results.positions;
if length(segments) ~= size(positions,1)
    error('Number of segments and positions much match');
elseif size(positions,2) ~= 3
    error('Positions must be 3 dimensional row vectors');
end
trialNames = p.Results.trialNames;
overwrite = p.Results.overwrite;
outputExt = p.Results.outputExt;

inputDir = p.Results.inputDir;
inputDir = convertStringsToChars(inputDir);
if ~ischar(inputDir) || isempty(inputDir)
    inputDir = uigetdir(pwd, 'Select the ProcessedData folder');
end

subjects = p.Results.subjects;
if isempty(subjects)
    subjects = dir(inputDir);
    subjects = {subjects([subjects(:).isdir]).name};
    subjects = subjects(contains(subjects,'AB'));
    if isempty(subjects)
        error('No subjects found. Please select the ProcessedData folder with subjects: AB01...')
    end
end

sensorStruct = struct();

for ii = 1:length(segments)
    segment = segments{ii};

    if contains(segment,'Pelvis')
        sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'Pelvis_V', [segment '_X']);
        sensorStruct.(segment).P_O = [-185, 25, 0]' / 1000; % original location _imu_sim 
        sensorStruct.(segment).P_N = positions(ii,:)' / 1000; % new location _imu_new
    elseif contains(segment,'LThigh')
        sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'LThigh_V', [segment '_X']);
        sensorStruct.(segment).P_O = [130, -250, 0]' / 1000; % original location _imu_sim 
        sensorStruct.(segment).P_N = positions(ii,:)' / 1000; % new location _imu_new
    elseif contains(segment,'RThigh')
        sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'RThigh_V', [segment '_X']);
        sensorStruct.(segment).P_O = [130, -250, 0]' / 1000; % original location _imu_sim 
        sensorStruct.(segment).P_N = positions(ii,:)' / 1000; % new location _imu_new
    elseif contains(segment,'LShank')
        sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'LShank_V', [segment '_X']);
        sensorStruct.(segment).P_O = [50, -250, 0]' / 1000; % original location _imu_sim 
        sensorStruct.(segment).P_N = positions(ii,:)' / 1000; % new location _imu_new
    elseif contains(segment,'RShank')
        sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'RShank_V', [segment '_X']);
        sensorStruct.(segment).P_O = [50, -250, 0]' / 1000; % original location _imu_sim 
        sensorStruct.(segment).P_N = positions(ii,:)' / 1000; % new location _imu_new
    elseif contains(segment,'LFoot')
        sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'LFoot_V', [segment '_X']);
        sensorStruct.LFoot.P_O = [177, 25, 0]' / 1000; % original location _imu_sim 
        sensorStruct.LFoot.P_N = positions(ii,:)' / 1000; % new location _imu_new
    elseif contains(segment,'RFoot')
        sensorStruct = UpdateSensorStruct(sensorStruct, segment, 'RFoot_V', [segment '_X']);
        sensorStruct.(segment).P_O = [177, 25, 0]' / 1000; % original location _imu_sim 
        sensorStruct.(segment).P_N = positions(ii,:)' / 1000; % new location _imu_new
    end
end

sensorNames = fieldnames(sensorStruct);

for ii=1:length(subjects)
    subject = subjects{ii};
    subjectDir = fullfile(inputDir, subject);
    if ~exist(subjectDir, 'dir')
        error('Subject %s does not exist in directory %s',subject,inputDir)
    end
    
    trials = dir(subjectDir);
    trials = {trials([trials(:).isdir]).name};
    trials = trials(~(contains(trials,'.')|contains(trials,'..')));

    if ~isempty(trialNames) %find and match differently numbered trials
        trialexp = regexprep(trialNames,'_\d_\d_','.*');
        trialexp = regexprep(trialexp,'_\d_','.*');
        matches = regexp(trials,trialexp,'match','once');
        trials = intersect(trials,matches);
        if isempty(trials)
            fprintf('WARNING Subject %s missing trials: %s\n', subject, strjoin(trialNames));
        end
    end

    for jj = 1:length(trials)
        trial = trials{jj};
        trialDir = fullfile(subjectDir, trial);
        
        imuNewFilePath = fullfile(trialDir, [subject '_' trial outputExt '.csv']);
        if exist(imuNewFilePath, 'file') && ~overwrite
            fprintf("%s_%s already calculated!\n", subject, trial);
            continue;
        end

        imuSimFilePath = fullfile(trialDir, [subject '_' trial '_imu_sim.csv']);
        imuSim = readtable(imuSimFilePath);
        
        fprintf("Calculating %s.\n", imuNewFilePath);

        imuNewTable = imuSim(:, 'time');
        
        for kk=1:length(sensorNames)
            sensorName = sensorNames{kk};
            sensorNameOrig = sensorStruct.(sensorName).names.old;
            sensorNameNew = sensorStruct.(sensorName).names.new;
            accelNamesOrig = strcat(sensorNameOrig, strcat('_ACC', {'X', 'Y', 'Z'}));
            accelNamesNew = strcat(sensorNameNew, strcat('_ACC', {'X', 'Y', 'Z'}));
            gyroNamesOrig = strcat(sensorNameOrig, strcat('_GYRO', {'X', 'Y', 'Z'}));
            gyroNamesNew = strcat(sensorNameNew, strcat('_GYRO', {'X', 'Y', 'Z'}));
            
            accelOrig = imuSim(:, accelNamesOrig); % m/s^2
            gyroOrig = imuSim(:, gyroNamesOrig); % deg/s
            gyroOrig{:,:} = gyroOrig{:,:} * (pi/180); % rad/s
            
            P_O = sensorStruct.(sensorName).P_O;
            P_N = sensorStruct.(sensorName).P_N;            
            
            % Compute translation vector
            P = P_N - P_O;
            
            % First transform data back to body frame.
            gyroNew = gyroOrig{:,:};
            accelNew = accelOrig{:,:};
            [~, angAccel] = gradient(gyroNew, 0.005);
            accelNew = TranslateAccelerometer(accelNew, gyroNew, angAccel, P);
            
            % Convert gyro back to deg/s
            gyroNew = gyroNew * (180/pi); % deg/s
            
            accelNew = array2table(accelNew, 'VariableNames', accelNamesNew);
            gyroNew = array2table(gyroNew, 'VariableNames', gyroNamesNew);
            
            imuNewTable = [imuNewTable, accelNew, gyroNew];
        end
        
        fprintf("Writing %s.\n\n", imuNewFilePath);
        writetable(imuNewTable, imuNewFilePath);
    end
end

end

%% Helper Functions
function [sensorStruct] = UpdateSensorStruct(sensorStruct, name, oldName, newName)
    sensorStruct.(name) = struct();
    sensorStruct.(name).names = struct();
    sensorStruct.(name).names.old = oldName;
    sensorStruct.(name).names.new = newName;
end

function [nAcc] = TranslateAccelerometer(oAcc, angVel, angAcc, translation)
a_r = [];
w_w_r = [];
for ii=1:size(oAcc, 1)
    a_r = [a_r, cross(angAcc(ii, :)', translation)];
    c = cross(angVel(ii, :)', cross(angVel(ii, :)', translation));
    w_w_r = [w_w_r, c];
end
a_r = a_r';
w_w_r = w_w_r';

nAcc = oAcc + a_r + w_w_r;
end