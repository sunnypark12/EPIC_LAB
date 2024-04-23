%% Setup
inputDir = uigetdir(pwd, 'Select the Segmentation folder');
%% Walk


Plot_3x3_plots(inputDir,{'weighted_walk_1_25lbs'},{'left'},'Weighted Walk 1.25 m/s (25lb)',1)
%% Shuffling & Skipping
Plot_3x3_plots(inputDir,{'normal_walk_1_shuffle'},{'left'},'Shuffling 0.4 m/s',1)
Plot_3x3_plots(inputDir,{'normal_walk_1_skip'},{'left'},'Skipping 1.2 m/s',1)

%% Running
Plot_3x3_plots(inputDir,{'normal_walk_1_2-0','normal_walk_1_2-0'},{'left','right'},'Running 2.0 m/s',1)
Plot_3x3_plots(inputDir,{'normal_walk_1_2-5','normal_walk_1_2-5'},{'left','right'},'Running 2.5 m/s',1)

%% Walking Backward
Plot_3x3_plots(inputDir,{'walk_backward_1_0-6'},{'left'},'Backward Walking 0.6 m/s',1)
Plot_3x3_plots(inputDir,{'walk_backward_1_0-8'},{'left'},'Backward Walking 0.8 m/s',1)
Plot_3x3_plots(inputDir,{'walk_backward_1_1-0'},{'left'},'Backward Walking 1.0 m/s',1)

%% Calisthenics
Plot_3x3_plots(inputDir,{'dynamic_walk_1_butt-kicks'},{'left'},'Butt Kicks 0.8 m/s',1)
Plot_3x3_plots(inputDir,{'dynamic_walk_1_high-knees'},{'left'},'High Knees 0.8 m/s',1)
Plot_3x3_plots(inputDir,{'dynamic_walk_1_heel-walk'},{'left'},'Heel Walk 0.4 m/s',1)
Plot_3x3_plots(inputDir,{'dynamic_walk_1_toe-walk'},{'left'},'Toe Walk 0.4 m/s',1)

%% Inclines
Plot_3x3_plots(inputDir,{'incline_walk_1_up5'},{'left'},'5{\circ} Incline 1.2 m/s',1)
Plot_3x3_plots(inputDir,{'incline_walk_1_down5'},{'right'},'5{\circ} Decline 1.2 m/s',1)
Plot_3x3_plots(inputDir,{'incline_walk_2_up10'},{'left'},'10{\circ} Incline 1.2 m/s',1)
Plot_3x3_plots(inputDir,{'incline_walk_2_down10'},{'right'},'10{\circ} Decline 1.2 m/s',1)

%% Ball Toss
Plot_3x3_plots(inputDir,{'ball_toss_1_center','ball_toss_1_center'},{'right','left'},'Ball Toss Center',1)
Plot_3x3_plots(inputDir,{'ball_toss_1_left','ball_toss_1_right'},{'right','left'},'Ball Toss Side Leading Leg',1)
Plot_3x3_plots(inputDir,{'ball_toss_1_left','ball_toss_1_right'},{'left','right'},'Ball Toss Side Trailing Leg',1)

%% Curbs
Plot_3x3_plots(inputDir,{'curb_up_1_segmented_left','curb_up_1_segmented_right'},{'left','right'},'Curb Up (Trailing Leg)',1)
Plot_3x3_plots(inputDir,{'curb_up_1_segmented_left','curb_up_1_segmented_right'},{'right','left'},'Curb Up (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'curb_down_1_segmented_left','curb_down_1_segmented_right'},{'left','right'},'Curb Down (Trailing Leg)',1)
Plot_3x3_plots(inputDir,{'curb_down_1_segmented_left','curb_down_1_segmented_right'},{'right','left'},'Curb Down (Leading Leg)',1)

%% Jumps
Plot_3x3_plots(inputDir,{'jump_1_vertical','jump_1_vertical'},{'right','left'},'Vertical Jumps',1)
Plot_3x3_plots(inputDir,{'jump_1_fb_segmented_forward','jump_1_fb_segmented_forward'},{'right','left'},'Forward Jumps',1)
Plot_3x3_plots(inputDir,{'jump_1_fb_segmented_backward','jump_1_fb_segmented_backward'},{'right','left'},'Backward Jumps',1)
Plot_3x3_plots(inputDir,{'jump_1_hop','jump_1_hop'},{'right','left'},'Hopping',1)

Plot_3x3_plots(inputDir,{'jump_2_180','jump_2_180'},{'right','left'},'180{\circ} Jumps',1)
Plot_3x3_plots(inputDir,{'jump_2_lateral','jump_2_lateral'},{'right','left'},'Lateral Jumps',1)

Plot_3x3_plots(inputDir,{'jump_3_90-1_segmented_backward','jump_3_90-1_segmented_forward'},{'left','right'},'90{\circ} Jumps (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'jump_3_90-1_segmented_backward','jump_3_90-1_segmented_forward'},{'right','left'},'90{\circ} Jumps (Trailing Leg)',1)

Plot_3x3_plots(inputDir,{'jump_3_90-2_segmented_left','jump_3_90-2_segmented_left','jump_3_90-2_segmented_right','jump_3_90-2_segmented_right'},{'right','left','right','left'},'90{\circ} Lateral Jumps',1)

%% Cutting
Plot_3x3_plots(inputDir,{'cutting_1_left-fast','cutting_1_right-fast'},{'left','right'},'Cutting Fast (Inside Leg)',1)
Plot_3x3_plots(inputDir,{'cutting_1_left-fast','cutting_1_right-fast'},{'right','left'},'Cutting Fast (Outside Leg)',1)

Plot_3x3_plots(inputDir,{'cutting_1_left-slow','cutting_1_right-slow'},{'left','right'},'Cutting Slow (Inside Leg)',1)
Plot_3x3_plots(inputDir,{'cutting_1_left-slow','cutting_1_right-slow'},{'right','left'},'Cutting Slow (Outside Leg)',1)

%% Lift Weight
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-c','lift_weight_1_25lbs-r-c'},{'left','right'},'Lifting Weight 25lb Center (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-l','lift_weight_1_25lbs-r-r'},{'left','right'},'Lifting Weight 25lb Side (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-c','lift_weight_1_25lbs-r-c'},{'right','left'},'Lifting Weight 25lb Center (Trailing Leg)',1)
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-l','lift_weight_1_25lbs-r-r'},{'right','left'},'Lifting Weight 25lb Side (Trailing Leg)',1)

Plot_3x3_plots(inputDir,{'lift_weight_2_0lbs-l-c','lift_weight_2_0lbs-r-c'},{'left','right'},'Lifting Weight 0lb Center (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'lift_weight_2_0lbs-l-l','lift_weight_2_0lbs-r-r'},{'left','right'},'Lifting Weight 0lb Side (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'lift_weight_2_0lbs-l-c','lift_weight_2_0lbs-r-c'},{'right','left'},'Lifting Weight 0lb Center (Trailing Leg)',1)
Plot_3x3_plots(inputDir,{'lift_weight_2_0lbs-l-l','lift_weight_2_0lbs-r-r'},{'right','left'},'Lifting Weight 0lb Side (Trailing Leg)',1)

%% Lunges
Plot_3x3_plots(inputDir,{'lunges_1_segmented_forward_left','lunges_1_segmented_forward_right'},{'left','right'},'Forward Lunge (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'lunges_1_segmented_backward_left','lunges_1_segmented_backward_right'},{'left','right'},'Backward Lunge (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'lunges_1_segmented_forward_left','lunges_1_segmented_forward_right'},{'right','left'},'Forward Lunge (Trailing Leg)',1)
Plot_3x3_plots(inputDir,{'lunges_1_segmented_backward_left','lunges_1_segmented_backward_right'},{'right','left'},'Backward Lunge (Trailing Leg)',1)

Plot_3x3_plots(inputDir,{'lunges_2_left','lunges_2_right'},{'left','right'},'Side Lunge (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'lunges_2_left','lunges_2_right'},{'right','left'},'Side Lunge (Trailing Leg)',1)

%% Side Shuffle
Plot_3x3_plots(inputDir,{'side_shuffle_1_segmented_left','side_shuffle_1_segmented_right'},{'left','right'},'Side Shuffle (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'side_shuffle_1_segmented_left','side_shuffle_1_segmented_right'},{'right','left'},'Side Shuffle (Trailing Leg)',1)

%% Sit to Stand
%sitting
Plot_3x3_plots(inputDir,{'sit_to_stand_1_short-noarm_segmented_sitting','sit_to_stand_1_short-noarm_segmented_sitting'},{'left','right'},'Sitting Short Chair (No Armrests)',1)
Plot_3x3_plots(inputDir,{'sit_to_stand_1_short-arm_segmented_sitting','sit_to_stand_1_short-arm_segmented_sitting'},{'left','right'},'Sitting Short Chair (Armrests)',1)
Plot_3x3_plots(inputDir,{'sit_to_stand_2_tall-noarm_segmented_sitting','sit_to_stand_2_tall-noarm_segmented_sitting'},{'left','right'},'Sitting Tall Chair (No Armrests)',1)
%standing
Plot_3x3_plots(inputDir,{'sit_to_stand_1_short-noarm_segmented_standing','sit_to_stand_1_short-noarm_segmented_standing'},{'left','right'},'Standing Short Chair (No Armrests)',1)
Plot_3x3_plots(inputDir,{'sit_to_stand_1_short-arm_segmented_standing','sit_to_stand_1_short-arm_segmented_standing'},{'left','right'},'Standing Short Chair (Armrests)',1)
Plot_3x3_plots(inputDir,{'sit_to_stand_2_tall-noarm_segmented_standing','sit_to_stand_2_tall-noarm_segmented_standing'},{'left','right'},'Standing Tall Chair (No Armrests)',1)

%% Squats
Plot_3x3_plots(inputDir,{'squats_1_0lbs','squats_1_0lbs'},{'left','right'},'Squats 0 lbs',1)
Plot_3x3_plots(inputDir,{'squats_1_25lbs','squats_1_25lbs'},{'left','right'},'Squats 25 lbs',1)

%% Stairs
Plot_3x3_plots(inputDir,{'stairs_1_up','stairs_1_up'},{'left','right'},'Stairs Up',1)
Plot_3x3_plots(inputDir,{'stairs_1_down','stairs_1_down'},{'left','right'},'Stairs Down',1)

%% Tire Run
Plot_3x3_plots(inputDir,{'tire_run_1_segmented_left','tire_run_1_segmented_right'},{'left','right'},'Tire Run (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'tire_run_1_segmented_left','tire_run_1_segmented_right'},{'right','left'},'Tire Run (Trailing Leg)',1)

%% Turn and Step
Plot_3x3_plots(inputDir,{'turn_and_step_1_left-turn','turn_and_step_1_right-turn'},{'left','right'},'Turns (Trailing Leg segmented by toe off)',1)
Plot_3x3_plots(inputDir,{'turn_and_step_1_left-turn','turn_and_step_1_right-turn'},{'right','left'},'Turns (Leading Leg segmented by toe off)',1)

%% Step Ups
Plot_3x3_plots(inputDir,{'step_ups_1_left_segmented_up','step_ups_1_right_segmented_up'},{'left','right'},'Step Ups - Up (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'step_ups_1_left_segmented_up','step_ups_1_right_segmented_up'},{'right','left'},'Step Ups - Up (Trailing Leg)',1)
Plot_3x3_plots(inputDir,{'step_ups_1_left_segmented_down','step_ups_1_right_segmented_down'},{'left','right'},'Step Ups - Down (Leading Leg)',1)
Plot_3x3_plots(inputDir,{'step_ups_1_left_segmented_down','step_ups_1_right_segmented_down'},{'right','left'},'Step Ups - Down (Trailing Leg)',1)

%% Comparison examples
%lift weight
figure;
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-c'},{'left'},'Lifting Weight',0,1)
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-l'},{'left'},'Lifting Weight',0,2)
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-r-c'},{'right'},'Lifting Weight',0,3)
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-r-r'},{'right'},'Lifting Weight Leading Leg Comparison',0,4)
legend('Center left','Side left','Center right','Side right')

figure;
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-c'},{'right'},'Lifting Weight',0,1)
Plot_3x3_plots(inputDir,{'lift_weight_1_25lbs-l-l'},{'right'},'Lifting Weight Trailing Leg Comparison',0,2)
legend('Center','Side')

%tire run
figure;
Plot_3x3_plots(inputDir,{'tire_run_1_segmented_left','tire_run_1_segmented_right'},{'left','right'},'Tire Run (Leading Leg)',0,1)
Plot_3x3_plots(inputDir,{'tire_run_1_segmented_left','tire_run_1_segmented_right'},{'right','left'},'Tire Run',0,2)
legend('Leading Leg','Trailing Leg')

%sit to stand
figure;
Plot_3x3_plots(inputDir,{'sit_to_stand_1_short-noarm_segmented_sitting','sit_to_stand_1_short-noarm_segmented_sitting'},{'left','right'},'Sitting Short Chair (No Armrests)',0,1)
Plot_3x3_plots(inputDir,{'sit_to_stand_1_short-arm_segmented_sitting','sit_to_stand_1_short-arm_segmented_sitting'},{'left','right'},'Sitting Short Chair (Armrests v. No Armrests)',0,2)
legend('No Armrests','Armrests')

figure;
Plot_3x3_plots(inputDir,{'sit_to_stand_1_short-noarm_segmented_sitting','sit_to_stand_1_short-noarm_segmented_sitting'},{'left','right'},'Sitting Short Chair (No Armrests)',0,1)
Plot_3x3_plots(inputDir,{'sit_to_stand_2_tall-noarm_segmented_sitting','sit_to_stand_2_tall-noarm_segmented_sitting'},{'left','right'},'Sitting Tall v Short Chair (No Armrests)',0,2)
legend('Short','Tall')

%cutting
figure;
Plot_3x3_plots(inputDir,{'cutting_1_left-fast','cutting_1_right-fast'},{'left','right'},'Cutting Fast (Inside Leg)',0,1)
Plot_3x3_plots(inputDir,{'cutting_1_left-fast','cutting_1_right-fast'},{'right','left'},'Cutting Fast',0,2)
legend('Inside','Outside')

%squats
figure;
Plot_3x3_plots(inputDir,{'squats_1_0lbs','squats_1_0lbs'},{'left','right'},'Squats 0 lbs',0,1)
Plot_3x3_plots(inputDir,{'squats_1_25lbs','squats_1_25lbs'},{'left','right'},'Squats 0 lbs v 25 lbs',0,2)
legend('0 lbs','25 lbs')