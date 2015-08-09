function baseline_load_region_features(prms, feat_name, method, codebook_size, top_n, top_query, start_idx, end_idx)
	[q_regions, r_regions] = baseline_load_regions(prms, feat_name, method, codebook_size, top_n, top_query, start_idx, end_idx);
	query_keys = fieldnames(q_regions);
	
	query_output_dir = sprintf('%s/bow_%s.%s.%d.top%d.top%dquery', prms.regions_dir, feat_name, method, codebook_size, top_n, top_query);
	if ~exist(query_output_dir, 'file'),
		mkdir(query_output_dir);
	end
	
	parfor ii = 1:length(query_keys),	
		query_key = query_keys{ii};
		query_name = query_key(6:end);
		fprintf('***[%d/%d] Running for query [%s]...\n', ii, length(query_keys), query_name);
		% on query region list
		region_file = sprintf('%s/%s.mat', query_output_dir, query_name);
		region_infos = q_regions.(query_key);
		region_feats = baseline_load_features_for_one_region(prms, region_infos, feat_name, method);
		par_save(region_file, region_feats);
		
		% on return image region list
		region_file = sprintf('%s/%s_rd.mat', query_output_dir, query_name);
		region_infos = r_regions.(query_key);
		region_feats = baseline_load_features_for_one_region(prms, region_infos, feat_name, method);
		par_save(region_file, region_feats );
	end
end

function par_save( output_file, region_feats )
  save( output_file, 'region_feats', '-v7.3');
end