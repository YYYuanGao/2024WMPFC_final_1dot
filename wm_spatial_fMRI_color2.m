% Working Memory PFC columnar imaging with spatial task
% Samples at different directions are shown at the same time with different
% colors
% By Yuan    @ 20230426
% By Yinghua @ 20230518
% By Yuan    @ 20230905
% By Yuan    @ 20231223
% By Xin     @ 20231229
% By Yuan    @ 20231229

%% 

resDir = [CurrDir '\Results\fMRI\' SubjID '\'];
if ~isdir(resDir)
    mkdir(resDir);
end

if exist([resDir SubjID '_Sess' num2str(SessID) '_spatialTask__color_run' num2str(RunID) '.mat'],'file')
    ShowCursor;
    Screen('CloseAll');
    reset_test_gamma;
    warning on;
    error('This run number has been tested, please enter a new run num!');
end

results = zeros(Param.DisfMRI.TrialNum,8);
timePoints = zeros(Param.DisfMRI.TrialNum,7);
trial_index = randperm(Param.DisfMRI.TrialNum);
trial_index = mod(trial_index,Param.Discri.DirectionNum)+1;

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Results Matrix %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1- trial number           2- visual field location
% 3- sample baseline        4- task_diff
% 5- test angle             6- response, 1 = left, 2 = right
% 7- acc, 1 = right, 0 = wrong 
% 8- sample actual
% 9- ITI time (s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% TimePoint Matrix %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1- trial onset            2- fix onset delay   
% 3- Sample duration        4- Delay duration
% 5- Test duration          6- RT
% 7- trial duration         8- 
% 9-                        10- 
%% Main experiment
%% Display hint
curr_textBounds = Screen('TextBounds', wnd,'Task will begin soon');
DrawFormattedText(wnd,'Task will begin soon', ...
    Param.Stimuli.Locations(Param.Stimuli.LocationUsed,1)-curr_textBounds(3)/2, ...
    Param.Stimuli.Locations(Param.Stimuli.LocationUsed,2)-curr_textBounds(4)/2, ...
    white);
Screen('Flip',wnd);
while true
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyCode(Param.Keys.Trigger1)
        break;
    elseif keyCode(Param.Keys.EscPress)
        abort;
    end
end

%% Dummy scans
Exp_Start = GetSecs;
Screen('FillOval', wnd, Param.Fixation.OvalColor, Param.Fixation.OvalLoc);
Screen('DrawLines', wnd, Param.Fixation.CrossLoc, Param.Fixation.CrossWidth, Param.Fixation.CrossColor, [], 1);
Screen('Flip',wnd);
WaitSecs(Param.DisfMRI.Dummy);

%% Spatial task
% ITI_squences = [ones(Param.DisfMRI.TrialNum/2,1);repmat(2,Param.DisfMRI.TrialNum/2,1)];
% results(:,9) = ITI_squences(randperm(Param.DisfMRI.TrialNum));

for trial_i = 1:Param.DisfMRI.TrialNum
    results(trial_i,1) = trial_i;
    results(trial_i,2) = Param.Stimuli.LocationUsed;
    
    % task diff
    results(trial_i,4) = Curr_AngleDelta;
    jitter_temp = sign(rand-0.5);
    if jitter_temp == 0
        jitter_temp = 1;
    end
    curr_jitter = jitter_temp * results(trial_i,4);
    
    % determine location
    results(trial_i,3) = Param.Discri.Directions(trial_index(trial_i));  % target location = first sample
    temp_loc = randi(Param.Discri.DirectionNum-1);

    % task start time
    trial_onset = GetSecs;
    timePoints(trial_i,1) = trial_onset;
  
    %% base location
    curr_loc = zeros(2,2); 
    results(trial_i,8) = results(trial_i,3) + (rand - 0.5) * 2 *Param.SpatialDot.AngleJitter;
    results(trial_i,5) = results(trial_i,8) + curr_jitter;
    curr_loc(1,1) = Param.SpatialDot.OuterRadius * cos(results(trial_i,8)/180*pi)+Param.Stimuli.Locations(3,1);
    curr_loc(1,2) = Param.SpatialDot.OuterRadius * sin(results(trial_i,8)/180*pi)+Param.Stimuli.Locations(3,2);
    curr_loc(2,1) = Param.SpatialDot.OuterRadius * cos(results(trial_i,5)/180*pi)+Param.Stimuli.Locations(3,1);
    curr_loc(2,2) = Param.SpatialDot.OuterRadius * sin(results(trial_i,5)/180*pi)+Param.Stimuli.Locations(3,2);

   %% dot color
    curr_color_temp = randperm(Param.Discri.DirectionNum,1);
    curr_color(1,:) = Param.SpatialDot.DiskColor;

%% Go!
    %% Sample
    Screen('FillOval',wnd,curr_color(1,:),[curr_loc(1,1)-Param.SpatialDot.DotSize, curr_loc(1,2)-Param.SpatialDot.DotSize,curr_loc(1,1)+Param.SpatialDot.DotSize,curr_loc(1,2)+Param.SpatialDot.DotSize]);
    Screen('FillOval',wnd,Param.Fixation.OvalColor,Param.Fixation.OvalLoc);
    Screen('DrawLines',wnd,Param.Fixation.CrossLoc,Param.Fixation.CrossWidth,Param.Fixation.CrossColor,[],1);
    vbl = Screen('Flip',wnd);
    timePoints(trial_i,2) = vbl-timePoints(trial_i,1);

    %% Delay
    Screen('FillOval',wnd,Param.Fixation.OvalColor,Param.Fixation.OvalLoc);
    Screen('DrawLines',wnd,Param.Fixation.CrossLoc,Param.Fixation.CrossWidth,Param.Fixation.CrossColor,[],1);
    vbl = Screen('Flip',wnd,vbl + Param.Trial.durColor);
%     timePoints(trial_i,3) = vbl - sum(timePoints(trial_i,1:2));
    timePoints(trial_i,3) = vbl - sum(timePoints(trial_i,1:2));


    %% test
    Screen('FillOval',wnd,curr_color(1,:),[curr_loc(2,1)-Param.SpatialDot.DotSize, curr_loc(2,2)-Param.SpatialDot.DotSize,curr_loc(2,1)+Param.SpatialDot.DotSize,curr_loc(2,2)+Param.SpatialDot.DotSize]);
    Screen('FillOval',wnd,Param.Fixation.OvalColor,Param.Fixation.OvalLoc);
    Screen('DrawLines',wnd,Param.Fixation.CrossLoc,Param.Fixation.CrossWidth,Param.Fixation.CrossColor,[],1);
    vbl = Screen('Flip',wnd,vbl+Param.Trial.Delay);
%     timePoints(trial_i,4) = vbl - sum(timePoints(trial_i,1:3));
    timePoints(trial_i,4) = vbl - sum(timePoints(trial_i,1:3));


    %% response
    Screen('FillOval',wnd,Param.Fixation.OvalColor,Param.Fixation.OvalLoc);
    Screen('DrawLines',wnd,Param.Fixation.CrossLoc,Param.Fixation.CrossWidth,Param.Fixation.CrossColor,[],1);
    vbl = Screen('Flip',wnd,vbl+Param.Trial.testColor);
    timePoints(trial_i,5) = vbl - sum(timePoints(trial_i,1:4));

    is_true = 0;
    while (is_true == 0 && GetSecs-vbl < Param.Trial.MaxRT)
        [keyIsDown_1, RT_time, keyCode] = KbCheck;
        if keyCode(Param.Keys.Right) || keyCode(Param.Keys.two1) || keyCode(Param.Keys.two2)
            results(trial_i,6) = 2;        % response
            if jitter_temp == 1
                results(trial_i,7) = 1; % acc
            end
            timePoints(trial_i,6) = RT_time - vbl;    % reation time
            is_true = 1;
        elseif keyCode(Param.Keys.Left) || keyCode(Param.Keys.one1) || keyCode(Param.Keys.one2)
            results(trial_i,6) = 1;
            if jitter_temp == -1
                results(trial_i,7) = 1;
            end
            timePoints(trial_i,6) = RT_time - vbl;
            is_true = 1;
        elseif keyCode(Param.Keys.EscPress)
            abort;
        end
    end

    %% ITI
    Screen('FillOval',wnd,Param.Fixation.OvalColor,Param.Fixation.OvalLoc);
    Screen('Flip',wnd);
    while (GetSecs - timePoints(trial_i,1) < Param.Trial.Duration_fMRI)
        timePoints(trial_i,7) = GetSecs - timePoints(trial_i,1);
    end
end

Screen('FillOval', wnd, Param.Fixation.OvalColor, Param.Fixation.OvalLoc);
Screen('Flip',wnd);
WaitSecs(Param.DisfMRI.Dummy); 

%% record entire duration
endOfExpmt = GetSecs;
disp(' ');
expmtDur = endOfExpmt - Exp_Start;
expmtDurMin = floor(expmtDur/60);
expmtDurSec = mod(expmtDur,60);
disp(['Cycling lasted ' num2str(expmtDurMin) ' minutes, ' num2str(expmtDurSec) ' seconds']);
disp(' ')

%% compute accuracy
Accu = sum(results(:,7))./Param.DisfMRI.TrialNum;
disp(' ');
disp(['Accuracy: ' num2str(Accu)]);
disp(' ');

%% save data

cd(resDir);
resName = [SubjID '_Sess' num2str(SessID) '_spatialTask__color_run' num2str(RunID) '.mat'];
save(resName,'results','timePoints','Accu','Param');
cd(CurrDir);
%%
warning on;
reset_test_gamma;
ShowCursor;
Screen('CloseAll');

delete *.asv