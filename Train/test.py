import time
import os
from options.test_options import TestOptions
from data.custom_dataset_data_loader import CreateDataLoader
from models.models import create_model
from util.visualizer import Visualizer
from pdb import set_trace as st
from util import html
from util.metrics import *
from PIL import Image
import time

opt = TestOptions().parse()
opt.nThreads = 1   # test code only supports nThreads = 1
opt.batchSize = 1  # test code only supports batchSize = 1
opt.serial_batches = True  # no shuffle
opt.no_flip = True  # no flip

data_loader = CreateDataLoader(opt)
dataset = data_loader.load_data()
model = create_model(opt)
visualizer = Visualizer(opt)
# create website
web_dir = os.path.join(opt.results_dir, opt.name, '%s_%s' % (opt.phase, opt.which_epoch))
webpage = html.HTML(web_dir, 'Experiment = %s, Phase = %s, Epoch = %s' % (opt.name, opt.phase, opt.which_epoch))
# test

counter = 0

dataset_size = len(data_loader)
print('#test images = %d' % dataset_size)
for i, data in enumerate(dataset):
	iter_start_time = time.time()
	if i >= opt.how_many:
		break
	counter = i
	model.set_input(data)
	model.test()
	visuals = model.get_current_visuals()
	img_path = model.get_image_paths()
	print('process image... %s' % img_path)
	visualizer.save_images(webpage, visuals, img_path)
	print('Time Taken: %d sec' %  (time.time() - iter_start_time))
	


webpage.save()
