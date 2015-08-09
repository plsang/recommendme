function mean_recall = reme_cal_mean_recall_save (prms, feat_name, method, codebook_size, top_n, top_query, remove_stop_words)
	%% top_n: top rank
	%% top_query: top best query, select one best query for each instance s
	gt = load(prms.gt_file, 'gt');
	gt = gt.gt;
	
    fprintf('Loading inverted index files...\n');
	feat_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.feat_dir, feat_name, method, codebook_size);
	
	score_file = sprintf('%s/bow_%s.%s.%d.top%d.top%dquery.mat', prms.scores_dir, feat_name, method, codebook_size, top_n, top_query);
	if exist(score_file, 'file'),
		fprintf('File already exist. Skipped!\n');
		%return;
	end;
	
	index_file = sprintf('%s/bow_%s.%s.%d.mat', prms.invfiles_dir, feat_name, method, codebook_size);
	invs = load(index_file, 'invs');
	invs = invs.invs;

	if remove_stop_words == 1,
		word_sum = sum(invs, 2);
		[word_sum, word_idx] = sort(word_sum, 'descend');
		sw_start = ceil(0.05*length(word_sum));		
		sw_end = ceil(0.1*length(word_sum));
		%stop_idx = union(word_idx(1:sw_start), word_idx(end-sw_end+1:end));
		mask_idx = word_idx(sw_start:end-sw_end);
		
		fprintf('Removing stopwords...\n');
		tic;
        invs = invs(mask_idx, :);
		toc;
	end
	
	%mean_recall = [];
    classes = fieldnames(gt);
	
	top_queries_imgs = cell(length(classes), 1);
	top_queries_classes = cell(length(classes), 1);
	top_queries_returns = cell(length(classes), 1); % index of return images; 
	top_queries_recalls = cell(length(classes), 1); 
	
	mean_recall = cell(length(classes), 1);
	
	imgs = textread(prms.img_list, '%s');		
	
	parfor ii = 1:length(classes),
        
        fname = classes{ii};
		mean_class_recall = [];
        
        fprintf('[%d/%d] Cal mean recall for class %s \n', ii, length(classes), fname);
        
		max_idx = [];
		max_recall = -1;
		max_query = [];
		
		tmp_imgs = {};
		tmp_classes = {};
		tmp_returns = [];
		tmp_recalls = [];	
		for img_id = gt.(fname).id,
            
			img = imgs{img_id};	
			tmp_imgs{end+1} = img;
			tmp_classes{end+1} = fname;
			
			feat_file = sprintf('%s/%s.mat', feat_dir, img(1:end-4));

			code = load(feat_file, 'code');
			
			if remove_stop_words == 1,
				code.code = code.code(mask_idx);
			end
			
			votes = sum(invs(code.code ~= 0, :));
			[res, idx] = sort(votes, 'descend');
			
			rank_idx = arrayfun(@(x)find(idx == x), gt.(fname).id);

			rank_idx_topn = find(rank_idx <= top_n+1);
			
			%update : (length(rank_idx_topn)-1) exclude the query one
			%update 2: (length(rank_idx) - 1) also exclude the query one :-)
			class_recall = (length(rank_idx_topn)-1)/(length(rank_idx) - 1);
			
			if(max_recall < class_recall),
				max_recall = class_recall;
				max_idx = idx;
				max_query = img;
			end
			tmp_returns = [tmp_returns; idx(1:top_n+1)];
			tmp_recalls = [tmp_recalls; class_recall];
			mean_class_recall = [mean_class_recall; class_recall];
		end
			
		mean_class_recall = mean(mean_class_recall);
		fprintf(' mean_recall(%s) = %f \n', fname, mean_class_recall);
		
		mean_recall{ii} = mean_class_recall;		
		
		%top_queries_imgs{ii} = tmp_imgs;
		%top_queries_classes{ii} = tmp_classes;
		%top_queries_returns{ii} = tmp_returns;
		%top_queries_recalls{ii} = tmp_recalls;
		
		%%update May 27th, choose one top query for each instance. this one is appllied when number of instance is small (i.e. 10/52)
		[tmp_sorted_recalls, tmp_idx] = sort(tmp_recalls, 'descend');
		max_index = top_query;
		if max_index > length(tmp_idx),
			max_index = length(tmp_idx); 
		end
		top_queries_imgs{ii} = tmp_imgs(tmp_idx(1:max_index));
		top_queries_classes{ii} = tmp_classes(tmp_idx(1:max_index));
		top_queries_returns{ii} = tmp_returns(tmp_idx(1:max_index), :);
		top_queries_recalls{ii} = tmp_recalls(tmp_idx(1:max_index));
	end
	
	mean_recall = cat(2, mean_recall{:});
	
	% merge
	top_queries.imgs = cat(2, top_queries_imgs{:});
	top_queries.classes = cat(2, top_queries_classes{:});
	top_queries.returns = cat(1, top_queries_returns{:});
	top_queries.recalls = cat(1, top_queries_recalls{:});
	
	% sort by recalls
	%[sorted_queries, top_idx] = sort(top_queries.recalls, 'descend');
	%top_queries.imgs = top_queries.imgs(top_idx(1:top_query));
	%top_queries.classes = top_queries.classes(top_idx(1:top_query));
	%top_queries.returns = top_queries.returns(top_idx(1:top_query), :);
	%top_queries.recalls = top_queries.recalls(top_idx(1:top_query));

	save(score_file, 'top_queries');
	mean(mean_recall)	
	
	for jj = 1:length(top_queries.imgs),
		img_name = top_queries.imgs{jj};
		ftop_file = sprintf('%s/%s_rd.lst', prms.output_lists_dir, img_name(1:end-4));			
		fprintf('writting top %d images for image %s...\n', top_n, img_name);
		top_imgs = imgs(top_queries.returns(jj,:));
		ftop = fopen(ftop_file, 'w');
		for kk = 2:length(top_imgs),
			if kk == length(top_imgs),			
				fprintf(ftop, '%s', top_imgs{kk}(1:end-4));
			else
				fprintf(ftop, '%s\n', top_imgs{kk}(1:end-4));
			end
		end
		fclose(ftop);
	end
	
	% select union set of images
	all_idx = reshape(top_queries.returns, 1, []);
	all_imgs = imgs(unique(all_idx));
	fall_file = sprintf('%s/all_return_images_rd.lst', prms.output_lists_dir);			
	fprintf('writting top %d images for image %s...\n', top_n, img_name);
	
	fall = fopen(fall_file, 'w');
	for kk = 1:length(all_imgs),
		if kk == length(all_imgs),			
			fprintf(fall, '%s', all_imgs{kk}(1:end-4));
		else
			fprintf(fall, '%s\n', all_imgs{kk}(1:end-4));
		end
	end
	fclose(fall);
	% top	
	
end