import re

def group_tasks(tasks):
    """
    This function returns the grouping of each of the activities given.

    :param tasks: activities for grouping (string or list of strings)
    :return: the corresponding group for each activity (string or list of strings)
    """

    if isinstance(tasks, str):
        tasks = [tasks]
        single_input = True
    elif isinstance(tasks, list):
        single_input = False
    else:
        raise ValueError('Input must either be a string or list of strings')

    # Translation map
    all_groups = ['walk', 'incline', 'decline', 'stair_ascent', 'stair_descent', 'walk_backwards',
                  'calisthenics', 'cutting', 'meander', 'ball_toss', 'jump_across', 'jump_in_place', 'lift_weight',
                  'lunge', 'misc', 'push_pull', 'run', 'sit_stand', 'stand', 'start_stop', 'step_over', 'curb',
                  'step_ups', 'squats', 'tug_of_war', 'turn', 'twister', 'weighted_walk']
    translation_exp = ['normal.*([0-1]-[0-9]|shuffle)', 'incline.*up', 'incline.*down',
                       'stairs.*up', 'stairs.*down', 'walk_backward', '(normal.*skip)|(.+?butt-kicks)|(.+?high-knees)|(tire_run)',
                       'cutting', 'meander', 'ball_toss', '(jump.*fb)|(jump.*lateral)|(side_shuffle)', 'jump.*(hop|vertical|90|180)',
                       'lift_weight', 'lunges', '(.+?heel-walk)|(.+?toe-walk)', 'push', 'normal.*2-[0-5]', 'sit_to_stand', 'poses',
                       'start_stop', 'obstacle_walk', 'curb_(up|down)', 'step_up', 'squat', 'tug_of_war', 'turn_and_step', 'twister', 'weighted_walk']

    groups = tasks.copy()
    for expression, group in zip(translation_exp, all_groups):
        pattern = re.compile(expression)
        groups = [pattern.sub(group, task) for task in groups]

    if single_input:
        return groups[0]
    else:
        return groups

# # Example usage
# example_tasks = ['cutting_1_left-slow', 'dynamic_walk_1_toe-walk', 'normal_walk_1_0-6']
# groups = group_tasks(example_tasks)
# print(groups)
