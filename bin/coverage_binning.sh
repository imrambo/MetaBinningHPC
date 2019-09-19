#!/bin/bash
envName=binning

module load python/3.7-anaconda-2019.07
#Create the conda environment
# conda create -n $envName python=3

# conda config --add channels defaults
# conda config --add channels bioconda
# conda config --add channels conda-forge
# conda install -c ursky -n $envName maxbin2
# conda install -c ursky -n $envName metabat2
# conda create -n concoct_env python=3 concoct
# conda install -c bioconda samtools conda

#source activate $envName
#Create SLURM jobs for each of the steps with a python script
#==============================================================================
bash sort_BAM_SAM.sh 
#==============================================================================
#Create a temporary file with paths for assembly, BAM, and root directory
paste <(find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "assembly.contigs.fasta") <(find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "*_sorted.bam" -not -empty) <(find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "*.bam" -not -empty | grep -oh ".*metaG_FD") > $tmpDir/paths_tmp.txt

#Create output directories for binning
mkdir -p ~/projects/NERR_JGI/data/*metaG_FD/Binning/metabat2/output ~/projects/NERR_JGI/data/*metaG_FD/Binning/concoct/output/fasta_bins ~/projects/NERR_JGI/data/*metaG_FD/Binning/maxbin/output
#------------------------------------------------------------------------------
#Create depth files
nJob_depthfile=3; nThread_depthfile=4
joblog_depthfile=${joblogDir}/jgi_depthfile_${datetime}.joblog
time find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "*_sorted.bam" | \
    parallel --jobs $nJob_depthfile --joblog  $joblog_depthfile jgi_summarize_bam_contig_depths --outputDepth {.}_depth.txt {} && echo DONE

exitStats_depthfile=$( tail -n +2 $joblog_depthfile | awk '$7 != 0' | wc -l )
    if [ "$exitStats_depthfile" -eq 0 ]; then
        :;

    else
        echo "WARNING: $exitStats_depthfile commands exited with errors for jgi_summarize_bam_contig_depths"
        echo "Exiting..."
        exit 1
    fi
#Create a temporary file containing paths to files required for binning
paste <(find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "assembly.contigs.fasta") \
    <(find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "*_sorted.bam" -not -empty)  \
    <(find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "*_depth.txt" -not -empty) \
    <(find ~/projects/NERR_JGI/data/*metaG_FD -type f -name "*_sorted.bam" -not -empty | \
    grep -oh ".*metaG_FD") | \
     grep ".*assembly\.contigs\.fasta.*\_sorted.bam.*_depth.txt" > $tmpDir/paths_tmp.txt

#if [$(wc -l $tmpDir/paths_tmp.txt) != $(tail -n +2 $joblog_depthfile | awk '$7 != 0' | wc -l)]; then
#rambo@midgard:~/projects/NERR_JGI/data$ find . -name '*.sam\.**' | grep -oh '.*metaG_FD' | cut -f2 -d'/' | uniq

###============================================================================
###Binning
#==============================================================================
#Minimum length for contigs used in binning
min_contig_length=2500
#------------------------------------------------------------------------------
#metabat2
nThread_metabat=5
nJobs_metabat=4
joblog_metabat=$joblogDir/metabat_${datetime}.joblog

time parallel --colsep '\t' --jobs $nJobs_metabat --joblog $joblog_metabat metabat --inFile {1} --abdFile {3} --outFile {4}/Binning/metabat2/output -t $nThread_metabat --minCVSum 0 --saveCls -d --minCV 0.1 --minContig $min_contig_length --verbose :::: $tmpDir/paths_tmp.txt
#------------------------------------------------------------------------------
#concoct
joblog_cut_up_fasta=${joblogDir}/cut_up_fasta_${datetime}.joblog
nJobs_cut_up_fasta=4
time parallel --colsep '\t' --jobs $nJobs_cut_up_fasta --joblog $joblog_cut_up_fasta cut_up_fasta.py {1} -c 10000 -o 0 --merge_last -b {4}/Binning/concoct/contigs_10K.bed '>' {4}/Binning/concoct/contigs_10K.fa :::: $tmpDir/paths_tmp.txt

joblog_concoct_covtable=${joblogDir}/concoct_covtable_${datetime}.joblog
nJobs_concoct_covtable=4
time parallel --colsep '\t' --jobs $nJobs_concoct_covtable --joblog $joblog_concoct_covtable concoct_coverage_table.py {4}/Binning/concoct/contigs_10K.bed {2} '>' {4}/Binning/concoct/coverage_table.tsv :::: $tmpDir/paths_tmp.txt

joblog_concoct_main=${joblogDir}/concoct_main_${datetime}.joblog
nJobs_concoct_main=4
time parallel --colsep '\t' --jobs $nJobs_concoct_main --joblog $joblog_concoct_main concoct --composition_file {4}/Binning/concoct/contigs_10K.fa --coverage_file {4}/Binning/concoct/coverage_table.tsv -b {4}/Binning/concoct/output :::: $tmpDir/paths_tmp.txt

joblog_concoct_cluster=${joblogDir}/concoct_main_${datetime}.joblog
nJobs_concoct_cluster=4
time parallel --colsep '\t' --jobs $nJobs_concoct_cluster --joblog $joblog_concoct_cluster merge_cutup_clustering.py {4}/Binning/concoct/output/clustering_gt1000.csv '>' {4}/Binning/concoct/output/clustering_merged.csv :::: $tmpDir/paths_tmp.txt

joblog_concoct_extract=${joblogDir}/concoct_main_${datetime}.joblog
nJobs_concoct_extract=4
time parallel --colsep '\t' --jobs $nJobs_concoct_extract --joblog $joblog_concoct_extract extract_fasta_bins.py {1} {4}/Binning/concoct/output/clustering_merged.csv --output_path {4}/Binning/concoct/output/fasta_bins :::: $tmpDir/paths_tmp.txt
#------------------------------------------------------------------------------
#Create the TSV file(s) for DASTool
awk '/>/{sub(">","&"FILENAME"_");sub(/\.fa/,x)}1' *.fa | grep '>' | sed -i 's/\.//g' | sed -i 's/>//g' >
#-------------------------------------------------------------------------

DASTool.sh -i $TSV -l $binning_methods -c $contigs -o $outputDir --write-bins 1 -t $nThread_dastool
