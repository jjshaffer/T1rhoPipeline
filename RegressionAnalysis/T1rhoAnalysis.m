function x = T1rhoAnalysis(i)

%DATA_DIR = '/Volumes/mrrcdata/Bipolar_R01/derivatives/T1rho/';
DATA_DIR = '/Shared/MRRCdata/Bipolar_R01/derivatives/T1rho/';

%covars = strcat(DATA_DIR, 'BD_T1rho_SessionList-30-Apr-2019_covars.txt');
%data = strcat(DATA_DIR, 'BD_T1rho-30-Apr-2019.mat');
%mask = strcat(DATA_DIR, 'BD_T1rho-30-Apr-2019-0.95Mask.mat');

covars = 'ImagingDemographics_rest_9-13-2019.txt';
data = 'BD_T1rho_data.mat';
mask = 'BD_0.95mask.mat';

batchT1rhoContrast(i, covars, data, mask, 'BD_R01_T1rho_Group', 'BOLD~Age+Sex+(1|Subject)', 'BOLD~Group+Age+Sex+(1|Subject)', 'Group');


covars = 'ImagingDemographics_rest_BD_only_9-13-2019.txt';
data = 'BD_only_T1rho_data.mat';

batchT1rhoContrast(i, covars, data, mask, 'BD_R01_T1rho_MADRS', 'BOLD~Age+Sex+(1|Subject)', 'BOLD~MADRS+Age+Sex+(1|Subject)', 'MADRS');

batchT1rhoContrast(i, covars, data, mask, 'BD_R01_T1rho_YMRS', 'BOLD~Age+Sex+(1|Subject)', 'BOLD~YMRS+Age+Sex+(1|Subject)', 'YMRS');

batchT1rhoContrast(i, covars, data, mask, 'BD_R01_T1rho_Suicide', 'BOLD~Age+Sex+(1|Subject)', 'BOLD~TotalAttempts+Age+Sex+(1|Subject)', 'TotalAttempts');


x = 0;
end
