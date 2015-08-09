function [q_regions, r_regions] = baseline_load_regions(prms, feat_name, method, codebook_size, top_n, top_query, start_idx, end_idx)
	% where is the region list?
	% load query list
	
	if isfield(prms, 'query_list'),
		fprintf('loading query list...\n');
		query_imgs = textread(prms.query_list, '%s');
		query_imgs
	else
		score_file = sprintf('%s/bow_%s.%s.%d.top%d.top%dquery.mat', prms.scores_dir, feat_name, method, codebook_size, top_n, top_query);
		if ~exist(score_file, 'file'),
			error('File does not exist!!\n');
		end;
		
		load(score_file, 'top_queries');
		query_imgs = top_queries.imgs;
	end
	
	if ~exist('start_idx', 'var'),
		start_idx = 1;
	end
	
	if ~exist('end_idx', 'var') || end_idx > length(query_imgs),
		end_idx = length(query_imgs);
	end
	
	q_regions = struct;
	r_regions = struct;
	
	max_region_num = 10000;
	
	for ii = start_idx:end_idx,
		query_name = query_imgs{ii};
		query_key = ['reme_' query_name];
		
		fprintf('[%d/%d] Loading query [%s]...', ii, length(query_imgs), query_name);
		
		query_file = sprintf('%s/%s.rl', prms.region_list_dir, query_name);
		[imgs, ids, lefts, rights, tops, bottoms] = textread(query_file, '%s %d %d %d %d %d', 'delimiter', ' ');		
		q_regions.(query_key).imgs = imgs;
		q_regions.(query_key).ids = ids;
		q_regions.(query_key).lefts = lefts;
		q_regions.(query_key).rights = rights;
		q_regions.(query_key).tops = tops;
		q_regions.(query_key).bottoms = bottoms;	
		
		region_file = sprintf('%s/%s_rd.rl', prms.region_list_dir, query_name);
		[imgs, ids, lefts, rights, tops, bottoms] = textread(region_file, '%s %d %d %d %d %d', 'delimiter', ' ');		
		
		if length(ids) > max_region_num,
			fprintf('Select maximum %d regions...\n', max_region_num);
			all_idx = randperm(length(ids));
			sel_idx = all_idx(1:max_region_num);
			sel_idx = sort(sel_idx);
			
			r_regions.(query_key).imgs = imgs(sel_idx);
			r_regions.(query_key).ids = ids(sel_idx);
			r_regions.(query_key).lefts = lefts(sel_idx);
			r_regions.(query_key).rights = rights(sel_idx);
			r_regions.(query_key).tops = tops(sel_idx);
			r_regions.(query_key).bottoms = bottoms(sel_idx);		
		else		
			r_regions.(query_key).imgs = imgs;
			r_regions.(query_key).ids = ids;
			r_regions.(query_key).lefts = lefts;
			r_regions.(query_key).rights = rights;
			r_regions.(query_key).tops = tops;
			r_regions.(query_key).bottoms = bottoms;		
		end
		
	end	
	
end