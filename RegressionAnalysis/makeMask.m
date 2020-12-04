function out = makeMask(infile, percentmask, prefix)
%Function for creating an imaging mask based on counting number of voxels
%with zero-values across participants

file = load(infile);
[a b c d] = size(file.imgData)

%Create variable for storing voxel counts
mask = zeros(a,b,c);

%Loop through each participant
for i = 1:d
    
    for x = 1:a
        for y = 1:b
            for z = 1:c
                
                if(file.imgData(x,y,z,i) ~= 0)
                   mask(x,y,z) = mask(x,y,z) + 1;
                    
                end
                
            end
        end
    end
    
end

d
threshold = ceil(d*percentmask)

for x = 1:a
        for y = 1:b
            for z = 1:c
                if(mask(x,y,z) >= threshold)
                    mask(x,y,z) = 1;
                    
                else
                    mask(x,y,z) = 0;
                end
            end
        end
end

outfilename = strcat(prefix, '_', date, '_', num2str(percentmask), '_mask.mat');
save(outfilename, 'mask');
out = mask;
end