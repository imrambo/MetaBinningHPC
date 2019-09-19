import argparse
import sys
import logging

AddOption('--samsort_thread', dest = 'samsort_thread', type = 'int', nargs = 1, action = 'store',
help = 'number of threads for samtools sort')
AddOption('--samsort_mem', dest = 'samsort_mem', type = 'str', nargs = 1, action = 'store',
help = 'memory per thread for samtools sort. Specify an integer with K, M, or G suffix, e.g. 10G')
'--nJobs'
'--logfile'

def sort_test(alignment):
    isSorted = False
    if type is SAM:


    if type is BAM:

    return isSorted

def sam_to_bam(samsort_thread, samsort_mem, nJobs, logfile):

    "parallel --jobs NJOBS --logfile LOGFILE samtools view -huS -F4 {1} '|' samtools sort -T PREFIX -@ THREAD  -o - '>' {1}.SORTED-BAM ::: UNSORTED_SAMFILES"


    "parallel --jobs NJOBS --logfile LOGFILE samtools view -hSb -F4 {1} '>' {1}.SORTED-BAM ::: SORTED_SAMFILES"



#Get the exit code from sort_BAM_SAM.sh

#Variables for converting SAM to sorted BAM
nJob_samsort=3; nThread_samsort=4; threadMem_samsort=2G
#Number of jobs for checking BAM headers
nJobs_sorttest=2

searchDir=~/projects/NERR_JGI/data/*metaG_FD
"""time find $searchDir -type f -name "*.sam\.**" -not -empty | \
    parallel --joblog ${joblogDir}/sam_to_sort_bam_${datetime}.joblog \
    --jobs $nJob_samsort samtools view -huS -F4 {} '|' \
    samtools sort -@ %d -m %s -o - '>' {.}_sorted.bam && echo DONE""" % (samsort_thread, samsort_mem)



# if sam and sorted:
#     pass
# if sam and unsorted:
#     pass
# if bam and sorted:
#     pass
# if bam and unsorted:
#     pass
