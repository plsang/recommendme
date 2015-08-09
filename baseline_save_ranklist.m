function baseline_save_ranklist(prms, feat_name, method, codebook_size, top_n, top_query)
	[q_regions, r_regions] = baseline_load_regions(prms, feat_name, method, codebook_size, top_n, top_query);
	query_keys = fieldnames(q_regions);
	
	query_output_dir = sprintf('%s/bow_%s.%s.%d.top%d.top%dquery', prms.regions_dir, feat_name, method, codebook_size, top_n, top_query);
	if ~exist(query_output_dir, 'file'),
		error('dir not found!\n');
	end
	
	remove_stop_words = 1;
	top_return_list = 10000;
	
	for ii = 1:length(query_keys),	
		query_key = query_keys{ii};
		query_name = query_key(6:end);
		fprintf('***[%d/%d] Running for query [%s]...\n', ii, length(query_keys), query_name);
		query_file = sprintf('%s/%s.mat', query_output_dir, query_name);
		return_file = sprintf('%s/%s_rd.mat', query_output_dir, query_name);		
		fprintf('Loading inverted index files...\n');
		queries = load(query_file, 'region_feats');
		returns = load(return_file, 'region_feats');
		invs = logical(returns.region_feats);
		codes = logical(queries.region_feats);
		
		if remove_stop_words == 1,
			word_sum = sum(invs, 2);
			[word_sum, word_idx] = sort(word_sum, 'descend');
			sw_start = ceil(0.05*length(word_sum));		
			sw_end = ceil(0.1*length(word_sum));
			%stop_idx = union(word_idx(1:sw_start), word_idx(end-sw_end+1:end));
			mask_idx = word_idx(sw_start:end-sw_end);
			
			fprintf('Removing stopwords...\n');
			invs = invs(mask_idx, :);
			codes = codes(mask_idx, :);
		end
		
		fprintf('Calculating cosine distances (voting)...\n');
		all_votes = double(codes)'*invs;  %% num_query_regions x num_return_retions
		fprintf('Sorting...\n');
		[sorted_votes, indices] = sort(all_votes(:), 'descend');
		[r_pairs, c_pairs] = ind2sub(size(all_votes), indices);
		
		fprintf('Writing to file...\n');
		baseline_file = sprintf('%s/%s.psr', prms.baseline_output_dir, query_name);
		fh = fopen(baseline_file, 'w');
		for jj=1:top_return_list,
			fprintf ('%d ', jj);
			query_idx = r_pairs(jj);
			return_idx = c_pairs(jj);
			r_img = r_regions.(query_key).imgs{return_idx};
			fprintf(fh, '%s %d %d %d %d %d %d %d %d %d 1\n', r_img, ...
				q_regions.(query_key).lefts(query_idx),...
				q_regions.(query_key).rights(query_idx),...
				q_regions.(query_key).tops(query_idx),...
				q_regions.(query_key).bottoms(query_idx),...
				r_regions.(query_key).lefts(return_idx),...
				r_regions.(query_key).rights(return_idx),...
				r_regions.(query_key).tops(return_idx),...
				r_regions.(query_key).bottoms(return_idx),...
				sorted_votes(jj));
		end		
		fprintf ('\n');
		fclose(fh);
	end	
end