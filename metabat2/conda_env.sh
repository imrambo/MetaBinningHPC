#!/bin/bash
#Conda environment for running MetaBat2
envName=$1
conda create -n $envName python=3.7
conda install -c ursky -n $envName metabat2
