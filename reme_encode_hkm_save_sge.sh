# Written by Duy Le - ledduy@ieee.org
# Last update Jun 26, 2012
#!/bin/sh
# Force to use shell sh. Note that #$ is SGE command
#$ -S /bin/sh
# Force to limit hosts running jobs
#$ -q all.q@@bc4hosts,all.q@@bc5hosts
# Log starting time
date 
# for opencv shared lib
export LD_LIBRARY_PATH=/net/per900a/raid0/plsang/usr.local/lib:/usr/local/lib:$LD_LIBRARY_PATH
# Log info of the job to output file  *** CHANGED ***
echo [$HOSTNAME] [$JOB_ID] [matlab -nodisplay -r "reme_encode_hkm_save_sge( '$1', '$2', '$3', $4, $5, $6 )"]
# change to the code dir  --> NEW!!! *** CHANGED ***
cd /net/per900a/raid0/plsang/tools/recommendme_v4
# Log info of current dir
pwd
# Command - -->  must use " (double quote) for $2 because it contains a string  --- *** CHANGED ***
matlab -nodisplay -r "reme_encode_hkm_save_sge( '$1', '$2', '$3', $4, $5, $6 )"
#matlab -nodisplay -r "encode_hkm( '$1', '$2', $3, $4, $5 )"
# Log ending time
date
