clear 
clc
s = 'DSC08095.dng';
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