function code = reme_extract_feature(input_image, feat_name, tree, codebook_size)
	% extract feature, using feature space
	tmp_raw_output = tempname;
	cmd = sprintf('/net/per900a/raid0/plsang/tools/featurespace/compute_descriptors_64bit.ln -%s -sift -i %s -o1 %s', feat_name, input_image, tmp_raw_output);
	system(cmd);
	
	feats = load_feature(tmp_raw_output);
	feats = uint8(feats); 
	codeids = vl_hikmeanspush(tree, feats);
    codeids = (codeids(1,:)-1).*100^2 + (codeids(2,:)-1).*100 + codeids(3,:);
	
	code = vl_binsum(zeros(codebook_size, 1), 1, double(codeids));
	
	delete(tmp_raw_output);
	
end