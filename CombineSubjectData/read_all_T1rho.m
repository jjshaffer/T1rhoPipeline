function out = read_all_T1rho()
%Function for combining T1rho files into a .mat file based on
%list of subjects and sessions provided in SCANS variable
% Author: Joe Shaffer
% Date: 2018

%DATA_DIR='/Volumes/mrrcdata/BD_TMS_TIMING/derivatives/AAL_RESULTS/';
DATA_DIR='/Volumes/mrrcdata/SCZ_TMS_TIMING/derivatives/T1rho';

matx = 193;
maty = 229;
matz = 193;

%Because Control data is stored in the SCZ directories, you must provide
%this location as well and the index for where in the list the controls.
%When combining the TMS dataset, you will want to switch this to a very
%high value so that it isn't used
%start
CTRL_DIR = '/Volumes/mrrcdata/SCZ_TMS_TIMING/derivatives/T1rho/';
%ctrl_index = 26;
ctrl_index = 1000;




%List of Scans for Group comparison
Outprefix='SCZvHC';

SCANS = {
'CBM0001',	'20171128';
'CBM0011',	'20180118';
'CBM0021',	'20180129';
'CBM0031',	'20180216';
'CBM0051',	'20180709';
'CBM0061',	'20180822';
'CBM0071',	'20181004';
'CBM0081',	'20190402';
'CBM0091',	'20190515';
'CBM0101',	'20190923';
'CBM0111',	'20191113';
'CBM0131',	'20201008';
'CBM0141',	'20201015';
'23517557',	'2020100610153T';
'23517558',	'202010143T';
'23517559',	'2020101609453T';
'23517560',	'2020102914503T';
'23517562',	'202011123T';
'23517563',	'202011133T';
'23517564',	'202011163T';
'23517565',	'202011203T';
'23517566',	'202011233T';
'23517567',	'202011243T';
'CTL9001',	'20190807';
'CTL9011',	'20191003';
'CTL9021',	'20191009';
'CTL9041',	'20191107';
'CTL9051',	'20200305';
'CTL9061',	'20200309';
'CTL9071',	'20200313';
'CTL9081',	'20200626';
'CTL9091',	'20200824';
'CTL9101',	'20200826';
'CTL9111',	'20201027'};

%'CBM0041','20180426'; Missing data

%List of Scans for TMS comparison
%Outprefix='SCZ_TMS';

%SCANS = {
%'CBM0001',	'20171128';
%'CBM0001',	'20171208';
%'CBM0011',	'20180118';
%'CBM0011',	'20180126';
%'CBM0021',	'20180129';
%'CBM0021',	'20180209';
%'CBM0031',	'20180216';
%'CBM0031',	'20180223';
%'CBM0061',	'20180822';
%'CBM0061',	'20180831';
%'CBM0071',	'20181004';
%'CBM0071',	'20181012';
%'CBM0131',	'20201008';
%'CBM0131',	'20201016';
%'CBM0141',	'20201015';
%'CBM0141',	'20201023'};

temp = length(SCANS);

imgData=zeros(matx, maty, matz, temp);
mask=zeros(matx, maty, matz);

for i = 1:temp
    
    
    if i >= ctrl_index
        dirname = strcat(CTRL_DIR,'/sub-',SCANS(i,1), '/ses-', SCANS(i,2),'/sub-', SCANS(i,1), '_ses-', SCANS(i,2), '_acq-SLa50SLb10BrainVentMasked_STANDARD_T1rho.nii.gz');
       
    else
        dirname = strcat(DATA_DIR,'/sub-',SCANS(i,1), '/ses-', SCANS(i,2),'/sub-', SCANS(i,1), '_ses-', SCANS(i,2), '_acq-SLa50SLb10BrainVentMasked_STANDARD_T1rho.nii.gz');
  
    end
    disp(dirname);
    
    dirname=char(dirname);
    data=load_nii(dirname);
    
    %size(data.img)
    
    %Save 3d image into structure with all subject images
    imgData(:,:,:,i) = data.img;
    
    %Add to count in mask for all non-zero voxels in image
    for x = 1:matx
        for y = 1:maty
            for z = 1:matz
                
                if(data.img(x,y,z) > 0)
                    mask(x,y,z) = mask(x,y,z) + 1;
                    
                end
                
            end
        end
    end
end


    for x = 1:matx
        for y = 1:maty
            for z = 1:matz
               
                val = mask(x,y,z)/temp;
                if(val > 0.95)
                    mask(x,y,z) = 1;
                else
                    mask(x,y,z) = 0;
                end
                
            end
        end
    end

    outname = strcat(DATA_DIR, '/', Outprefix,'_Data-', date, '-0.95Mask.mat');
    save(outname, 'mask', '-v7.3');

    outname = strcat(DATA_DIR, '/', Outprefix, '_Data-', date, '-0.95Mask.nii.gz');
    nif = make_nii(mask);
    nif.hdr.hist = data.hdr.hist;
    save_nii(nif, outname);



outname = strcat(DATA_DIR,'/', Outprefix, '_Data-', date, '.mat');
disp(outname);
save(outname,'imgData', '-v7.3');

outname = strcat(DATA_DIR,'/', Outprefix, '_SessionList-', date, '.xls');
disp(outname);

T = array2table(SCANS, 'VariableNames', {'Subject', 'SessionID'});
writetable(T, outname);

%out = imgData;
out = 1;
end