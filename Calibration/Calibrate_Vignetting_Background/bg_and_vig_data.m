% This file is for calibrate the background and vignettinng of the monitor
% when the monitor shows full black and full white
clear
clc
addpath('../read_raw_image_and_processing/')
addpath('../read_raw_image_and_processing/raw_private')

%% specificy finally croping positions here
rstart=800; rend=3220; cstart=1180; cend=4850;

%%  get the background
bgDir = './bg_data';
% read file list    
bgFlist = dir(sprintf('%s/*.ARW',bgDir));


for i =1:length(bgFlist)
    bg_fname = sprintf('%s/%s',bgDir,bgFlist(i).name);
    if i==1
        bg = double(Raw2RGB(bg_fname,'no_gama_auto_bright'));
    end
     bg = bg + double(Raw2RGB(bg_fname,'no_gama_auto_bright'));
end
bg = bg./i;
bg = bg(rstart:rend,cstart:cend,:);
save('bg.mat','bg')

%% get the vignetting
% read file list    
VignettingDir = './Vignetting_monitor_data';
flist = dir(sprintf('%s/*.ARW',VignettingDir));

for i =1:length(flist)
     Vignetting_fname = sprintf('%s/%s',VignettingDir,flist(i).name);
     if i==1
         Vignetting = double(Raw2RGB(Vignetting_fname,'no_gama_auto_bright'));
%          Vignetting = (imread(Vignetting_fname));
     end
     Vignetting = Vignetting + double(Raw2RGB(Vignetting_fname,'no_gama_auto_bright')); %double(imread(Vignetting_fname));
end
Vignetting = Vignetting./i;
Vignetting = Vignetting(rstart:rend,cstart:cend,:);
Vignetting_fitted = uniformFit(Vignetting/255);
Vignetting_fitted = Vignetting_fitted./max(Vignetting_fitted(:));
save('vig.mat','Vignetting_fitted')



