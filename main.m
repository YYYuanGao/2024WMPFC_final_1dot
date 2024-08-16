%% for WM PFC columnar imaging
% by Ke Jia 2022-11-07 14:08
% editted by Yinghua @ 2023-05-18 14:30
% editted by Yuan    @ 2023-09-12 08:30
% editted by Yuan    @ 2023-12-29 10:54

clear all; 
clc;

%% parameters need to be changed
SubjID  = 's15';
Curr_AngleDelta = 2.813;
SessID  = 1;
RunID   = 6;
fMRI_Run_Num = 10;
% Behav_Run_Num = 3;
% Train_Run_Num = 5;
% CounBalance = 1; % 1 for uniformly distribution

% offset = [80,10];  % zss1
% offset = [1,-117.5];  % x positive--right; y postive--down
% offset = [0,-200]; % CYT
offset = [0,0]; %ZHY-50

%%  
CurrDir = pwd;
warning off;
SetupRand;
% set_test_gamma;
HideCursor;
parameters;

%% 
% line400pixels; % should be around 9.1 cm21212
% PreScanFixation; % radius 3.5 degrees display
% CalculateVisibleArea(SubjID,1,1);sca
% RSfixation;

%% for motion experiment
% Sample_motion;  % radius 5 degrees disk
% wm_motion_fMRI;
% wm_motion_behavior;

%% choose dir
% directions = [15, 75, 135, 195, 255, 315];
% randomIndex = randi(numel(directions));
% randomDirection = directions(randomIndex);
% dir_train = 195;
%% for location experiment
wm_spatial_sample;
% wm_spatial_fMRI_color2;

delete *.asv
