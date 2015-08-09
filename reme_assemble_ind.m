function reme_assemble_ind(prms, feat_name, method, codebook_size)
	
	imgs = textread(prms.img_list, '%s');
	inds = [1:prms.chunk_size:length(imgs)];
	
	invs = [];
	
	chunk_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.invfiles_dir, feat_name, method, codebook_size);
	
	for ii=inds,
		fprintf('[%d/%d] Loading chunk...\n', ceil(ii/prms.chunk_size), length(inds));
		start_i = ii;
		end_i = ii + prms.chunk_size - 1;
		if (end_i > length(imgs)), end_i = length(imgs); end;
		
	    %output_file = ['/net/per900a/raid0/plsang/recommendme/inverted_files/bow_hkm_' num2str(start_i) '_' num2str(end_i) '.mat'];
		chunk_file = sprintf('%s/bow_hkm_%s.%s.%d_%d_%d.mat', chunk_dir, feat_name, method, codebook_size, start_i, end_i);
		
		load(chunk_file, 'indxs');

		if ~isempty(invs),
			invs = [invs; indxs];
		else
			invs = indxs;
		end

		size(invs)
	end
	
	fprintf('Transpose & Convert to logical matrix...\n');
	invs = logical(invs');
	
	output_file = sprintf('%s/bow_%s.%s.%d.mat', prms.invfiles_dir, feat_name, method, codebook_size);
	
	save(output_file, 'invs', '-v7.3');
	
end
