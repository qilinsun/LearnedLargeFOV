import os.path
import random
import torchvision.transforms as transforms
import torch
from data.image_folder import make_dataset
from PIL import Image
import cv2
import numpy as np
from torch.autograd import Variable

def flip(x, dim):
    dim = x.dim() + dim if dim < 0 else dim
    inds = tuple(slice(None, None) if i != dim
             else x.new(torch.arange(x.size(i)-1, -1, -1).tolist()).long()
             for i in range(x.dim()))
    return x[inds]

class AlignedDataset():
    def initialize(self, opt):
        self.opt = opt
        self.root = opt.dataroot
        self.dir_AB = os.path.join(opt.dataroot, opt.phase)

        self.AB_paths = sorted(make_dataset(self.dir_AB))

        transform_list = [transforms.ToTensor()]

        self.transform = transforms.Compose(transform_list)

    def __getitem__(self, index):
        AB_path = self.AB_paths[index]
        AB = cv2.imread(AB_path,-1)
        AB = np.float32(AB[:,:,::-1])/65535.0  ## default 16 bit image for training
        
        noise = np.random.normal(0, 3,(self.opt.fineSize,self.opt.fineSize,3))
        noise = np.float32(noise)
        AB = self.transform(AB)
        noise = self.transform(noise)

        w_total = AB.size(2)
        w = int(w_total / 2)
        h = AB.size(1)
        w_offset = random.randint(0, max(0, w - self.opt.fineSize - 1))
        h_offset = random.randint(0, max(0, h - self.opt.fineSize - 1))

        A = AB[:, h_offset:h_offset + self.opt.fineSize,
               w_offset:w_offset + self.opt.fineSize]
        B = AB[:, h_offset:h_offset + self.opt.fineSize,
               w + w_offset:w + w_offset + self.opt.fineSize]
        
        A = A +  0.001*noise
        A, B = (A-0.5)*2, (B-0.5)*2
        if np.random.randint(2,size=1)[0] == 1:  # random flip 
            A = flip(A,1)
            B = flip(B,1)
        if np.random.randint(2,size=1)[0] == 1: 
            #A = torch.from_numpy(np.flip(A,axis=2).copy())
            A = flip(A,2)
            B = flip(B,2)
        if np.random.randint(2,size=1)[0] == 1:  # random transpose 
            A.permute(0,2,1)
            B.permute(0,2,1)

        return {'A': A, 'B': B,
                'A_paths': AB_path, 'B_paths': AB_path}

    def __len__(self):
        return len(self.AB_paths)

    def name(self):
        return 'AlignedDataset'
