clear
clc
addpath(genpath('./read_raw_image_and_processing'));
%% generate mark picture
% % objDir = './raw_dngs_cosD5';
% objDir = './raw_dngs_D700';
% outDir = './mark_image_dng2srgb_2/';
% flist = dir(sprintf('%s/*.dng',objDir));
count = 0;
%% generate test pic
objDir = './ARW';
flist = dir(sprintf('%s/*.dng',objDir));
for id = 1 : 1: length(flist)
    if(isequal(flist(id).name(1),'.')||...
       flist(id).isdir)
       continue;
    end
    
    count = count +1;
    disp(count)
    fname = sprintf('%s/%s',objDir,flist(id).name);
    [IM, ~, ~] = Raw2RGB_directly(fname,'linear_sRGB'); 
   
    if size(IM,2)< size(IM,1)
       out(:,:,1) = IM(:,:,1)';
       out(:,:,2) = IM(:,:,2)';
       out(:,:,3) = IM(:,:,3)';
       IM = out;
    end
end
imshow(IM)