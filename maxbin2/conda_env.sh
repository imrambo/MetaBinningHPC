#!/bin/bash
#Conda environment for running MaxBin2
envName=$1
conda create -n $envName python=3.7
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels hcc
conda config --add channels ursky
conda install -c hcc -n $envName idba
conda install -c bioconda -n $envName bowtie2 fraggenescan hmmer
conda install -c ursky -n $envName maxbin2
