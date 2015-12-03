function volCTnew = normalizeVolume(volCT, varargin)
%NORMALIZEVOLUME Normalizes a given volume.
%
%   INPUT:
%   volCT - Volume of whatever type.
%
%   OUTPUT:
%   volCTnew - Output volume matrix that is normalized by some method.
%   type
%     'simple' - Just takes positives and maps them to 0-1.
%
%Created by Darvin Yi (darvinyi[at]Stanford.EDU)

%% Set Type.
if length(varargin) == 1
    type = varargin{1};
else
    type = 'simple';
end

%% Based on type, give normalization.
if strcmp(type, 'simple')
    volCTnew               = double(volCT);
    volCTnew(volCTnew < 0) = 0;
    volCTnew               = volCTnew / max(volCTnew(:));
elseif strcmp(type, 'slicebyslice')
    volCTnew               = double(volCT);
    volCTnew(volCTnew < 0) = 0;
    for i = 1:size(volCTnew, 3)
        im = volCTnew(:, :, i);
        if max(im(:)) > 500
            volCTnew(:, :, i) = im ./ max(im(:));
        else
            volCTnew(:, :, i) = zeros(size(im));
        end
    end
elseif strcmp(type, 'stats')
    volCTnew = double(volCT);
    volCTnew(volCTnew < 0) = 0;
    volCTnew = volCTnew - mean(volCTnew(volCT>0));
    volCTnew = volCTnew / std(volCTnew(volCT>0));
else
    volCTnew = volCT;
end


end

