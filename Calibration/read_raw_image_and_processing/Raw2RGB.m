function out = Raw2RGB(filename,outType)

% example: out=Raw2RGB('./data/DSC01073.ARW','no_gama_auto_bright');


%% read data
dc = readraw('clear');
raw = imread_r(dc, filename, '-T -4 -D'); %  '-w -6 -T -h'

%% correct black and bright level
black = 512;
saturation = 16383;
lin_bayer = (double(raw)-black)/(saturation-black); % 
lin_bayer = max(0,min(lin_bayer,1)); %

%% write balance on camera color space
%wb_multipliers = [1/0.517172,1,1/0.462094];   % for A7M2
%wb_multipliers = [1/0.352617,1,1/0.666667];  %for thinkvision
% wb_multipliers = [1/0.370478,1,1/0.695652];  %for dell
wb_multipliers = [1/0.3683,1,1/0.6975];  %for dell screen 1


mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
balanced_bayer = (lin_bayer) .* mask;
balanced_bayer = max(0,min(balanced_bayer,1));

%% demosaic 
temp = uint16(balanced_bayer * (2^16-1));
lin_rgb = double(demosaic(temp,'rggb'))/(2^16-1);

%% from camera color space to sRGB space
% ProPhotoRGb2XYZ = [0.7976749  0.1351917  0.0313534 ;0.2880402  0.7118741  0.0000857; 0.0000000  0.0000000  0.8252100];
% sRGB2XYZ = [0.4124564 0.3575761 0.1804375;0.2126729 0.7151522 0.0721750;0.0193339 0.1191920 0.9503041];
sRGB2XYZ = [0.4124564 0.3575761 0.1804375;
            0.2126729 0.7151522 0.0721750;
            0.0193339 0.1191920 0.9503041];
% sRGB2XYZ is an unchanged standard
XYZ2Cam = [ 0.5271   -0.0712   -0.0347; -0.6153    1.3653    0.2763; -0.1601    0.2366    0.7242]; % ColorMatrix2
% XYZ2Cam = [0.7491   -0.3027    0.0351; -0.4231    1.1579  0.3031;-0.0818 0.1721    0.7466]; % ColorMatrix1

CC = [0.9697 0 0 ;
      0      1 0;
      0      0 0.9681];

sRGB2Cam = CC * XYZ2Cam * sRGB2XYZ;
% sRGB2Cam = XYZ2Cam * ProPhotoRGb2XYZ;

sRGB2Cam = sRGB2Cam./ repmat(sum(sRGB2Cam,2),1,3); % normalize each rows of sRGB2Cam to 1
Cam2sRGB = (sRGB2Cam)^-1;
lin_srgb = apply_cmatrix(lin_rgb, Cam2sRGB);
lin_srgb = max(0,min(lin_srgb,1)); % Always keep image clipped b/w 0-1

% lin_srgb = (lin_srgb - min(lin_srgb(:)))./(max(lin_srgb(:)) - min(lin_srgb(:)));

%% auto bright 
% grayim = rgb2gray(lin_srgb); % Consider only gray channel
grayscale = 1;
bright_srgb = min(1,lin_srgb * grayscale); % Always keep image value less than 1

%% apply gamma 
nl_srgb = bright_srgb.^(1/2.2);   % for apple the gamma is 1.8
                                  % for other screen is 2.2

%% output
switch outType
    case 'no_gama_auto_bright'
        out = uint16(lin_srgb*65535);
        
    otherwise
        out = uint16(nl_srgb*65535);        
end

