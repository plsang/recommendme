function reme_do_clustering_hkm(prms, feat_name, codebook_size, K)
%SELECT_FEATURES Summary of this function goes here
%   Detailed explanation goes here
	
	% set branching factor
	if ~exist('K', 'var'),
		K = 100;
	end
	
	run('/net/per900a/raid0/plsang/tools/vlfeat-0.9.16/toolbox/vl_setup');
	%codebook_dir = '/net/sfv215/export/raid4/ledduy/plsang/oxford100k/codebook';
	
	codebook_dir = prms.codebook_dir;
	
	output_file = sprintf('%s/codebook_hkm_%s_%d_K%d.mat', codebook_dir, feat_name, codebook_size, K);
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
	
	%K = 100;   					% branching factor
    nleaves = codebook_size; 	% number of leaf nodes
   
    tic;
    fprintf('Running hikm [K = %d, nleaves = %d]...\n', K, nleaves);
    [tree, A] = vl_hikmeans(all_feats, K, nleaves, 'verbose', 'method', 'elkan') ;
    toc;
	
	save(output_file, 'tree');
end

