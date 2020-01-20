function [im, info, out]  = Raw2RGB_directly(filename,outType)

% example: out=Raw2RGB_directly('./data/DSC01073.ARW','no_gama_auto_bright');

if (nargin<2)
        outType = 'all';
end


%% read data
% dc = readraw('clear');

if isequal(outType,'raw')
    
    typestr = '-T -4 -D -v';
    
elseif isequal(outType,'linear_sRGB')
    typestr = '-w -o 1 -q 3 -T -4';
    
elseif isequal(outType,'linear_proPhotoRGB')
    typestr = '-w -o 4 -q 3 -T -4';
else
    typestr = '-w -o 1 -q 3 -T -6 -W -g 2.4 12.92';
end

[im, info, out] = dcraw('dcraw_win64.exe', filename, typestr); %  '-w -6 -T -h'






