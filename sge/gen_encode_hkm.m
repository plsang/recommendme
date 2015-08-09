function gen_encode_hkm(dataset, feat_name, method, codebook_size, num_job)
	%feat_name: feature name
	%num_job: number of job
	output_dir = '/net/per900a/raid0/plsang/tools/recommendme_v4/sge/encode-oxford100k-bow10k';
	output_file = sprintf('%s/runme.qsub.%s.%s.k%d.sh', output_dir, feat_name, method, codebook_size);
	fh = fopen(output_file, 'w');
	
	sge_cmd = '/net/per900a/raid0/plsang/tools/recommendme_v4/reme_encode_hkm_save_sge.sh';
	total_img = 20037; %100386; %1100000; %1092526
	num_img_per_job = ceil(total_img/num_job);	
	
	for ii = 1:num_job,
		start_img = (ii-1)*num_img_per_job + 1;
		end_img = ii*num_img_per_job;
		if(end_img > total_img)
			end_img = total_img;
		end
		fprintf(fh, 'qsub -e /dev/null -o /dev/null %s %s %s %s %d %d %d\n', sge_cmd, dataset, feat_name, method, codebook_size, start_img, end_img);
	end
	
	fclose(fh);
end