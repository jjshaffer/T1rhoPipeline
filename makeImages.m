function out = makeImages(imgFile, nameFile, niiTemplate, outprefix)
%Function for reading .mat file including statistics output from regression
%analysis and saving individual nifti-formatted images for each
%statistic/contrast and for creating 1-p value map. These images can then
%be combined using AFNI's toBucket function so that they can be thresholded
%in the AFNI viewer. The naming file is a text file with space or
%tab-separated names for each regression variable on the first line. 
%Example Usage: x = makeImages('TMSvSHAM-T1rho_results.mat', 'names.txt', 'BD_TMS_Data-28-Mar-2019-0.95Mask.nii.gz');
%Author: Joe Shaffer
%Date: April, 2019

addpath('NIfTI_20140122');

%Load image file & find its size
images = load(imgFile);
[a,b,c,d] = size(images.stats);

%Open txt file for reading filename prefixes
fid = fopen(nameFile);
line = fgets(fid);
%disp(line);
names=strsplit(line);
fclose(fid);

%Create counter for indexing filename prefixes
counter=1;

%Loop through odd-numbered indices - these should be t-statistics
for i = 1:2:d
   %disp(num2str(i));
   
   if(counter <= length(names))
       prefix = strcat(outprefix, '_',names{1,counter});
       disp(prefix);
   else
       disp('No name prefix provided');
       prefix = strcat(outprefix, '_Contrast', num2str(counter));
   
   end
   
   template=load_nii(niiTemplate);
   
   %Save t-statistic image
   outfilename = strcat(prefix, '_t.nii.gz');
   img = make_nii(images.stats(:,:,:,i));
   img.hdr.hist = template.hdr.hist;
   save_nii(img, outfilename);
   
   %Save p-value image
   outfilename = strcat(prefix, '_p.nii.gz');
   img = make_nii(images.stats(:,:,:,i+1))
   img.hdr.hist = template.hdr.hist;
   save_nii(img, outfilename);
   
   %Create 1-p value image - set value to 1-p at all non-zero voxels
   temp = zeros(a,b,c);
   for x = 1:a
       for y = 1:b
           for z = 1:c
        
               if(images.stats(x,y,z,i+1) ~= 0)
                   temp(x,y,z) = 1-images.stats(x,y,z,i+1);
               end
               
               
           end
       end
   end
   %Save image
   outfilename = strcat(prefix, '_1-p.nii.gz');
   img = make_nii(temp);
   img.hdr.hist = template.hdr.hist;
   save_nii(img, outfilename);
   
   
   counter = counter +1;
end



out = 1;
end
