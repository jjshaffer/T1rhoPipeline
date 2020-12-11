function x = runMaskedFDRCorrection(mapfile, maskfile, outprefix)

%Load statistical map & identify its size
maps = load(mapfile);
[a, b, c, d] = size(maps.stats);

%load mask file - size must be axb
mask = load(maskfile);
mask = mask.mask;

%Create vector for storing p-values
pColumn = zeros((a*(b-1)/2),1);

%Create variable for storing statistical input values
stats = maps.stats;

%Set c=2 to only correct experimental variable p-value matrix.
%Comment this line out to use thresholding on a per-variable basis where
%odd indices are t-statistic maps and even indices are p-value maps
d = 2;
for i=2:2:d
    
    
    %Initialize iterator variable for providing vector indice
    count = 1;
    
    %Loop through one side of y=x line in the matrix, fill in vector
    for j = 1:a
        for k = j+1:b
            
            if(mask(j,k) ~= 0)
                %set vector index = to appropriate matrix element
                pColumn(count) = maps.stats(j,k,i);
                %add to vector index
                count = count+1;
            end
        end
    end
    
    disp(num2str(count));
%Trim size of array to match number of voxels in mask
pColumn = pColumn(1:count);

   
    %Run FDR correction on the input vector
    [FDR, Q, pi0] = mafdr(pColumn, 'showplot', true);

    
    %Put values from vector back into matrix
    count = 1;
    for j = 1:a
        for k = j+1:b
               if(mask(j,k) ~= 0)
                    stats(j,k,i) = Q(count);
                    stats(k,j,i) = Q(count);
                    count = count+1;
               end
        end
    end
    x = stats;
end

filename = strcat(outprefix, '_FDRadjusted_Results.mat');
save(filename, 'stats');
end