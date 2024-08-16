%% gen prt
% 04/01/2024 by Yuan Gao

clear all;
clc;

%parameters need change
SubjName = 'JK24_7T_001';
SessNum = 1;

%other parameters
TRsNum = 218; % 220 - first 2 dummy
TrialNum = 18;
TrialTR = 12;
SessName = {'pre','post'};
BehaviordataDir = 'E:\WMPFC_20231223\Results\fMRI\JK24_7T_002';
Cond_name = {'sample','delay','test','ITI'};

prt_vol  = zeros(TRsNum,1);
for triali = 1:TrialNum
    prt_vol ((1 + (triali-1)*TrialTR),1)    = 1;  % sample, the first TR
    prt_vol (((2:6) + (triali-1)*TrialTR),1)  = 2;  % delay
    prt_vol ((7 + (triali-1)*TrialTR),1)    = 3;  % test
    prt_vol (((8:12) + (triali-1)*TrialTR),1)  = 4;  % ITI
end

prt_vol (217:218) = 4;  % post fixation block

events = Cond_name;
% color = {[255 0 0],[0 255 0],[0 0 255],[255 25 0],[255 0 255],[0 255 255],[35 35 35],[115 115 115],[195 195 195]};
color = {[252 248 187],[252 154 107],[223 074 104],[140 042 129],[065 014 115]};

ncond = length(events);

fout = fopen([SubjName '_' SessName{SessNum} '.prt'],'wt');

fprintf(fout, '\n');
fprintf(fout, 'FileVersion:        2\n');
fprintf(fout, '\n');
fprintf(fout, 'ResolutionOfTime:   Volumes\n');
fprintf(fout, '\n');
fprintf(fout, 'Experiment:         %s\n',[SubjName '_' SessName{SessNum}]);
fprintf(fout, '\n');
fprintf(fout, 'BackgroundColor:    0 0 0\n');
fprintf(fout, 'TextColor:          255 255 255\n');
fprintf(fout, 'TimeCourseColor:    255 255 255\n');
fprintf(fout, 'TimeCourseThick:    3\n');
fprintf(fout, 'ReferenceFuncColor: 0 0 80\n');
fprintf(fout, 'ReferenceFuncThick: 3\n');
fprintf(fout, '\n');
fprintf(fout, 'NrOfConditions:  %d\n',ncond);
fprintf(fout, '\n');

for cond_i=1:ncond
    fprintf(fout,'%s\n',events{cond_i});
    fprintf(fout, '\n');
    temp_cond = find(prt_vol == cond_i);
    fprintf(fout, '\n'); 
    fprintf(fout,'%d\n',length(temp_cond));
    fprintf(fout, '\n');
    for temp_condi = 1:length(temp_cond)
        fprintf(fout,'%d %d\n',[temp_cond(temp_condi) temp_cond(temp_condi)]);
    end
            
    fprintf(fout,'\n');
    fprintf(fout,'Color: %d %d %d\n', color{cond_i});
    fprintf(fout,'\n');        
end

if fout ~= 1
    fclose(fout);
end

delete *.asv