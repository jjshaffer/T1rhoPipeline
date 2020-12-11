function out = runPostProcessing(prefix, nameFile, main_contrast, maskfile)

%Function for performing post-processing steps to reassemble image slices,
%create .nii.gz images (Using NIFTI Tools) and perform FDR correction on
%the main_contrast. This step should be followed by running toBucket.sh in
%the terminal to combine images into a single "BUCKET" image for AFNI
%viewing/thresholding. An example function call:
%runPostProcessing('BD_TMS_T1rho', 'BD_TMS_names.txt', 'SessionxTMS', 'BD_TMS_Data-04-Dec-2020-0.95Mask.mat');
% Author: Joe Shaffer
% December, 5, 2020

num_slices = 193;
%nameFile = 'names.txt'
niiTemplate = 'MNI_aligned_T1.nii.gz'


out = combineSlices(prefix, num_slices);

imgFile=strcat(prefix, '_results.mat');
out2 = makeImages(imgFile, prefix, nameFile, niiTemplate);

pfile = strcat(prefix, '_', main_contrast, '_p.mat');
outprefix = strcat(prefix, '_', main_contrast);
out3 = runFDRCorrection(pfile, maskfile, outprefix, niiTemplate);


out=1;
end