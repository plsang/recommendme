function reme_encode_hkm(prms, feat_name, method, codebook_size, start_i, end_i)
   
   %setup vl_feat
   run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
   
   imgs = textread(prms.img_list, '%s');
   
   codebook_file = sprintf('%s/codebook_hkm_%s_%d.mat', prms.codebook_dir, feat_name, codebook_size);
   
   fprintf('Loading codebook...\n');
   tree = load(codebook_file, 'tree');
   tree = tree.tree;
   
   if (start_i < 1), start_i = 1; end;
   if (end_i > length(imgs)), end_i = length(imgs); end;
   
   output_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.feat_dir, feat_name, method, codebook_size);
   
   if ~exist(output_dir, 'file'), mkdir(output_dir); end;
   
   fmt_str = '%f %f %f %f %f';
   for ii = 1:128,
      fmt_str = [fmt_str ' %d'];
   end
	
   parfor ii=start_i:end_i,
        img = imgs{ii};				
		output_file = sprintf('%s/%s.mat', output_dir, img(1:end-4));
		if exist(output_file, 'file'),
            fprintf('File [%s] already exist. Skipped!!\n', output_file);
            continue;
        end
		fprintf('Encoding for file %s ...\n', img);
        
		feat_file = sprintf('%s/%s.sift/%s.%s.sift', prms.feat_dir, feat_name, img(1:end-4), feat_name);
        if ~exist(feat_file, 'file'), continue; end;
        
		feats = load_feature(feat_file, fmt_str);    
		
		if isempty(feats), continue; end;
		
		% convert to uint8
		feats = uint8(feats); 
		
		codeids = vl_hikmeanspush(tree, feats);
        codeids = (codeids(1,:)-1).*100^2 + (codeids(2,:)-1).*100 + codeids(3,:);
		%codeids = (codeids(1,:)-1).*10^5 + (codeids(2,:)-1).*10^4 + (codeids(3,:)-1).*10^3 + (codeids(4,:)-1).*10^2 + (codeids(5,:)-1).*10 + codeids(6,:);
		
		code = vl_binsum(zeros(codebook_size, 1), 1, double(codeids));
		%code = single(code);		
		%l2 normlization
		%code = code / norm(code, 2);
		par_save(output_file, code); % MATLAB don't allow to save inside parfor loop
		
   end
   
end

function par_save( output_file, code )
  save( output_file, 'code');
end
