% By Yuan
% check head movement

clear all;
clc;

% parameters
SubID = {'JK23_7T_003'};
Subj_Num = length(SubID);
Sess_Name = {'session1'};%
Sess_Num  = length(Sess_Name);

load('E:\ZJUScans\JiaKe_230907_JiaK_WMPFC_20230907\10_cmrr_mbep2d1_bold_p8iso_20230525_final_Run1\10_JK23_7T_003_run1_3DMC.log');
% load('E:\ZJUScans\JiaKe_230907_JiaK_WMPFC_20230907\10_cmrr_mbep2d1_bold_p8iso_20230525_final_Run1\10_JK23_7T_003_run1_3DMC.sdm');
DataDir = 'E:\ZJUScans\JiaKe_230907_JiaK_WMPFC_20230907\';

% analysis
HM_results = zeros(Subj_Num,12);
for subi = 1:Subj_Num
    Curr_Subj = SubID{subi}; 

    for sesi = 1:Sess_Num
        Curr_Sess = Sess_Name{sesi}; 
        Curr_ZKID = SubInfo{strcmp(SubInfo(:,2),Curr_Subj),strcmp(SubInfo(1,:),Curr_Sess)};

        % run information
        Run_ID = SubInfo{strcmp(SubInfo(:,2),Curr_Subj),strcmp(SubInfo(1,:),['RunID_' Curr_Sess])};
        Run_Name= SubInfo{strcmp(SubInfo(:,2),Curr_Subj),strcmp(SubInfo(1,:),['RunName_' Curr_Sess])};
        delRuns = SubInfo{strcmp(SubInfo(:,2),Curr_Subj),strcmp(SubInfo(1,:),['delrun_' lower(Curr_Sess)])};

        if (length(delRuns)==1) && (delRuns~=0)
            Run_ID(delRuns) = [];
            Run_Name(delRuns) = [];
        elseif length(delRuns) > 1
            Run_ID(delRuns) = [];
            Run_Name(delRuns) = [];
        end

        Run_Num = length(Run_ID);

        for runi = 1:Run_Num
            Curr_SDM = xff([DataDir Curr_ZKID '\' num2str(Run_ID(runi)) '_' Curr_ZKID '.' upper(Run_Name{runi}) '_3DMC.log']);            
            Curr_HM = Curr_SDM.MCParamTable;

            Curr_max = max(Curr_HM);
            Curr_min = min(Curr_HM);
            Curr_diff = max(abs(Curr_max - Curr_min));

            Curr_ID = Run_Name{runi};           
            HM_results(subi,str2double(Curr_ID(4))+(sesi-1)*6) = Curr_diff;
        end
    end
end 

delete *.asv
