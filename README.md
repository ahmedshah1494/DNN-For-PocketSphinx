# DNNs For ASR
The work is part of a Google Summer of Code project, the goal of which was to integrate DNNs with CMUSphinx. This particular repository contains some convenient scripts that wrap Keras code and allow for easy training of DNNs.
## Getting Started
Start by cloning the repository.
### Prerequisites
The required python libraries available from pypi are in the requirements.txt file. Install them by running:
```
pip install -r requirements.txt
```
Additional libraries not available from pypi:
- tfrbm- for DBN-DNN pretraining.
	- available at https://github.com/meownoid/tensorfow-rbm
## Getting Started
Since the project is primarily intended to be used with PocketSphinx the file formats for feature files, state-segmentation output files and the prediction files are in sphinx format. 
### Feature File Format
```
N: number of frames
M: dimensions of the feature vector
N*M (4 bytes)
Frame 1: f_1...f_M (4*M bytes)
.
.
.
Frame N: f_1,...,f_M (4*M bytes)
```
Look at readMFC in utils.py
### state-segmentation files
format for each frame:
```
 2    2   2    1   4  bytes
st1 [st2 st3] pos scr
```
### Prediction output
format for each frame:
```
N: number of states
N (2 bytes)
scr_1...scr_N (2*N bytes)
```
### Wrapper Scripts 
```
runDatasetGen.py -train_fileids -val_fileids [-test_fileids] -n_filts -feat_dir -feat_ext -stseg_dir -stseg_ext -mdef [-outfile_prefix] [-keep_utts]
```
runDatasetGen takes feature files and state-segmentation files stored in sphinx format along with the definition file of the GMM-HMM model to generate a set of numpy arrays that form a python readable dataset.
runDatasetGen writes the following files in the directory it was called in:
- Data Files
	- <outfile_prefix>_train.npy
	- <outfile_prefix>_dev.npy
	- <outfile_prefix>_test.npy
- label files
	- <outfile_prefix>_train_label.npy
	- <outfile_prefix>_dev_label.npy
	- <outfile_prefix>_test_label.npy
- metadata file
	- <outfile_prefix>_meta.npz

The metadata file is a zipped collection of arrays with the follwing keys:
- File names for utterances
	-filenames_Train
	-filenames_Dev
	-filenames_Test
- Number of frames per utterance (useful if -keep_utts is not set)
	- framePos_Train
	- framePos_Dev
	- framePos_Test
- State Frequencies (useful for scaling in some cases)
	- state_freq_Train
	- state_freq_Dev
	- state_freq_Test
```
runNNTrain.py -train_data -train_labels -val_data -val_labels -nn_config [-context_win] [-cuda_device_id] [-pretrain] [-keras_model] -model_name
```
runNNTrain takes the training and validation data files (as generated by runDatasetGen) and trains a neural network on them. 
The architecture and parameters of the neural network is defined in a text file. Currently this script supports 4 network types:
- MLP (mlp)
- Convolutional Neural Network (conv)
- MLP with short cut connections (resnet)
- Convolutional Network with residual connections in the fully connected layers (conv + resnet)
See sample_nn.cfg for an example.
The format for the configuration file is:
```
param value
```
if value has multiple elemets (represented by ... below) they should be separated by spaces.
Params and possible values:
- type 			mlp, conv, resnet, conv+resnet
- width 		any integer value
- depth			any integer value
- dropout		float in (0,1)
- batch_norm	-
- activation	sigmoid, hard_sigmoid, elu, relu, selu, tanh, softplus, softsign, softmax, linear
- optimizer		sgd, adam, adagrad
- lr 			float in (0,1)
- batch_size 	any integer value
- ctc_loss		-
for type = conv and type = conv+resnet
- conv 			[n_filters, filter_window]...
- pooling		None, [max/avg, window_size, stride_size]
for type = resnet and type = conv+resnet
- block_depth	any integer value
- n_blocks		any integer value
