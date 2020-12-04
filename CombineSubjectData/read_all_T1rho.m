function out = read_all_T1rho()

%DATA_DIR='/Volumes/mrrcdata/BD_TMS_TIMING/derivatives/AAL_RESULTS/';
DATA_DIR='/Volumes/mrrcdata/BD_TMS_TIMING/derivatives/T1rho';

matx = 193;
maty = 229;
matz = 193;

SCANS = {'cbm0411', '20180620';
'cbm0411', '20180629';
'cbm0421', '20180725';
'cbm0421', '20180803';
'cbm0431', '20180809';
'cbm0431', '20180817';
'cbm0441', '20180919';
'cbm0441', '20180928';
'cbm0451', '20180927';
'cbm0451', '20181005';
'cbm0461', '20181025';
'cbm0461', '20181102';
'cbm0471', '20181106';
'cbm0471', '20181116';
'cbm0481', '20190114';
'cbm0481', '20190125';
'cbm0491', '20181213';
'cbm0491', '20181221'};

temp = length(SCANS);

imgData=zeros(matx, maty, matz, temp);
mask=zeros(matx, maty, matz);

for i = 1:temp
    dirname = strcat(DATA_DIR,'/MNI/sub-',SCANS(i,1), '/ses-', SCANS(i,2),'/sub-', SCANS(i,1), '_ses-', SCANS(i,2), '_acq-SLa50SLb10BrainVentMasked_STANDARD_T1rho.nii.gz');
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

    outname = strcat(DATA_DIR, '/BD_TMS_Data-', date, '-0.95Mask.mat');
    save(outname, 'mask', '-v7.3');

    outname = strcat(DATA_DIR, '/BD_TMS_Data-', date, '-0.95Mask.nii.gz');
    nif = make_nii(mask);
    nif.hdr.hist = data.hdr.hist;
    save_nii(nif, outname);



outname = strcat(DATA_DIR,'/BD_TMS_Data-', date, '.mat');
disp(outname);
save(outname,'imgData', '-v7.3');

outname = strcat(DATA_DIR,'/BD_TMS_SessionList-', date, '.xls');
disp(outname);

T = array2table(SCANS, 'VariableNames', {'Subject', 'Session'});
writetable(T, outname);

out = imgData;
%out = 1;
end