#!/bin/bash
envName=$1
conda create -n $envName python=3.7
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda install -c ruby-lang -n $envName ruby
conda install -n $envName r-essentials r-base r-data.table r-domc r-ggplot2
conda install -c bioconda -n $envName prodigal diamond pullseq das_tool
