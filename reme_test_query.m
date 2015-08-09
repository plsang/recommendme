function reme_test_query(query_image_list, dataset)
	% query_image_list: name of query list file in folder, 
	% by default: /net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/oxbuild/100kset/queries
	% specified by prms.query_dir in reme_get_prms.m
	
	% see also: reme_get_prms.m
	% output_lists -- > prms.output_lists_dir
	% output_features --> prms.output_features_dir
	
	% dataset = 'oxford100k';
	
	feat_name = 'heslap';
	method = 'vq';
	codebook_size = 1000000;
	top_n = 1000;
	remove_stop_words = 1;

	prms = reme_get_prms(dataset);
	reme_search (prms, query_image_list, feat_name, method, codebook_size, top_n, remove_stop_words);

	if matlabpool('size') == 0,
		matlabpool open;
	end
	
	% note: if codebook_size is not specified, by default 10k codebook will be used.
	%reme_encode_hkm_save(prms, feat_name, method, codebook_size);
	reme_encode_hkm_save(prms, feat_name, method);
	matlabpool close;
end