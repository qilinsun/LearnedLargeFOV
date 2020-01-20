# LearnedLargeFOV
Official Implementation of the Paper "Learned Large Field-of-view Imaging Through Thin Plate Optics"

[Official Project Webpage](https://vccimaging.org/Publications/Peng&Sun2019LearnLargeFOV/)

If you have any questions, please directly comment on GitHub or through email:qilin.sun@kaust.edu.sa.

# Instructions
## Prepare dataset
### 1. Calibrate your monitor
We use [i1 Pro](https://www.xrite.com/categories/calibration-profiling/i1-solutions) calibration suite
to calibrate the tone and color of our monitor ASUS PA32UC. 

Notice the bit depth of the color channels and dynamic range of the monitor are the most critical parameters.
In real-word, the dynamic range is much more extensive than what you can capture on a monitor. Here, we recommend the
user to use a reference level HDR monitor like EIZO CG3145 which would give much better results compared with 
our current available monitor.

### 2. Calibrate your fabricated lens.
After assembling the fabricated lens with the camera body (Sony A7 R2 in our experiments), the users can capture a 
serious of checkboard images and use the build-in calibration toolbox of Matlab. Due to the blur of the fabricated lens are relatively strong, we recommend to use a large checkboard (>=A2).

Then save the camera parameters as file "Calibration/cameraParams.mat"
We will load this file to correct distortion while registering the checkboard pair (captured on monitor and ground truth)
and training image pairs.

### 3. Obtaining the transform matrix
Run the file "Calibration/RegisterTwoCameraUsingCheckboard.m"
With a checkboard displayed on the monitor, adjusting and fix ur hardware setup, capture on the image.
Specificy ur path --> Line 16: captured_fname 

Check the plotted image and save the transformation matrix.
Notice that u need to check both "capturedPoints"(detectCheckerboardPoints) and referencePoints!

### 4. Obtaining the Vignetting correction map, bright reference, and background of the monitor
cd folder "Calibration/bg_and_vig"
Run file "Calibration/bg_and_vig/bg_and_vig_data.m", user need to capture the displayed images with 
full write and full black and put it into the corresponding folder.
Then the saved "bg.mat" and "vig.mat" are shown in the folder.
Notice that you need to specify the cropping area first to promise the fitting accuracy.

### 5. Download your dataset, crop and change the color space
We selected the data (as described in the paper) from [Adobe5k dataset](https://data.csail.mit.edu/graphics/fivek/);
Users need to crop the image according to their monitor's resolution.
Users need to change the color space according to their monitor. For ours, we use AdobeRGB.

### 6. Regist the training pairs
Install OpenCV for python and rawpy. Python run "captured_data/raw2tif.py" to use rawpy to convert the ARW raw data to .tif (with gamma=1 and AdobeRGB color space) for further processing.
Then run file "image_register.m"
The paired data are stored in the folder "registed_data_pair"
Check if the checkboard images in the two folders are paired pixel by pixel.

## Training the network
Conda creates your environment using "LLFOV_Qilin.yml".
Copy the registered data pair into the corresponding folder, "bash train.sh"
the training process could run automatically.

## Test the trained network
"bash test.sh". We gave some example images in folder "testimages", and save example "epoch 220" for users to test.
Test examples captured from real word can be [downloaded](https://drive.google.com/file/d/1GeyKqQOfSpCGN18EMEm3pPbG4RKrWExS/view?usp=sharing).
Unzip the "test" folder into path "Train/datasets/" and run thet.sh

### Acknowledgement 
We refer the code from [DeblurGAN](https://github.com/KupynOrest/DeblurGAN), using the lib for raw processing [raw_private](https://au.mathworks.com/matlabcentral/fileexchange/66927-read-raw-camera-images) by E. Farhi and RandsacHomography by Edward Wiggin.

The training and experiments are supported by KAUST baseline funding.

## Citation

If you find our code helpful in your research or work please cite our paper.

```
@inproceedings{Peng_Sun2019LearnLargeFOV,
  title={Learned Large Field-of-View Imaging With Thin-Plate Optics},
  author={Peng, Yifan and Sun, Qilin and Dun, Xiong and Wetzstein, Gordon and Heidrich, Wolfgang},
  booktitle={ACM Transactions on Graphics (Proc. SIGGRAPH Asia)},
  volume = {38},
  number = {6},
  year = {2019},
  publisher={ACM} 
  }
```
