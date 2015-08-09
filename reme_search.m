function reme_search (prms, query_image_list, feat_name, method, codebook_size, top_n, remove_stop_words)
	% prms = reme_get_prms('oxford100k')
	% query_image_list: 	name of query_image_list file, directory is specified in prms.query_dir
	% feat_name: 			'heslap', 'harlap'
	% method: 				vq (vector quantization)
	% codebook_size: 		1000000
	% top_n: 				1000
	% remove_stop_words: 	1

	run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
	
	query_image_list_file = sprintf('%s/%s', prms.query_dir, query_image_list);
	query_images = textread(query_image_list_file, '%s');	
	
	codebook_file = sprintf('%s/codebook_hkm_%s_%d.mat', prms.codebook_dir, feat_name, codebook_size);
	fprintf('Loading codebook...\n');
	tree = load(codebook_file, 'tree');
	tree = tree.tree;
	
	fprintf('Loading inverted index files...\n');

	index_file = sprintf('%s/bow_%s.%s.%d.mat', prms.invfiles_dir, feat_name, method, codebook_size);
	invs = load(index_file, 'invs');
	invs = invs.invs;

	mask_idx = ones(codebook_size, 1);
	
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
	
	all_idx = zeros(length(query_images), top_n);
	for ii = 1:length(query_images),
		query_image = query_images{ii};
		
		fprintf('[%d/%d] Processing image [%s]...\n', ii, length(query_images), query_image);
		
		idx = reme_search_for_one_query (prms, query_image, feat_name, method, codebook_size, tree, top_n, invs, mask_idx);
		all_idx(ii, :) = idx; 
	end	
	
	
	% select union set of images
	imgs = textread(prms.img_list, '%s');	
	unique_idx = unique(all_idx(:));
	all_imgs = imgs(unique_idx);
	fall_file = sprintf('%s/all_return_images_rd.lst', prms.output_lists_dir);			
	fprintf('writting all return images ...\n');
	
	fall = fopen(fall_file, 'w');
	%update: also include query images
	
	for kk = 1:length(query_images),
		fprintf(fall, '%s\n', query_images{kk});
		
	end
	
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


function idx = reme_search_for_one_query (prms, query_image, feat_name, method, codebook_size, tree, top_n, invs, mask_idx)
	
	ftop_file = sprintf('%s/%s_rd.lst', prms.output_lists_dir, query_image);			
	
	imgs = textread(prms.img_list, '%s');		
	%% top_n: top rank
	%% top_query: top best query, select one best query for each instance s
	%% return: indexes of return top return images

	feat_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.feat_dir, feat_name, method, codebook_size);
	feat_file = sprintf('%s/%s.mat', feat_dir, query_image);
	
	bool_new_query = 0;

	if ~exist(feat_file),
		bool_new_query = 1;
		fprintf('Extracting feature for image [%s]...\n', query_image);
		input_image = sprintf('%s/%s.jpg', prms.query_dir, query_image);
		if ~exist(input_image),
			error('File [%s] does not exist!!\n', input_image);
		end
		
		code = reme_extract_feature(input_image, feat_name, tree, codebook_size);		
	else
		code = load(feat_file, 'code');
		code = code.code;
	end
		
	
	code = code(mask_idx);
	
	votes = sum(invs(code ~= 0, :));
	[res, idx] = sort(votes, 'descend');
	

	fprintf('writting top %d images for image %s...\n', top_n, query_image);
	
	ftop = fopen(ftop_file, 'w');
	
	start_jj = 1;
	if ~bool_new_query,
		start_jj = 2;
		% check if first is new
		first_img_name = imgs{idx(1)};
		if ~isequal(first_img_name(1:end-4), query_image),
			error('Query name exists but not on top of the return list. Return image: [%s]\n', first_img_name);
		end
	end
	
	for jj = start_jj:start_jj + top_n - 1,		
		img_name = imgs{idx(jj)};		
		fprintf(ftop, '%s\n', img_name(1:end-4));		
	end
	fclose(ftop);
	
	idx = idx(start_jj:start_jj + top_n - 1);
end
