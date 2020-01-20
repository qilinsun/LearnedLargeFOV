from pdb import set_trace as st
import os
import numpy as np
import cv2
import glob
import argparse

parser = argparse.ArgumentParser('create image pairs')
parser.add_argument('--fold_A', dest='fold_A', help='input directory for image A', type=str, default='./registed_data_pair/blurred/')
parser.add_argument('--fold_B', dest='fold_B', help='input directory for image B', type=str, default='./registed_data_pair/GT/')
parser.add_argument('--fold_AB', dest='fold_AB', help='output directory', type=str, default='../Train/datasets/train/')
parser.add_argument('--num_imgs', dest='num_imgs', help='number of images',type=int, default=1000000)
parser.add_argument('--use_AB', dest='use_AB', help='if true: (0001_A, 0001_B) to (0001_AB)',action='store_true')
args = parser.parse_args()

for arg in vars(args):
    print('[%s] = ' % arg,  getattr(args, arg))

#splits = os.listdir(args.fold_A)
splits = glob.glob(args.fold_A+'*.png')
cnt=0
for sp in splits:
    path_A = sp
    im_A = cv2.imread(path_A, -1)

    if '00001' in path_A: continue ## ignore the checkboard image
    #print(im_A.shape)
    path_B = sp.replace('BL0','GT0')
    path_B = path_B.replace('blurred','GT')
    im_B = cv2.imread(path_B, -1)
    #print(im_B.shape)

    cnt+=1
    
    im_B = np.float32(im_B)/65535.0
    im_B = np.uint16((im_B**(2.2)) * 65535.0)
    print(im_B.shape)
    im_AB = np.concatenate([im_A, im_B], 1)
    cv2.imwrite(args.fold_AB + '%04d.png' % (cnt), im_AB)
