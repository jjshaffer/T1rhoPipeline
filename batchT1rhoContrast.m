function x = batchT1rhoContrast(i,covarFile, BOLDFile, maskFile, prefix, nullModel, model, expVariable)
 
%Load Covariate file into matrix
covars = tdfread(covarFile);

%calculate the number of subjects - should add error handling for having
%extra lines
[a,b] = size(covars.SUBJID);

%Create 1 table with placeholders for data to save function calls to the
%constructor - creating millions of tables is eye-bleedingly slow
BOLDTable = table(covars.SUBJID, covars.BD, covars.Visit, covars.Age, covars.Male, covars.MADRS, covars.YMRS, covars.TotalAttempts, zeros(a,1), 'VariableNames', {'Subject', 'Group', 'Session', 'Age', 'Sex', 'MADRS', 'YMRS', 'TotalAttempts','BOLD'});

%Read imaging data into variable
BOLDImages = load(BOLDFile);

[xdim,ydim, zdim, num_subjs] = size(BOLDImages.imgData);

%Create data structure for storing statistical results
stats = zeros(ydim, zdim,12);

m = load(maskFile);
mask = m.mask;


for j = 1:ydim
%j=i;
    disp(strcat('Row:',num2str(j)));
    for k = 1:zdim
      
        if(mask(i,j,k) ~= 0)    
        %Create temporary table, t and put BOLD data from appropriate
        %voxel in the table. 
           
        t = BOLDTable;
        t.BOLD = squeeze(BOLDImages.imgData(i,j,k,:));
            
         
        %Test the null and experimental regression models for the given voxel    
        model0 = testVoxel(t, nullModel);
        model1 = testVoxel(t, model);
            
            %save('test4.mat', 'model0');
            %save('test5.mat', 'model1');
            
        %If both models exist, compare models & store results   
        if(~isempty(model0) && ~isempty(model1))
            %disp('ping');
            %disp(strcat(num2str(i), ':', num2str(j), ': ', num2str(k)));
            results = compare(model0, model1);
            
            stats(j,k,11) = results.LRStat(2);
            stats(j,k,12) = results.pValue(2);
            
     
        end
            
            
        if(~isempty(model1))
            %disp(strcat(num2str(i), ':', num2str(j), ': '));
            %Check which entry corresponds to desired coefficient
            %& store values in stats variable. 
            [c, d] = size(model1.Coefficients);
            for l = 1:c
                if strcmp(model1.Coefficients{l,1}, expVariable)
                    %disp(strcat(num2str(i), ':', num2str(j), ': ', num2str(k), ': ', num2str(model1.Coefficients.tStat(l))));
                    stats(j,k,1) = model1.Coefficients.tStat(l);
                    stats(j,k,2) = model1.Coefficients.pValue(l);

                    %disp('ping');
                %elseif strcmp(model1.Coefficients{l,1}, 'Group')
                    %disp(strcat(num2str(i), ':', num2str(j), ': ', num2str(k), ': ', num2str(model1.Coefficients.tStat(l))));
                 %   stats(j,k,3) = model1.Coefficients.tStat(l);
                  %  stats(j,k,4) = model1.Coefficients.pValue(l);

                elseif strcmp(model1.Coefficients{l,1}, 'Session')
                    %disp(strcat(num2str(i), ':', num2str(j), ': ', num2str(k), ': ', num2str(model1.Coefficients.tStat(l))));
                    stats(j,k,5) = model1.Coefficients.tStat(l);
                    stats(j,k,6) = model1.Coefficients.pValue(l);
                    

                elseif strcmp(model1.Coefficients{l,1}, 'Age')
                    %disp(strcat(num2str(i), ':', num2str(j), ': ', num2str(k), ': ', num2str(model1.Coefficients.tStat(l))));
                    stats(j,k,7) = model1.Coefficients.tStat(l);
                    stats(j,k,8) = model1.Coefficients.pValue(l);
                    
                    stats(k,7) = model1.Coefficients.tStat(l);
                    stats(k,8) = model1.Coefficients.pValue(l);
                elseif strcmp(model1.Coefficients{l,1}, 'Sex')
                    %disp(strcat(num2str(i), ':', num2str(j), ': ', num2str(k), ': ', num2str(model1.Coefficients.tStat(l))));
                    stats(j,k,9) = model1.Coefficients.tStat(l);
                    stats(j,k,10) = model1.Coefficients.pValue(l);

                end
            end %Mask check
            end %l loop
        end
    end %k loop
end %j loop
   
   x = generateOutput(stats, strcat(prefix, '_slice-', num2str(i)));
 
end %Function