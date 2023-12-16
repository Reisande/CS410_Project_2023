# CS410_Project_2023

## Software usage tutorial presentation: https://www.youtube.com/watch?v=G6iV1unwWhM

## For ease of use for reviewers, select files for you to test have been uploaded to Google Colab. Note, you need to access it via your UIUC email. Also, if it seems like any other reviewers are running code blocks, please just review the output instead of interrupting anything. Drive/Colab Folder here, read only accessible with an illinois.edu email: https://drive.google.com/drive/folders/1QKTteA65yyul-cZVhEc8RCKiHSH9mAKa

## CUDA: for CUDA install the relevant cuda driver for your GPU (the author used an NVIDIA GeForce RTX 3060 Ti). Then follow the instructions here: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html# to install the cuda toolkit for the GPU. This code was compiled with nvcc version  12.3, V12.3.103 and Nvidia GPU driver 545. Then install Thrust via 
	### git submodule init ; git submodule update
 
 ## Then build using  (Replacing with the relevant information where necessary)

	### nvcc ./inverted.cu -std=c++20 -I./thrust/ -I./thrust/dependencies/libcudacxx/ -I./thrust/dependencies/cub --extended-lambda -Xcompiler=-fno-gnu-unique --gpu-architecture=compute_86 --gpu-code=compute_86,sm_86 -O3 -o ./cuda.out # (for SM 86, your GPU will vary) ; ./cuda.out <file>

## C++: build and run with:  (Replacing <file> with your expected input file.)
	### g++ ./inverted.cpp -std=c++11 -O3 ; ./a.out <file>
 

## Local Python (inverted.py): build and run with: (Replacing <fiile> with your expected input file)
	### Rm -rf terms/* docs/* index.txt ; python3 ./inverted.py <file>
