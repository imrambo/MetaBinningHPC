#!/bin/bash
envName=$1
conda create -n $envName python=3.7
conda config --add channels defaults
conda config --add channels bioconda
conda install -c bioconda -n $envName samtools pysam
