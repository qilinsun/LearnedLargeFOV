clear
clc

addpath('./read_raw_image_and_processing/')
addpath('./read_raw_image_and_processing/raw_private')

%% dir set

if ~isdir('./registed_data_pair/blurred') 
    mkdir('./registed_data_pair/blurred')         
end 
if ~isdir('./registed_data_pair/GT') 
    mkdir('./registed_data_pair/GT')         
end 

%% read file name and sort

capturedDir = './captured_data';
% The ground truth are converted to Adobe RGB color space for display
GTDir = './ChangeColorSpace/converted/';
pairDir = './registed_data_pair/';

% read file list    
capturedFlist = dir(sprintf('%s/*.tif',capturedDir));
GTFlist = dir(sprintf('%s/*.png',GTDir));

%load cameraParams
load('cameraParams.mat'); 
load('tform.mat');   % tform1 for ideal picture pair, tform for screen picture pair

%%
% specificy finally croping positions here
rstart=800; rend=3220; cstart=1180; cend=4850;
    
load('./Calibrate_Vignetting_Background/vig.mat')
load('./Calibrate_Vignetting_Background/bg.mat')
%% registered
load('tform.mat');
for i = 1:length(capturedFlist)
    disp(sprintf("processing image pair [%04d]",i))

    captured_fname = sprintf('%s/%s',capturedDir,capturedFlist(i).name);
%     captured = Raw2RGB(captured_fname,'gama_auto_bright'); %% we train data in linear space
    captured = uint16(imread(captured_fname));
    
    captured = undistortImage(captured,cameraParams_design,'outputview','same');
    
    GT_fname = sprintf('%s/%s',GTDir,GTFlist(i).name);
    GT = imread(GT_fname);

    % register according the transform array
    Rcaptured = imref2d(size(captured));
    registered = imwarp(GT,tform,'FillValues', 0,'OutputView',Rcaptured);


    registered = registered(rstart:rend,cstart:cend,:);
    captured = captured(rstart:rend,cstart:cend,:);
    
    captured = uint16((double(captured) - bg)./Vignetting_fitted);
 
    
    mean2(double(registered))
    mean2(double(captured))   
%   captured = uint16(mean2(double(registered))/mean2(double(captured)).*double(captured));
    
    if size(registered,3)==1
        registered=repmat(registered,1,1,3);
    end
    str1 = [pairDir,'GT/',sprintf('GT%05d.png',i)];
    imwrite(registered,str1)
    str2 = [pairDir,'blurred/',sprintf('BL%05d.png',i)];
    imwrite(captured,str2)
end

%%
rmpath('./read_raw_image_and_processing/')
rmpath('./read_raw_image_and_processing/raw_private')

%captured
