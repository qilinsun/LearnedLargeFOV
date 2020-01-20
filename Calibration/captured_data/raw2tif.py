from pdb import set_trace as st
import os
import numpy as np
import cv2
import glob
import argparse

import rawpy

#splits = os.listdir(args.fold_A)
splits = glob.glob('*.ARW')
cnt=1
for sp in splits:
    path_A = sp
    raw = rawpy.imread(path_A)
    im_A = raw.postprocess(use_camera_wb=True,  no_auto_bright=False, 		auto_bright_thr=0,output_bps=16,no_auto_scale=False,gamma=(1,1),output_color=rawpy.ColorSpace.Adobe)
     
    im_A = np.float32(im_A)
    im_A = np.uint16(im_A/np.max(im_A) *65535.0)
 
    path_A=path_A.replace('.ARW','.tif')
     
    cv2.imwrite(path_A, im_A[:,:,::-1])
