function reme_gen_sge_code(script_name, pattern, start_num, end_num, num_job)
	% script_name: name of function,
	% pattern: parameter pattern that specifies position for start_idx and end_idx of each job, e.g. 'heslap 10000 %d %d'
	% start_num: 
	% end_num:
	% num_job: number of jobs

	% example: 
	% script_name = 'ClusterRegionInImage'	
	% pattern = 'listfile ppmdir segdir hacdir %d %d'
	% start_num = 1
	% end_num = 3000;
	% num_job = 100;
	
	script_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/sge';
	
	sge_sh_file = sprintf('%s/%s.sh', script_dir, script_name);
	
	output_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/sge';
	[file_dir, file_name] = fileparts(sge_sh_file);
	output_dir = sprintf('%s/qsub-%s', output_dir, file_name);
	
	if ~exist(output_dir, 'file'),
		mkdir(output_dir);
	end
	
	output_file = sprintf('%s/%s.qsub.sh', output_dir, file_name);
	fh = fopen(output_file, 'w');
	
	%100K Snap-and-Ask: 100386  (images)
	%1M Snap-and-Ask: 	1092526  (images)
	%Oxford100K: 		100071  (images)
	%TRECVID INS 2011: 	2657073  (images)
	
	%total_img = 10300; %1092526
	num_per_job = ceil((end_num - start_num + 1)/num_job);	
	
	for ii = 1:num_job,
		start_idx = start_num + (ii-1)*num_per_job;
		end_idx = start_num + ii*num_per_job - 1;
		
		if(end_idx > end_num)
			end_idx = end_num;
		end
		
		params = sprintf(pattern, start_idx, end_idx);
		fprintf(fh, 'qsub -e /dev/null -o /dev/null %s %s\n', sge_sh_file, params);
		
		if end_idx == end_num, break; end;
	end
	
	cmd = sprintf('chmod +x %s', output_file);
	system(cmd);
	
	fclose(fh);
end