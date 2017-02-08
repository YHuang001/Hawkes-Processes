# Codes for the paper "Tracking Dynamic Point Processes on Networks"

Disclaimer: These are the paper's demo codes. They are only for private studies, if you accidentally see this repository, please refer to the [author's website](erichall87.github.io) to check all codes. All rights go to the authors Eric Hall, etc.

This repository contains scripts for implementing the the algorithms described in [Tracking Dynamic Point Processes on Networks](http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=7469837). The repository contains the following files:

* `MismatchMain.m` : Code to compare the results of our method with a known underlying network structure to simply plugging in all the 
known/given parameters into the definition of a Hawkes process. Demonstrates the benefit of doing estimation to add robustness to model 
mismatch
* `HawkesSynthMain.m`: Code which analyzes synthetic data using both our method and an Online Gradient Descent type method over many trials. 
The main experiment demonstrates that when the assumed model is good OGD and our method perform similarly, but when there is model mismatch
our method is better able to predict event times and learn the underlying network.
* `HawkesMV.m`: Generates Hawkes process data assuming an exponential decay influence function
* `ContinuousLoss.m`: Calculates the negative log-likelihood of a dataset according to the Hawkes process and the specified parameters
* `FormatFigures.m` : Helper function to create nice plots

For more explanation see the [paper](http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=7469837) and the author's [website](erichall87.github.io)




