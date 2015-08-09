function reme_encode_hkm_save(prms, feat_name, method, codebook_size, start_img, end_img)

	% by default, using codebook 10k
	if ~exist('codebook_size', 'var'),
		codebook_size = 10000;
	end
	
   %setup vl_feat
   run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
	

   img_list = sprintf('%s/all_return_images_rd.lst', prms.output_lists_dir);  
   
   fprintf('Loading image list...\n');
   img_list
   imgs = textread(img_list, '%s');
   
   codebook_file = sprintf('%s/codebook_hkm_%s_%d.mat', prms.codebook_dir, feat_name, codebook_size);
   fprintf('Loading codebook...\n');
   tree = load(codebook_file, 'tree');
   tree = tree.tree;
     
	if ~exist('start_img', 'var'),
		start_img = 1;
	end   
	
	if ~exist('end_img', 'var') || end_img > length(imgs),
		end_img = length(imgs);
	end   
	
   fmt_str = '%f %f %f %f %f';
   for ii = 1:128,
      fmt_str = [fmt_str ' %d'];
   end
	
   parfor ii=start_img:end_img,
        img = imgs{ii};				
		
		img_file = sprintf('%s/%s.jpg', prms.img_dir, img);
		if ~exist(img_file, 'file')
			img_file = sprintf('%s/%s.jpg', prms.query_dir, img);
			if ~exist(img_file, 'file'),
				error('File [%s] not found!\n', img_file)
			end
		end
		
		im = imread(img_file);
		
		xyc_file = sprintf('%s/%s.xyc',  prms.output_features_dir, img);
		shist_file = sprintf('%s/%s.shist',  prms.output_features_dir, img);
		
		if exist(xyc_file, 'file') && exist(shist_file, 'file'),
            fprintf('File [%s] and [%s] already exist. Skipped!!\n', xyc_file, shist_file);
            continue;
        end
		
		fprintf('Saving feature for image [%s] ...\n', img);
        
		feat_file = sprintf('%s/%s.sift/%s.%s.sift', prms.feat_dir, feat_name, img, feat_name);
        if ~exist(feat_file, 'file'),
				feat_file = tempname;
				cmd = sprintf('/net/per900a/raid0/plsang/tools/featurespace/compute_descriptors_64bit.ln -%s -sift -i %s -o1 %s', feat_name, img_file, feat_file);
				system(cmd);
		end;
        
		[feats, frames] = load_feature(feat_file, fmt_str);    
		
		%if isempty(feats), continue; end;
		
		% convert to uint8
		feats = uint8(feats); 
		
		if codebook_size == 10000, % used ikm 
			codeids = vl_ikmeanspush(feats, tree);
		else % 100k, 1M, used hikm
			codeids = vl_hikmeanspush(tree, feats);
			codeids = (codeids(1,:)-1).*100^2 + (codeids(2,:)-1).*100 + codeids(3,:);
		end
		
		
		hist = vl_binsum(zeros(codebook_size, 1), 1, double(codeids));		
		
		save_xyc(xyc_file, im, codeids, frames);		
		save_shist(shist_file, codebook_size, hist);
		
   end

end

function save_xyc(xyc_file, im, codeids, frames)
	fxyc = fopen(xyc_file, 'w');
	fwrite(fxyc,size(im,2),'uint16');   %width
    fwrite(fxyc,size(im,1),'uint16');   %height
    fwrite(fxyc,floor(frames(1,:)),'uint16'); % write x-position
    fwrite(fxyc,floor(frames(2,:)),'uint16'); % write y-position
    fwrite(fxyc,codeids(:),'uint32'); % write cluster-id
    fclose(fxyc);
end

function save_hist(hist_file, hist)
	fh = fopen(hist_file, 'w');
	fprintf(fh, '%d ', hist);
	fclose(fh);
end

function save_shist_text(shist_file, codebook_size, hist)
	fshist = fopen(shist_file, 'w');
	%fprintf(fh, '%d ', hist);
	fprintf(fshist, '%d ', codebook_size);
	non_zero_idx = find(hist ~= 0);
	non_zero_val = hist(non_zero_idx);
	fprintf(fshist, '%d ', length(non_zero_idx));
	fprintf(fshist, '%d ', non_zero_idx(:));
	fprintf(fshist, '%d ', non_zero_val(:));
	fclose(fshist);
end

function save_shist(shist_file, codebook_size, hist)
	fshist = fopen(shist_file, 'w');
	%fprintf(fh, '%d ', hist);
	fwrite(fshist, codebook_size, 'uint32');
	non_zero_idx = find(hist ~= 0);
	non_zero_val = hist(non_zero_idx);
	fwrite(fshist, length(non_zero_idx), 'uint32');
	fwrite(fshist, non_zero_idx(:), 'uint32');
	fwrite(fshist, non_zero_val(:), 'uint16');
	fclose(fshist);
end
