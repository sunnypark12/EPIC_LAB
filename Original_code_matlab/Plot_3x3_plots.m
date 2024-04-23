function Plot_3x3_plots(dataDir,trials,legs,trial_title,flyaway_on,compare_mode)

%INPUTS
% dataDir (directory path for segmentation data)
% trials (cell array of chars)
% legs (cell array of chars: 'left' or'right' for the correct side to plot for that trial)
% trial_title (char for title at the top of the plot)
% flyaway_on (boolean for turning on and off flyaways)
% compare_mode (integer > 0 to allow multiple plots on the same graph with the default color associated with that integer) 

%OUTPUTS
% no direct outputs except plots with across subject averages

subjects = dir(dataDir);
subjects = {subjects([subjects(:).isdir]).name};
subjects = subjects(contains(subjects,'AB'));
if isempty(subjects)
    error('No subjects found. Please select the Segmentation folder with folders AB01...')
end

if nargin < 5
    flyaway_on = 0;
    compare_mode = 0;
elseif nargin < 6
    compare_mode = 0; %compare mode allows you to put multiple averages on the same plot with the color set to comparemode value
end

if flyaway_on
    by_leg = false; % turn this on if you want to see the individual legs
end

if length(trials) ~= length(legs)
    error('Each trial must have an assigned leg');
end

%load data
sub_count = 0;
for ii = 1:length(subjects)
    subject = subjects{ii};
    count = 0;
    for jj = 1:length(trials)
        trial = trials{jj};
        side = legs{jj};
        try
            if strcmp(trial,'jump_1_vertical') && strcmp(subject,'AB07') % this subject used a different jumping style that is not comparable to the rest of the subjects
                continue
            elseif contains(trial,'jump_3_90-2_segmented') && strcmp(subject,'AB03') % this subject used a different jumping style that isnt comparable to the rest of the subjects
                continue
            end
            if contains(trial,'_segmented')
                load(fullfile(dataDir, subject, [trial '.mat']), 'angle','moment_filt','power')
            else
                load(fullfile(dataDir, subject, [trial '_segmented.mat']), 'angle','moment_filt','power')
            end
        catch
            files = dir(fullfile(dataDir, subject));
            files = {files(~[files(:).isdir]).name};
            trialexp = regexprep(trial,'_\d_\d_','.*');
            trialexp = regexprep(trialexp,'_\d_','.*');
            files = files(~cellfun(@isempty, regexp(files,trialexp))&contains(files,'segmented'));
            switch length(files)
                case 0
                    fprintf('Missing data for subject %s trial %s. Skipping %s\n',subject, trial, subject)
                    continue
                case 1
                    load(fullfile(dataDir, subject, files{1}), 'angle','moment_filt','power')
                otherwise
                    fprintf('WARNING Too many matching trials for subject %s trial %s. Skipping %s\n',subject, trial, subject)
                    continue
            end
        end
    
        %check for missing values
        if contains(side,'right')
            if ~isempty(angle.avg_r)
                count = count + 1;

                angle.avg_r.sig_mu.Properties.VariableNames = replace(angle.avg_r.sig_mu.Properties.VariableNames,'_r','');
                angle_sub(count).data = angle.avg_r.sig_mu;
                angle_sub(count).time = angle.avg_r.pct;
                angle_sub(count).ID = [subject ' ' side];
        
                moment_filt.avg_r.sig_mu.Properties.VariableNames = replace(moment_filt.avg_r.sig_mu.Properties.VariableNames,'_r','');
                moment_sub(count).data = moment_filt.avg_r.sig_mu;
                moment_sub(count).time = moment_filt.avg_r.pct;
                moment_sub(count).ID = [subject ' ' side];
        
                power.avg_r.sig_mu.Properties.VariableNames = replace(power.avg_r.sig_mu.Properties.VariableNames,'_r','');
                power_sub(count).data = power.avg_r.sig_mu;
                power_sub(count).time = power.avg_r.pct;
                power_sub(count).ID = [subject ' ' side];
            else
                fprintf('Missing right leg data for subject %s trial %s\n',subject, trial)
            end

        elseif contains(side,'left')
            if ~isempty(angle.avg_l)
                count = count + 1;

                angle.avg_l.sig_mu.Properties.VariableNames = replace(angle.avg_l.sig_mu.Properties.VariableNames,'_l','');
                angle_sub(count).data = angle.avg_l.sig_mu;
                angle_sub(count).time = angle.avg_l.pct;
                angle_sub(count).ID = [subject ' ' side];
        
                moment_filt.avg_l.sig_mu.Properties.VariableNames = replace(moment_filt.avg_l.sig_mu.Properties.VariableNames,'_l','');
                moment_sub(count).data = moment_filt.avg_l.sig_mu;
                moment_sub(count).time = moment_filt.avg_l.pct;
                moment_sub(count).ID = [subject ' ' side];
        
                power.avg_l.sig_mu.Properties.VariableNames = replace(power.avg_l.sig_mu.Properties.VariableNames,'_l','');
                power_sub(count).data = power.avg_l.sig_mu;
                power_sub(count).time = power.avg_l.pct;
                power_sub(count).ID = [subject ' ' side];
            else
                fprintf('Missing left leg data for subject %s trial %s\n',subject, trial)
            end
        end
    end
    if count == 0
        fprintf('Missing data for subject %s trial %s. Skipping %s\n',subject, trial, subject)
        continue
    elseif flyaway_on && ~by_leg && count > 1 %more than one leg to average
        sub_count = sub_count + 1;

        avg_across_legs_angle = ens_avg_cyc_plot(angle_sub);
        angle_all(sub_count).data = avg_across_legs_angle.sig_mu;
        angle_all(sub_count).time = avg_across_legs_angle.pct;
        angle_all(sub_count).ID = subject;

        avg_across_legs_moment = ens_avg_cyc_plot(moment_sub);
        moment_all(sub_count).data = avg_across_legs_moment.sig_mu;
        moment_all(sub_count).time = avg_across_legs_moment.pct;
        moment_all(sub_count).ID = subject;

        avg_across_legs_power = ens_avg_cyc_plot(power_sub);
        power_all(sub_count).data = avg_across_legs_power.sig_mu;
        power_all(sub_count).time = avg_across_legs_power.pct;
        power_all(sub_count).ID = subject;
    else
        for ii = 1:length(angle_sub)
            angle_all(ii+sub_count) = angle_sub(ii);
            moment_all(ii+sub_count) = moment_sub(ii);
            power_all(ii+sub_count) = power_sub(ii);

            if flyaway_on && ~by_leg
                angle_all(ii+sub_count).ID = subject;
                moment_all(ii+sub_count).ID = subject;
                power_all(ii+sub_count).ID = subject;
            end
        end
        sub_count = sub_count+ii;
    end
end

%flip hip and ankle for angle and moment since OpenSim defines them differently
for kk = 1:length(angle_all)
    angle_all(kk).data.ankle_angle = -1*angle_all(kk).data.ankle_angle;
    angle_all(kk).data.hip_flexion = -1*angle_all(kk).data.hip_flexion;
    moment_all(kk).data.hip_flexion_moment = -1*moment_all(kk).data.hip_flexion_moment;
    moment_all(kk).data.ankle_angle_moment = -1*moment_all(kk).data.ankle_angle_moment;
end

%%%plotting
if compare_mode == 0
    %create named figure for easy saving
    if isempty(regexp(trial_title,'^\d','match','once'))
        figure('name',regexprep(trial_title,'{.*}','_'));
    else
        new_name = strsplit(regexprep(trial_title,'{.*}','_ '),' ');
        new_name([1 2]) = new_name([2 1]);
        new_name = join(new_name,' ');
        figure('name',new_name{1});
    end
    co = 1;% color
else
    co = compare_mode;% color
end

%hip angle
subplot(3,3,1)
ens_avg_cyc_plot(angle_all,1,co,'hip_flexion',flyaway_on);
title('Hip')
ylabel({'\bf Angle','\rm','Angle ({\circ})'});

%knee angle
subplot(3,3,2)
ens_avg_cyc_plot(angle_all,1,co,'knee_angle',flyaway_on);
title('Knee')
ylabel('Angle ({\circ})');

%ankle angle
subplot(3,3,3)
ens_avg_cyc_plot(angle_all,1,co,'ankle_angle',flyaway_on);
title('Ankle')
ylabel('Angle ({\circ})');

%hip moment
subplot(3,3,4)
ens_avg_cyc_plot(moment_all,1,co,'hip_flexion_moment',flyaway_on);
ylabel({'\bf Moment','\rm','Moment (Nm/kg)'});

%knee moment
subplot(3,3,5)
ens_avg_cyc_plot(moment_all,1,co,'knee_angle_moment',flyaway_on);
ylabel('Moment (Nm/kg)');

%ankle moment
subplot(3,3,6)
ens_avg_cyc_plot(moment_all,1,co,'ankle_angle_moment',flyaway_on);
ylabel('Moment (Nm/kg)');

%hip power
subplot(3,3,7)
ens_avg_cyc_plot(power_all,1,co,'hip_flexion_power',flyaway_on);
ylabel({'\bf Power','\rm','Power (W/kg)'});

%knee power
subplot(3,3,8)
ens_avg_cyc_plot(power_all,1,co,'knee_power',flyaway_on);
ylabel('Power (W/kg)');

%ankle power
subplot(3,3,9)
ens_avg_cyc_plot(power_all,1,co,'ankle_power',flyaway_on);
ylabel('Power (W/kg)');

sgtitle(trial_title);

end

%% Helper functions

function [ens] = ens_avg_cyc_plot(data,plotOn,col,name,flyaway_on)
%INPUTS
% data (struct with data field and time field where data is a table)
% plotOn (boolean for turning on and off plotting)
% col (1x3 for RGB color)
% name (str for column of data table to plot)
% flyaway_on (boolean for turning on and off flyaways)

    if nargin<2
        plotOn = 0;
        name = [];
    end
    if nargin < 5
        flyaway_on = false;
    end
    if isempty(data)
        ens = [];
        return
    end
    cycleCell = {data.data};

    nChan = width(cycleCell{1});
    names = cycleCell{1}.Properties.VariableNames;
    if isempty(name)
        idx_names = 1:length(names);
    else
        idx_names = find(contains(names, name), 1);
    end
    
    % Time warp
    for i = 1:length(cycleCell)
        len(i) = height(cycleCell{i});
    end 
    len_mu = round(mean(len));
    pct_mu = linspace(0,100,len_mu);
    sig_rs = [];
    for i = 1:length(cycleCell)
        if length(idx_names) == 1 %because interp transposes the vector if it's a single column
            sig_rs = cat(3,sig_rs,interp1(1:len(i),cycleCell{i}{:,idx_names},1:(len(i)-1)/(len_mu-1):len(i))');
        else
            sig_rs = cat(3,sig_rs,interp1(1:len(i),cycleCell{i}{:,idx_names},1:(len(i)-1)/(len_mu-1):len(i)));
        end
    end 
    
    % ENSEMBLE AVG
    sig_mu = mean(sig_rs,3,'omitnan');
    sig_sd = std(sig_rs,[],3,'omitnan');
    ens.pct = pct_mu;
    if isempty(name)
        ens.sig_mu = array2table(sig_mu,'VariableNames',names);
        ens.sig_sd = array2table(sig_sd,'VariableNames',names);
    else
        ens.sig_mu = sig_mu';
        ens.sig_sd = sig_sd';
    end
    
    %%% PLOT
    if plotOn
        hold on;
        co = lines;
        flyaways = 0.8;
        alphaval = 0.25;
        for ii = 1:length(idx_names)
            if length(idx_names) == 1
                chan = 1;
            else
                chan = idx_names(ii);
            end
            for i = 1:length(cycleCell)
                pct_cyc = linspace(0,100,length(cycleCell{i}.(name)(:,chan)));
                if flyaway_on
                    p = plot(pct_cyc,cycleCell{i}.(name)(:,chan),'color',flyaways*[1 1 1],'linewidth',0.5);
                    if any(contains(fieldnames(data),'ID'))
                        row = dataTipTextRow('ID',repmat({data(i).ID},1,length(pct_cyc)));
                        p.DataTipTemplate.DataTipRows(end+1) = row;
                    end
                end
            end
            plot(pct_mu,sig_mu(:,chan),'color',co(col,:),'linewidth',2);
            h(chan) = plotFill(pct_mu,sig_mu(:,chan),sig_sd(:,chan),co(col,:));
            alpha(h(chan),alphaval);
        end
        xlim([pct_mu(1) pct_mu(end)]);
        xlabel('% cycle');
        ylabel('Signal value');
    end
end

function [h] = plotFill(t,mu,dev,c)
 %INPUTS
  % t: time (or cycle)
  % mu: mean to be plotted around
  % dev: deviation +/- around mean to be filled.
  % c: color ([R G B])
  
  % Using row vectors
  if ~isrow(t)
    t = t;
  end

  if ~isrow(mu)
    mu = mu;
  end

  if ~isrow(dev)
    devH = dev;
  else
    devH = dev;
  end
  devL = -devH;

  hi = mu + devH;
  lo = mu + devL;

  areaT = [t, fliplr(t)];
  areaY = [lo, fliplr(hi)];

  h = fill(areaT, areaY, c, 'EdgeColor','None','HandleVisibility','off');
end
