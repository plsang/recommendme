function gen_encode_spm(feat_name, method, codebook_size, num_job)

	%feat_name: feature name
	%num_job: number of job
	output_dir = '/net/per900a/raid0/plsang/tools/recommendme3/sge/encode-oxford100k-spm';
	output_file = sprintf('%s/runme.qsub.%s.%s.%d.sh', output_dir, feat_name, method, codebook_size);
	fh = fopen(output_file, 'w');
	
	sge_cmd = '/net/per900a/raid0/plsang/tools/recommendme3/encode_spm.sh';
	total_img = 100400; %100386; %1100000; %1092526
	num_img_per_job = ceil(total_img/num_job);	
	
	for ii = 1:num_job,
		start_img = (ii-1)*num_img_per_job + 1;
		end_img = ii*num_img_per_job;
		if(end_img > total_img)
			end_img = total_img;
		end
		fprintf(fh, 'qsub -e /dev/null -o /dev/null %s %s %s %d %d %d\n', sge_cmd, feat_name, method, codebook_size, start_img, end_img);
	end
	
	fclose(fh);
	
end