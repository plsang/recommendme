function reme_do_clustering_ikm(prms, feat_name, codebook_size)
%SELECT_FEATURES Summary of this function goes here
%   Detailed explanation goes here
	
	
	run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
	
	codebook_dir = prms.codebook_dir;
	
	output_file = sprintf('%s/codebook_ikm_%s_%d.mat', codebook_dir, feat_name, codebook_size);
	if exist(output_file, 'file'),
		fprintf('Codebook [%s] exist!\n', output_file);
		return;
	end
	
	selected_feats_file = sprintf('%s/selected_feats_%s.mat', codebook_dir, feat_name);
	load(selected_feats_file, 'all_feats');

	tic;
    fprintf('Converting data to uint8...\n');
    all_feats = uint8(all_feats);
    toc;
	
	fprintf('Randomly select 1M points...\n');
	randidx = randperm(size(all_feats, 2));
	all_feats = all_feats(:, randidx(1:200000));
	size(all_feats)
	
    tic;
    fprintf('Running i-kmeans [codebook_size = %d]...\n', codebook_size);
    [tree, A] = vl_ikmeans(all_feats, codebook_size, 'maxiters', 100, 'verbose', 'method', 'elkan') ;
    toc;
	
	save(output_file, 'tree');
end

