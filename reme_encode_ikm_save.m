function reme_encode_ikm_save(prms, feat_name, method, codebook_size)

   %setup vl_feat
   run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
	
	switch (codebook_size)
		case 10000
			sub_lists = 'bow.10k';
		case 100000
			sub_lists = 'bow.100k';
		case 1000000
			sub_lists = 'bow.1m';
		otherwise
			error('unknown codebook size!!');
	end

	output_dir = sprintf('%s/%s/features', prms.output_list_dir, sub_lists);	
	
   img_list = sprintf('%s/%s/lists/all_return_images_rd.lst', prms.output_list_dir, sub_lists);  
   
   fprintf('Loading image list...\n');
   img_list
   imgs = textread(img_list, '%s');
   
   codebook_file = sprintf('%s/codebook_ikm_%s_%d.mat', prms.codebook_dir, feat_name, codebook_size);
   fprintf('Loading codebook...\n');
   tree = load(codebook_file, 'tree');
   tree = tree.tree;
     
	
   output_dir = sprintf('%s/%s/features', prms.output_list_dir, sub_lists);
   
   if ~exist(output_dir, 'file'), mkdir(output_dir); end;
   
   fmt_str = '%f %f %f %f %f';
   for ii = 1:128,
      fmt_str = [fmt_str ' %d'];
   end
	
   parfor ii=1:length(imgs),
        img = imgs{ii};				
		
		img_file = sprintf('%s/%s.jpg', prms.img_dir, img);
		im = imread(img_file);
		
		xyc_file = sprintf('%s/%s.xyc', output_dir, img);
		shist_file = sprintf('%s/%s.shist', output_dir, img);
		
		if exist(xyc_file, 'file') && exist(shist_file, 'file'),
            fprintf('File [%s] and [%s] already exist. Skipped!!\n', xyc_file, shist_file);
            continue;
        end
		
		fprintf('Saving feature for image [%s] ...\n', img);
        
		feat_file = sprintf('%s/%s.sift/%s.%s.sift', prms.feat_dir, feat_name, img, feat_name);
        %if ~exist(feat_file, 'file'), continue; end;
        
		[feats, frames] = load_feature(feat_file, fmt_str);    
		
		%if isempty(feats), continue; end;
		
		% convert to uint8
		feats = uint8(feats); 
		
		codeids = vl_ikmeanspush(feats, tree);
		
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
