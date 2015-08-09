function gen_extr_feature(feat_name, num_job)
	%feat_name: feature name
	%num_job: number of job
	output_dir = '/net/per900a/raid0/plsang/tools/featurespace/sge';
	output_file = sprintf('%s/runme.qsub.%s.sh', output_dir, feat_name);
	fh = fopen(output_file, 'w');
	
	sge_cmd = '/net/per900a/raid0/plsang/tools/featurespace/runme_reme1m_sge.sh';
	total_img = 1100000; %1092526
	num_img_per_job = ceil(total_img/num_job);	
	
	for ii = 1:num_job,
		start_img = (ii-1)*num_img_per_job;
		end_img = ii*num_img_per_job;
		if(end_img > total_img)
			end_img = total_img;
		end
		fprintf(fh, 'qsub -e /dev/null -o /dev/null %s %s %d %d\n', sge_cmd, feat_name, start_img, end_img);
	end
	
	fclose(fh);
end