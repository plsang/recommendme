function reme_assemble_ind_1m(prms, feat_name, method, codebook_size)
	
	fprintf('Loading image list...\n');
	imgs = textread(prms.img_list, '%s');
	inds = [1:prms.chunk_size:length(imgs)];
	
	invs = cell(length(inds), 1);
	%invs = logical([]);
	
	chunk_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.invfiles_dir, feat_name, method, codebook_size);
	
	
	for ii=inds,
		fprintf('[%d/%d] Loading chunk...\n', ceil(ii/1000), length(inds));
		start_i = ii;
		end_i = ii + prms.chunk_size - 1;
		if (end_i > length(imgs)), end_i = length(imgs); end;
		
	    %output_file = ['/net/per900a/raid0/plsang/recommendme/inverted_files/bow_hkm_' num2str(start_i) '_' num2str(end_i) '.mat'];
		chunk_file = sprintf('%s/bow_hkm_%s.%s.%d_%d_%d.mat', chunk_dir, feat_name, method, codebook_size, start_i, end_i);
		
		indxs = load(chunk_file, 'indxs');
		indxs = indxs.indxs;

		%if ~isempty(invs),
		%	invs = [invs indxs'];
		%else
		%	invs = indxs';
		%end
		invs{ceil(ii/1000)} = indxs';
		whos('invs')
	end
	
	
	fprintf('Concatenating...\n');
	invs = cat(2, invs{:});
	%invs = logical(invs');
	
	fprintf('Saving...\n');
	output_file = sprintf('%s/bow_%s.%s.%d.mat', prms.invfiles_dir, feat_name, method, codebook_size);
	
	save(output_file, 'invs', '-v7.3');
	
end
