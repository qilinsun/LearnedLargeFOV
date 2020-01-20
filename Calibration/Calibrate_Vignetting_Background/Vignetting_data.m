clear
clc
addpath('../read_raw_image_and_processing/')
addpath('../read_raw_image_and_processing/raw_private')
%% We recommended user to capture more than 10 images and get the average
VignettingDir = './Vignetting_realword_data';

% read file list    
flist = dir(sprintf('%s/*.ARW',VignettingDir));

%%

for i =1:length(flist)
     Vignetting_fname = sprintf('%s/%s',VignettingDir,flist(i).name);
     if i==1
         Vignetting = double(Raw2RGB(Vignetting_fname,'no_gama_auto_bright'));
%          Vignetting = (imread(Vignetting_fname));
     end
     Vignetting = Vignetting +  double(Raw2RGB(Vignetting_fname,'no_gama_auto_bright')); %double(imread(Vignetting_fname));
end
Vignetting = Vignetting./i;

real_Vignetting_fitted = uniformFit(Vignetting/255);
real_Vignetting_fitted = real_Vignetting_fitted./max(real_Vignetting_fitted(:));
save('real_Vignetting.mat','real_Vignetting_fitted')




