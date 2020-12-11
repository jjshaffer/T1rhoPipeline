function out = combineSlices(prefix, numSlices)

if(numSlices > 0)
   
    filename = strcat(prefix, '_slice-', num2str(1), '_results.mat');
    disp(filename);
    
    %Load first slice and get slice size
    slice = load(filename);
    [a,b,c] = size(slice.stats);
    
    %Create variable for storing completed 3d Images
    stats = zeros(numSlices, a, b, c);
    
    stats(1,:,:,:) = slice.stats;
    
    
    %loop through remaining slices
    for i = 2:numSlices
        %Create filename for ith slice
        filename = strcat(prefix, '_slice-', num2str(i), '_results.mat');
        disp(filename);
        
        %Load ith slice
        slice = load(filename);
        
        stats(i,:,:,:) = slice.stats;
          
          
    end %loop through slices
    
    outfilename = strcat(prefix, '_results.mat');
    save(outfilename, 'stats', '-v7.3');
    

    
else
    disp('No slices');
    stats = 1;
end


out = stats;
end