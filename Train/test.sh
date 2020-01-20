cd /home/sunq/FOV/Train/

source activate pytorch
#run the application:
python test.py --dataroot ../test_images/ --model test --gpu_ids 0 --learn_residual --dataset_mode single  --name LFOV_gram --which_epoch 220
