function x = T1rhoAnalysis(i)

%DATA_DIR = '/Volumes/mrrcdata/BD_TMS_TIMING/derivatives/T1rho/';
DATA_DIR = '/Shared/MRRCdata/BD_TMS_TIMING/derivatives/T1rho/';

covars = 'BD_TMS_SessionList-13-Jan-2020.txt';
data = 'BD_T1rho_data.mat';
mask = 'BD_TMS_21-Feb-2020_0.95_mask.mat';

batchT1rhoContrast(i, covars, data, mask, 'TMSvSHAM-T1rho', 'BOLD~Group+Session+Age+Sex+(1|Subject)', 'BOLD~Group*Session+Age+Sex+(1|Subject)');



x = 0;
end