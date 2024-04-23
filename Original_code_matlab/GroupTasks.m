function groups = GroupTasks(tasks)
% This function returns the grouping of each of the activities given

%INPUTS
% activities (string or cell array): activities for grouping

%OUTPUTS
% groups (string or cell array): the corresponding group for each activity

%example: groups = GroupTasks({'cutting_1_left-slow','dynamic_walk_1_toe-walk','normal_walk_1_0-6'});

if ischar(tasks)
    single_input = true;
    tasks = {tasks};
elseif iscellstr(tasks)
    single_input = false;
else
    error('Input must either be a string or cell array of strings');
end

%translation map
all_groups = {'walk', 'incline', 'decline', 'stair_ascent', 'stair_descent', 'walk_backwards',...
    'calisthenics', 'cutting', 'meander', 'ball_toss', 'jump_across', 'jump_in_place', 'lift_weight', 'lunge',...
    'misc', 'push_pull', 'run', 'sit_stand', 'stand', 'start_stop', 'step_over', 'curb', 'step_ups', 'squats',...
    'tug_of_war', 'turn', 'twister', 'weighted_walk'};
translation_exp = {'normal.*([0-1]-[0-9]|shuffle)', 'incline.*up', 'incline.*down',...
    'stairs.*up', 'stairs.*down', 'walk_backward', '(normal.*skip)|(.+?butt-kicks)|(.+?high-knees)|(tire_run)',...
    'cutting', 'meander', 'ball_toss', '(jump.*fb)|(jump.*lateral)|(side_shuffle)', 'jump.*(hop|vertical|90|180)',...
    'lift_weight', 'lunges', '(.+?heel-walk)|(.+?toe-walk)', 'push', 'normal.*2-[0-5]', 'sit_to_stand', 'poses',...
    'start_stop', 'obstacle_walk', 'curb_(up|down)', 'step_up', 'squat', 'tug_of_war', 'turn_and_step', 'twister', 'weighted_walk'};


groups = tasks;
for ii = 1:length(translation_exp)
    expression = [translation_exp{ii} '.*'];
    group = all_groups{ii};
    groups = regexprep(groups,expression,group);
end

if single_input
    groups = groups{1};
end

end
