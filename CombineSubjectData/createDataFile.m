function out = createDataFile(covarFile, datadir, prefix, ctrldir, ctrl_index)
%This function reads the data files from pre-processing in order to
%generate the matlab file of all participants' imaging data
%   Author: Joe Shaffer
%   Date: 9/5/2019
addpath('NIfTI_20140122');

T = readtable(covarFile);
[a b] = size(T);

imgData = zeros(193, 229, 193, a);
for i = 1:a
   
    Subject = T.Subject(i);
    if  isa(Subject, 'double')
       Subject = num2str(Subject); 
    end
    SessionID = T.SessionID(i);
    if isa(SessionID,'double')
        SessionID = num2str(SessionID);
    end
    
   if i >= ctrl_index 
        path = strcat(ctrldir, filesep,'sub-', Subject, filesep, 'ses-',SessionID);
   else
        path = strcat(datadir, filesep,'sub-', Subject, filesep, 'ses-',SessionID);

   end
   
   path = char(path);
   if exist(path, 'dir')
       disp(path);
       
       filename = strcat(path, filesep,'sub-', Subject, '_ses-', SessionID,'_acq-SLa50SLb10BrainMasked_STANDARD_T1rho.nii.gz');
       filename = char(filename);
       if exist(filename, 'file')
           
           %disp('Reading Data');
           
           x = load_nii(filename);
           temp = x.img;
           imgData(:,:,:,i) = temp;
       else
           disp('File Missing');
       end
       
   else
       disp(strcat('Missing Folder: ', path));
   end
end

save(strcat(prefix, '.mat'), 'imgData', '-v7.3');


out = T;
end

