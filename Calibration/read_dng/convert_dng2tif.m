clear 
clc
addpath(genpath('.\read_raw_image_and_processing'));
s = 'D:\Pictures\a0016.dng';
[im, info, output]=Raw2RGB_directly(s,'linear_sRGB');
[im, info, out] = dcraw('dcraw_win64.exe', s, '-w -T -6 -q 3');
figure,imshow(im,[])

infoE_M2 = imfinfo(s);
ansE_M1 = infoE_M2.SubIFDs{1};
warning('off','all');
t = Tiff(s,'r');
offsets=getTag(t,'SubIFD');
setSubDirectory(t,offsets(1));
CFA=double(read(t));
close(t);
figure,imshow(CFA,[])
out(:,:,1) = CFA(1:2:end,1:2:end);
out(:,:,2) = CFA(2:2:end,1:2:end);
out(:,:,3) = CFA(2:2:end,2:2:end);
out=double(out);out=out./max(out(:));
figure,imshow((out),[])