function x = runFDRCorrection(pfile, maskfile, outprefix, niitemplate)

%h = load_nii('MNI_aligned_T1.nii.gz');
h = load_nii(niitemplate);

img = load(pfile);
[a, b, c] = size(img.stats);
stats = img.stats;
mask = load(maskfile);
[d, e, f] = size(mask.mask);
maskSize = 0;

for i = 1:d
    for j = 1:e
        for k = 1:f
            if(mask.mask(i,j,k) ~= 0)
                maskSize = maskSize + 1;
            end
        end
    end
end
%disp(num2str(maskSize));

pColumn = zeros(maskSize,1);
%c = 2;
count = 1;
for i=1:a
    for j = 1:b
        for k = 1:c
          if(mask.mask(i,j,k) ~= 0)
            pColumn(count,1) = stats(i,j,k);
            count = count+1;
        end
        end
    end
end
    %disp(num2str(count));
    %x = pColumn;
    
    %[FDR, Q, Pi0, R2] = mafdr(pColumn)
    %FDR= mafdr(pColumn, 'BHFDR', true, 'showplot', true);
    FDR= mafdr(pColumn);
    %x = FDR;
  
 count = 1;
 for i=1:a
    for j = 1:b
        for k =1:c
          if(mask.mask(i,j,k) ~= 0)
            stats(i,j,k) = FDR(count,1);
            count = count+1;
        end
        end
    end
end
    x = stats;
%end
pImage = stats;
filename = strcat(outprefix, '_pImage_FDR.mat');
save(filename, 'pImage');

x = make_nii(pImage);
x.hdr.hist = h.hdr.hist;
filename = strcat(outprefix, '_pImage_FDR.nii.gz');
save_nii(x, filename);

for i = 1:a
    for j = 1:b
        for k = 1:c
            if(mask.mask(i,j,k) ~=0)
                pImage(i,j,k) = 1-pImage(i,j,k);
            end
        end
    end
end

filename = strcat(outprefix, '_1-pImage_FDR.mat');
save(filename, 'pImage');

x = make_nii(pImage);
x.hdr.hist = h.hdr.hist;
filename = strcat(outprefix, '_1-pImage_FDR.nii.gz');
save_nii(x, filename);

end