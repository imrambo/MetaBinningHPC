#!/bin/bash
#Conda environment for running Concoct
envName=$1
conda config --add channels defaults
conda config --add channels bioconda
conda create -n $envName python=3.7 concoct
