#!/Users/ian/anaconda3/bin/python3
from pathlib import Path
import os
import argparse
import logging

portal_path
#specify pattern in command line

files = []
for ext in ['*.bam', '*assembly.contigs.fasta']
    #files.extend(glob(ext))
    #files.extend(Path('./*').glob(ext))
    files.extend(Path(portal_path).glob(ext))
files = [os.path.abspath(f) for f in files]

id_pattern = re.compile(r'%s' % pattern)

if len(files) % 2:
    logging.warning('Odd number of files')

#sample_ids = list(set([id_pattern.findall(f)[0] for f in files if f.endswith('assembly.contigs.fasta')]))
sample_ids = list(set([id_pattern.findall(f)[0] for f in files]))

sample_dict = dict()
for s in sample_ids:
    alignment_pattern = '%s*\/Alignment\/*\/.*\.bam$' % s
    assembly_pattern = '%s*\/Assembly\/*\/.*\.fasta$' % s


for f in files:
    if f.endswith('.fasta') or f.endswith('.fna') or f.endswith('.fa'):
        sample_id = id_pattern.findall(f)[0]
        if '/%s/' % sample_id in os.path.dirname(f)
        sample_dict[sample_id] = {'BAM':'a', 'Assembly':}
