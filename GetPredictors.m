function Xi = getPredictors(grade,folder,paths)

%This is where we determine the predictors, we will put them in X
Xi =[];

for chemin = paths
    if (size(findstr('_Flair.',strjoin(chemin)),1)>0)
        pathMHA = strcat(grade,strjoin(folder),'/',strjoin(chemin));
        [volCTFlair, x, y, z]=readMHA(pathMHA);
        volCTFlairNorm = normalizeVolume(volCTFlair,'stats');


    elseif (size(findstr('_T1.',strjoin(chemin)),1)>0)
        pathMHA = strcat(grade,strjoin(folder),'/',strjoin(chemin));
        [volCTT1, x, y, z]=readMHA(pathMHA);
 	 volCTT1Norm = normalizeVolume(volCTT1,'stats');
    elseif (size(findstr('_T1c.',strjoin(chemin)),1)>0)
        pathMHA = strcat(grade,strjoin(folder),'/',strjoin(chemin));
        [volCTT1c, x, y, z]=readMHA(pathMHA);
  	 volCTT1cNorm = normalizeVolume(volCTT1c,'stats');
    elseif (size(findstr('_T2.',strjoin(chemin)),1)>0)
        pathMHA = strcat(grade,strjoin(folder),'/',strjoin(chemin));
        [volCTT2, x, y, z]=readMHA(pathMHA);
    	volCTT2Norm = normalizeVolume(volCTT2,'stats');
    elseif (size(findstr('.OT.',strjoin(chemin)),1)>0)
        pathMHA = strcat(grade,strjoin(folder),'/',strjoin(chemin));
        [volCTOT, x, y, z]=readMHA(pathMHA);
    else error('There is a problem witht the names in the folders of patients');
    end
end

% Get the size of the different regions of the tumor in pixels
for i = 1:4
    Xi = [Xi, sum(sum(sum(volCTOT==i)))];
end

for scan = {'Flair','T1','T1c','T2'}
    for modality = 1:4
        evalc(strcat('h=volCT',strjoin(scan),'Norm(volCTOT==',num2str(modality),'&volCT',strjoin(scan),'>0);'));
	Xi = [Xi,mean(h),std(h)];
    end 
end
