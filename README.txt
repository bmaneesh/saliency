These are the instructions for using the code of paper-"Learning to Predict Where Humans Look".

The demands installing multiple toolboxes, which are to be compiled with different compilers and difficult to install because of 
the age of some toolboxes and necessary modifications in the code to be made. 

These instructions are for installing the toolboxes and running the code on windows10 with VS14 compiler for MATLAB 2016a.

Following the instructions on the "http://people.csail.mit.edu/tjudd/WherePeopleLook/Code/JuddSaliencyModel/README.txt", install 
-MatlabpyrTools
-VOC_release3(lots of modifications to run on windows,though runs fine on linux,compile+addpath)
-Labelme(addpath)
-saliency Toolbox(addpath)
-FaceDetect(though recommended,I suggest use MATLAB builtin detector instead)
along with code from the current paper.

The modifications in VOC code are from https://code.csdn.net/snippets/128261, and to be made in compile.m,resize.cc,dt.cc and fconv.cc
Apart from these some changes are to be made in saliency.m in "JuddSaliencyModel" also.

These changes have been made and included in this repository.