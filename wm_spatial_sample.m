% 6 locations in spatial task.
% By Yuan    @ 20230830

%% 
Param.Discri.Directions2   = [75,15,315,255,195,135]; % 6 directions

dirs = (Param.Discri.Directions)/180*pi;
for i_dir = 1:6
    base_loc(i_dir,1)   = Param.SpatialDot.OuterRadius * cos(dirs(i_dir)) + Param.Stimuli.Locations(3,1);
    base_loc(i_dir,2)   = Param.SpatialDot.OuterRadius * sin(dirs(i_dir)) + Param.Stimuli.Locations(3,2);
end

for i_dir = 1:6
    Screen('FillOval',wnd,black,[base_loc(i_dir,1)-Param.SpatialDot.DotSize,...
                                 base_loc(i_dir,2)-Param.SpatialDot.DotSize,...
                                 base_loc(i_dir,1)+Param.SpatialDot.DotSize,...
                                 base_loc(i_dir,2)+Param.SpatialDot.DotSize]);
end

% Screen('FillOval',wnd,Param.Fixation.OvalColor,Param.Fixation.OvalLoc);
Screen('DrawLines',wnd,Param.Fixation.CrossLoc,Param.Fixation.CrossWidth,Param.Fixation.CrossColor,[],1);

vbl = Screen('Flip',wnd);

%% close all
is_true = 0;
while ~is_true
    [~,~,keyCode] = KbCheck;
    if keyCode(Param.Keys.EscPress)
        is_true = 1;
        abort;
    end
end

reset_test_gamma;
ShowCursor;
Screen('CloseAll');

delete *.asv
