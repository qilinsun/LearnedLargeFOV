
cd /home/sunq/FOV/Train/

source activate pytorch
#run the application:
#python test.py --dataroot ../images/test/ --model test --gpu_ids 4 --learn_residual --dataset_mode single --name LFOV11

#python train.py --dataroot ../10mm/ --model content_gan --gpu_ids 0  --fineSize 512 --lr 0.0001  --batchSize 8 --name Unet  

#python train.py --dataroot ../10mm/ --model content_gan --gpu_ids 1  --fineSize 1024 --lr 0.00001  --batchSize 2 --name LFOV11 --continue

python train.py --dataroot ../10mm/ --model content_gan --gpu_ids 2  --fineSize 512 --lr 0.0001  --batchSize 8 --name LFOV_gram
