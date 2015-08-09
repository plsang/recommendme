# Written by Sang Phan - plsang@nii.ac.jp
# Last update May 22, 2013
#!/bin/sh
# Force to use shell sh. Note that #$ is SGE command
#$ -S /bin/sh
# Force to limit hosts running jobs
#$ -q all.q@@bc2hosts,all.q@@bc3hosts
# Log starting time

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <detector> <start_image> <end_image>" >&2
  exit 1
fi

count=0
outdir='/net/sfv215/export/raid4/ledduy/plsang/recommendme1m/feats'/$1.sift
if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

img_dir='/net/sfv215/export/raid4/ledduy/ndthanh/RecommendMe.ICCV/datasets/mqa/org/allimg.1M.rsz/'

#for f in `ls /net/sfv215/export/raid4/ledduy/ndthanh/RecommendMe.ICCV/datasets/mqa/org/allimg.rsz/*.jpg`
#note: error argument list is too long because of large number of files

for f in `find $img_dir -name "*.jpg"`
do 
	if [ "$count" -ge $2 ] && [ "$count" -lt $3 ]; then
		#echo $count
		fp="${f%}" 		#get file path
		fn="${fp##*/}"	#get file name with extension
		img="${fn%.*}"	#get file name without extension (image id)
		of=$outdir/$img.$1.sift
		if [ -f $of ]
		then
			echo "File $of already exist! skipped!"
			let count=$count+1;
			continue
		fi
		echo [$count]" Extracting image $fn ..."
		/net/per900a/raid0/plsang/tools/featurespace/compute_descriptors_64bit.ln -$1 -sift -i $f -o1 $of
	fi
	let count=$count+1;
	
done
