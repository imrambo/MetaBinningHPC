#!/usr/bin/python3
import argparse
import os
import logging
#==============================================================================
def identify_bam(bamfile):
        

#Argument parser
parser = argparse.ArgumentParser()
parser.add_argument('--path_file', dest='path_file', type = str, nargs=1,
action='store', help='file contaning paths')
parser.add_argument('--id_col', dest = 'id_col', type = str, nargs = 1,
action = 'store', help='column of path_file containing root directory')
#==============================================================================
args = vars(parser.parse_args())

with open(path_file, 'r') as pf:
    for p_rec in pf:
        p_list = p_rec.split()
        root_dir = p_list[id_col]
        for p in p_list.pop(id_col):
            if p.startswith(root_dir):
                filename, file_extension = os.path.splitext(p)
                if file_extension == '.bam'
                if file_extension == '.fasta'
                if file_extension == '.txt'
            else:
                logging.warning()
        path_tf_list = [p.startswith(root_dir) ]
        if all(path_tf_list):
            pass
        else:
