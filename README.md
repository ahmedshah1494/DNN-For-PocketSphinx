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
- 
- runNNTrain.py -train_data -val_data
	