function [ feats ] = select_features(feat_name)
%SELECT_FEATURES Summary of this function goes here
%   Detailed explanation goes here
	run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
	
    % parameters
    max_features = 10000000;
    imgs = textread('/net/per900a/raid0/plsang/recommendme/metadata/mqa.lst', '%s');
	  
    max_features_per_image = 1.05*ceil(max_features/length(imgs));
    
    all_feats = cell(length(imgs), 1);
    
    parfor ii = 1:length(imgs),
        img = imgs{ii};

		fprintf('[%d/%d] Loading file %s ...\n', ii, length(imgs), img);
        feat_file = ['/net/per900a/raid0/plsang/recommendme/feats/' feat_name '/' img(1:end-3) 'mat'] 
        feat = load(feat_file, 'feats');
		feats = feat.feats;
		
		if isempty(feats), continue; end;
        
		feats = feats(3:end,:);
		
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

    save(['/net/per900a/raid0/plsang/recommendme/codebook/selected_feats_' feat_name '.mat'], 'all_feats', '-v7.3');
    
end

