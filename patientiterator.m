d = dir('bratsLGG');
bratsLGG_names = {d.name};
d = dir('bratsHGG');
bratsHGG_names = {d.name};

% We make 2 lists of the names of the folders in HGG and LGG and clean them
bratsLGG_names = cleanFolderNames(bratsLGG_names);
bratsHGG_names = cleanFolderNames(bratsHGG_names);

% We iterate on each folder in LGG 
X = [];    % The matrix of predictors
Y = [];    % The results 
ID = [];
for folder = bratsLGG_names  % We iterate on all the folders in LGG
    d = dir(strcat('bratsLGG/',strjoin(folder))); % Shortcut to directory
    paths = {d.name}; % The list of the 5 names of the folder
    paths = cleanFolderNames(paths);
         
        X = [X; getPredictors('bratsLGG/',folder,paths)];  
        Y = [Y; 0];
        ID = [ID; (folder)]; 
        
        fprintf('.%d \r');
        
end

for folder = bratsHGG_names  % We iterate on all the folders in HGG
    d = dir(strcat('bratsHGG/',strjoin(folder))); % Shortcut to directory
    paths = {d.name}; % The list of the 5 names of the folder
    paths = cleanFolderNames(paths);
             
        X = [X; getPredictors('bratsHGG/',folder,paths)];  
        Y = [Y; 1];
        ID = [ID; (folder)];
        
       fprintf('.%d \r');
end

save data.mat  X  Y ID;
fprintf('End of patientIterator.m \n');




