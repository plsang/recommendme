function [ feats ] = reme_select_features_hkm(prms, feat_name)
%SELECT_FEATURES Summary of this function goes here
%   Select feature extracted from featurespace toolbox
	
	run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
    % parameters
	
    max_features = prms.max_features;
	
    imgs = textread(prms.img_list, '%s');
	  
    max_features_per_image = ceil(1.05*max_features/length(imgs));
    
    all_feats = cell(length(imgs), 1);
    feat_dir = prms.feat_dir;
	
	% format of output format 1 (from featurespace help)
	fmt_str = '%f %f %f %f %f';
	for ii = 1:128,
		fmt_str = [fmt_str ' %d'];
	end
	
    parfor ii = 1:length(imgs),
        img = imgs{ii};

		fprintf('[%d/%d] Loading file %s ...\n', ii, length(imgs), img);
        feat_file = sprintf('%s/%s.sift/%s.%s.sift', feat_dir, feat_name, img(1:end-4), feat_name);
        if ~exist(feat_file, 'file'), continue; end;
        
		feats = load_feature(feat_file, fmt_str);    
		
		if isempty(feats), continue; end;
        		
        if size(feats, 2) > max_features_per_image,
            all_feats{ii} = vl_colsubset(feats, max_features_per_image);
        else
            all_feats{ii} = feats;
        end
        
    end
    
    % concatenate features into a single matrix
    all_feats = cat(2, all_feats{:});
    
    if size(all_feats, 2) > max_features,
         all_feats = vl_colsubset(all_feats, max_features);
    end

    save([prms.codebook_dir '/selected_feats_' feat_name '.mat'], 'all_feats', '-v7.3');
    
end

