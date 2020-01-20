clear
clc

if ~isdir('./converted') 
    mkdir('./converted')         
end 


fixedDir = '../mark_image';
objDir = './converted';

fixedFlist = dir(sprintf('%s/*.tif',fixedDir));

%%
for id =1:1:length(fixedFlist)
    disp(id)
    fixed_fname = sprintf('%s/%s',fixedDir,fixedFlist(i).name);
    fixed = imread(fixed_fname);
    fixed = double(fixed);
    fixed = fixed./65535;
    % write point D50
    sRGB2XYZ = [0.4124564 0.3575761 0.1804375;
                0.2126729 0.7151522 0.0721750;
                0.0193339 0.1191920 0.9503041];
    
    AdobleRGBtoXYZ = [ 0.6097559  0.2052401  0.1492240;
                       0.3111242  0.6256560  0.0632197;
                       0.0194811  0.0608902  0.7448387];
    
%     XYZtoProhotoRGB = [1.3459433 -0.2556075 -0.0511118;
%                        -0.5445989  1.5081673  0.0205351;
%                        0.0000000  0.0000000  1.2118128];
                   
    AdobleRGBtoProhotoRGB =  sRGB2XYZ * XYZtoProhotoRGB;

    AdobleRGBtoProhotoRGB = AdobleRGBtoProhotoRGB./ repmat(sum(AdobleRGBtoProhotoRGB,2),1,3); % normalize each rows of sRGB2Cam to 1
    ProhotoRGBtoAdobleRGB = (AdobleRGBtoProhotoRGB)^-1;
    
    fixed = fixed.^2.2;
    out = apply_cmatrix(fixed, ProhotoRGBtoAdobleRGB);
    out = max(0,min(out,1));               
    
    out = out.^(1/2.2);
    out = uint8(out.*255);
    
    str2 = [objDir,'/',sprintf('mark%05d.png',id)];
    imwrite(out,str2)

end



