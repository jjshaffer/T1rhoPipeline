function x = testVoxel(dataTab, model1)

    warning('off', 'all');
   
    test = 0;
 
    try
        lme = fitlme(dataTab, model1);
        
    catch 
        test = -1;
        
    end
    
    if (test==0)
        x = lme;
        %filename = strcat(int2str(i), '_', int2str(j), '_', int2str(k), '_LME', int2str(n), '.mat');
        %save(filename, 'lme', '-v7.3');
      
    else
         x = test;
    end
    
end