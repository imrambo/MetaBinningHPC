#Paths for joblogs, temporary files, and the time/date stamp for files
joblogDir=~/joblogs
tmpDir=~/tmp
datetime=$(date +%d-%m-%Y_%H-%M-%S)
#==============================================================================
#Variables for converting SAM to sorted BAM
nJob_samsort=3; nThread_samsort=4; threadMem_samsort=2G
#Number of jobs for checking BAM headers
nJobs_sorttest=2

searchDir=~/projects/NERR_JGI/data/*metaG_FD
time find $searchDir -type f -name "*.sam\.**" -not -empty | \
    parallel --joblog ${joblogDir}/sam_to_sort_bam_${datetime}.joblog --jobs $nJob_samsort samtools view -huS -F4 {} '|' samtools sort -@ $nThread_samsort -m $threadMem_samsort -o - '>' {.}_sorted.bam && echo DONE

joblog_sorttest=~/joblogs/sort_test_${datetime}.joblog

find $searchDir -type f -name "*_sorted.bam" | parallel --joblog $joblog_sorttest --jobs $nJobs_sorttest samtools view -H {} '|' grep "\@HD.*SO\:unsorted"

#Check if any jobs from the parallel run exited with a certain code
exitStats_sorttest=$( tail -n +2 $joblog_sorttest | awk '$7 == 0' | wc -l )
    if [ "$exitStats_sorttest" -eq 0 ]; then
        :;

    else
        echo "WARNING: $exitStats_sorttest BAM files were not sorted. Ensure BAM files are sorted and have correct headers before proceeding."
        echo "Exiting..."
        exit 1
    fi
exit 0
