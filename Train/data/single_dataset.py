import os.path
import torchvision.transforms as transforms
from data.image_folder import make_dataset
import cv2
import numpy as np
import scipy.misc

class SingleDataset():
    def initialize(self, opt):
        self.opt = opt
        self.root = opt.dataroot
        self.dir_A = os.path.join(opt.dataroot)
        self.A_paths = make_dataset(self.dir_A)
        self.A_paths = sorted(self.A_paths)		
        self.transform = transforms.ToTensor()

    def __getitem__(self, index):
        A_path = self.A_paths[index]

        #A_img = Image.open(A_path).convert("I",  colors=65536)
        A_img = cv2.imread(A_path,-1)
        A_img = np.float32(A_img[:,:,::-1])
        A_img = A_img/65535.0
       
        h,w = A_img.shape[0],A_img.shape[1]
        H,W = int(h/256)*256, int(w/256)*256
        sh,sw=int((h-H)/2),int((w-W)/2)
        A_img = A_img[sh:sh+H,sw:sw+W,:]
        
#        A_img = scipy.misc.imresize(A_img, (4096, 5888))
        A_img = scipy.misc.imresize(A_img, (2880, 3840))
        A_img = self.transform(A_img)
        A_img = A_img**1.8
        A_img = (A_img-0.5)*2
        #A_img = A_img**(1/2.2)
        return {'A': A_img, 'A_paths': A_path}

    def __len__(self):
        return len(self.A_paths)

    def name(self):
        return 'SingleImageDataset'
