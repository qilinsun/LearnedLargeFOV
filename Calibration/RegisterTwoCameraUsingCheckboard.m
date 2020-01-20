clear 
clc
% auto registerd using two checkedboard and ransac alograthm
addpath('./ransac_homography/')
addpath('./read_raw_image_and_processing/')
addpath('./read_raw_image_and_processing/raw_private')

% load cameraParams for distortion
% calibrated using our design Flat lens and matlab toolbox  %
% the example data are located at "./checkboard_for_distortion/design" %
% users should capture enough images from different positions %
load('cameraParams.mat'); 

%% read the two checkedboard and undistotion
% name of captured checkboard on monitor
captured_fname = './checkboard_for_register/DSC08095.ARW'; 
% name of reference checkboard image
reference_fname = './checkboard_for_register/reference_checkboard.PNG';

captured = Raw2RGB(captured_fname,'gama_auto_bright');%imread(captured_fname);
% correct the distoration using calibrated camera parameters
captured = undistortImage(captured,cameraParams_design,'outputview','same');

reference = imread(reference_fname);

captured(:,4650:end,:)=0; % introduce unsymmetric to avoid rotated matching;
% detect corne point on the two checkboard
[capturedPoints,~] = detectCheckerboardPoints(captured);
figure,imshow(captured);
hold on

plot(capturedPoints(:,1),capturedPoints(:,2),'r*')


% [referencePoints,~] = detectCheckerboardPoints(reference); %% easily to
% detectCheckerboardPoints() might have rotated detection,
% here we mannually generate a corresponding checkboard
referencePoints = generateCheckerboardPoints([23,31],100);
referencePoints(:,1) = referencePoints(:,1) + 20.5 +100;
referencePoints(:,2) = referencePoints(:,2) + 30.5 ;

figure,imshow(reference);
hold on
plot(referencePoints(:,1),referencePoints(:,2),'r*')

% cal H using ransac

[H, ~] = findHomography(referencePoints',capturedPoints');

% renew the tform structure
load('tform.mat')
tform.T = H';

% check the register
Rcaptured = imref2d(size(captured));
registered = imwarp(reference,tform,'FillValues', 0,'OutputView',Rcaptured);

figure,imshow(registered);
hold on
plot(capturedPoints(:,1),capturedPoints(:,2),'r*')

% figure, imshowpair(captured,registered,'blend');

% save tform or not according the verification figure display
stats = 'Y';  % default Yes
stats = input('Please check the plotted images first! Save transformation matrix? [Y/N]', 's');
if stats =='Y'
   save('tform.mat','tform')
end

% rmpath
rmpath('./ransac_homography/')
rmpath('./read_raw_image_and_processing/')
rmpath('./read_raw_image_and_processing/raw_private')
