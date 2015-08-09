function prms = reme_get_prms(dataset)
	prms = struct;
	switch dataset
		case {'mqa10k'}
			prms.dataset = 'mqa10k';
			prms.root_dir = '/net/per900a/raid0/plsang/recommendme';
			prms.img_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/mqa/org/allimg.10k.rsz';
			prms.feat_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa/feats';
			prms.codebook_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa/codebook';
			prms.codebook_dir = '/net/per900a/raid0/plsang/recommendme/codebook'; %% tmp
			prms.invfiles_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa/inverted_files';
			prms.scores_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa/scores';
			prms.img_list = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa/metadata/imagelist.lst';
			prms.inst_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/mqa/org/coreset/image'; % instance dir, used for creating ground truth
			prms.gt_file = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa/groundtruth/gt.mat';
			prms.output_list_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mqa/10kset'; %output dir, top rank list for RecommendMe
			prms.max_features = 10000000;  % maximum points for clustering
			prms.chunk_size = 1000; % number of image per chunk for building inverted index
		case {'mqa100k'}
			prms.dataset = 'mqa100k';
			prms.root_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme';
			prms.img_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/mqa/org/allimg.100k.rsz';
			prms.feat_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa100k/feats';
			prms.codebook_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa100k/codebook';
			prms.invfiles_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa100k/inverted_files';
			prms.scores_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa100k/scores';
			prms.img_list = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa100k/metadata/imagelist.lst';
			prms.inst_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/mqa/org/coreset/image'; % instance dir, used for creating ground truth
			prms.gt_file = '/net/per610a/export/das11f/ledduy/plsang/recommendme/mqa100k/groundtruth/gt.mat';
			prms.output_list_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mqa/100kset';
			prms.max_features = 10000000;  % maximum points for clustering
			prms.chunk_size = 1000; % number of image per chunk for building inverted index
		case {'oxford100k'}
			prms.dataset = 'oxford100k';
			prms.root_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme';
			prms.img_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/oxbuild/org/allimg.100k.rsz';
			prms.feat_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/oxford100k/feats';
			prms.codebook_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/oxford100k/codebook';
			prms.invfiles_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/oxford100k/inverted_files';
			prms.scores_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/oxford100k/scores';
			prms.regions_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/oxford100k/regions';
			prms.img_list = '/net/per610a/export/das11f/ledduy/plsang/recommendme/oxford100k/metadata/imagelist.lst';
			prms.inst_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/oxbuild/org/oxbuild_images_good.resized'; % instance dir, used for creating ground truth
			prms.gt_file = '/net/per610a/export/das11f/ledduy/plsang/recommendme/oxford100k/groundtruth/gt.mat';
			prms.output_lists_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/oxbuild/100kset/bow.1m/lists_extra_queries1';
			prms.output_features_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/oxbuild/100kset/bow.1m/features.bow10k';
			prms.query_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/oxbuild/100kset/bow.1m/extra_queries1';
			prms.query_list = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/oxbuild/100kset/bow.1m/csv/selected.lst';
			prms.region_list_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/oxbuild/100kset/bow.1m/regionlist';
			prms.baseline_output_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/oxbuild/100kset/bow.1m/baseline';
			
			prms.max_features = 10000000;  % maximum points for clustering
			prms.chunk_size = 1000; % number of image per chunk for building inverted index	
		case {'reme1m'} % mydataset 1M
			prms.dataset = 'reme1m';
			prms.root_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme';
			prms.img_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/mydataset/org/allimg.1m.rsz';
			prms.feat_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/reme1m/feats';
			prms.codebook_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/reme1m/codebook';
			prms.invfiles_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/reme1m/inverted_files';
			prms.scores_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/reme1m/scores';
			prms.regions_dir = '/net/per610a/export/das11f/ledduy/plsang/recommendme/reme1m/regions';
			prms.img_list = '/net/per610a/export/das11f/ledduy/plsang/recommendme/reme1m/metadata/imagelist.lst';
			prms.inst_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/datasets/mydataset/org/cates'; % instance dir, used for creating ground truth
			prms.gt_file = '/net/per610a/export/das11f/ledduy/plsang/recommendme/reme1m/groundtruth/gt.mat';
			prms.output_lists_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mydataset/1mset/bow.1m/lists';
			prms.output_features_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mydataset/1mset/bow.1m/features.bow10k';
			prms.query_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mydataset/1mset/bow.1m/extra_queries1';
			prms.query_list = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mydataset/1mset/bow.1m/csv/selected.lst';
			prms.region_list_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mydataset/1mset/bow.1m/regionlist';
			prms.baseline_output_dir = '/net/per610a/export/das11f/ledduy/ndthanh/RecommendMe.ICDM/experiments/mydataset/1mset/bow.1m/baseline';
			
			prms.max_features = 10000000;  % maximum points for clustering
			prms.chunk_size = 1000; % number of image per chunk for building inverted index	
		otherwise
			error('Unknown dataset');
	end	
end