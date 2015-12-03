function y = cleanFolderNames(bratsLGG_names)
bratsLGG_names(strcmp(bratsLGG_names,'.'))=[]; %remove . .. and ._ folders
bratsLGG_names(strcmp(bratsLGG_names,'..'))=[];
bratsLGG_names(strcmp(bratsLGG_names,'.DS_Store'))=[];
for name = bratsLGG_names
    if (size(findstr('._',strjoin(name)),1)>0)
       bratsLGG_names(strcmp(bratsLGG_names,name))=[];
    end
end
y=bratsLGG_names;
