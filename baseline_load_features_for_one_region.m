function region_feats = baseline_load_features_for_one_region(prms, region_infos, feat_name, method, codebook_size);

	if ~exist('codebook_size', 'var'),
		codebook_size = 10000;
	end
	
	feat_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.feat_dir, feat_name, method, codebook_size);
	
	codebook_file = sprintf('%s/codebook_hkm_%s_%d.mat', prms.codebook_dir, feat_name, codebook_size);
   
    fprintf('Loading codebook...\n');
    tree = load(codebook_file, 'tree');
    tree = tree.tree;

	region_feats = cell(length(region_infos.ids), 1);
	
	fmt_str = '%f %f %f %f %f';
	for ii = 1:128,
      fmt_str = [fmt_str ' %d'];
	end
   
	prev_img = '';
	for ii = 1:length(region_infos.ids),
		cur_img = region_infos.imgs{ii};
		
		if ~isequal(cur_img, prev_img),
			fprintf('----[%d/%d] Encoding for image [%s]...\n', ii, length(region_infos.ids), cur_img);
			feat_file = sprintf('%s/%s.sift/%s.%s.sift', prms.feat_dir, feat_name, cur_img, feat_name);
			
			if ~exist(feat_file, 'file'),
				input_image = sprintf('%s/%s.jpg', prms.query_dir, cur_img);
				if ~exist(input_image),
					error('File not found [%s]\n', input_image);
				end
				feat_file = tempname;
				cmd = sprintf('/net/per900a/raid0/plsang/tools/featurespace/compute_descriptors_64bit.ln -%s -sift -i %s -o1 %s', feat_name, input_image, feat_file);
				system(cmd);
			end
			
			[feats, frames] = load_feature(feat_file, fmt_str); 
			
			% do quantization for all feature point
			feats = uint8(feats);
			codeids = vl_ikmeanspush(feats, tree);		
		end
				
		% select only points belong to each region
		sel_x_points = frames(1, :) >= region_infos.lefts(ii) & frames(1, :) <= region_infos.rights(ii);
		sel_y_points = frames(2, :) >= region_infos.tops(ii) & frames(2, :) <= region_infos.bottoms(ii);
		
        sel_codeids = codeids(sel_x_points & sel_y_points); 
		code = vl_binsum(zeros(codebook_size, 1), 1, double(sel_codeids));
		region_feats{ii} = code;
		prev_img = cur_img;
	end
	
	region_feats = cat(2, region_feats{:});
end