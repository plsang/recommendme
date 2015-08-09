prms = reme_get_prms('oxford100k');
feat_name = 'heslap';
method = 'vq';
codebook_size = 1000000;
top_n = 500;
top_query = 1;

fprintf('Step 1: Extracting features for each regions...\n');
baseline_load_region_features(prms, feat_name, method, codebook_size, top_n, top_query);

fprintf('Step 2: Pairing and ranking...\n');
baseline_save_ranklist(prms, feat_name, method, codebook_size, top_n, top_query);

prms = reme_get_prms('reme1m');
feat_name = 'heslap';
method = 'vq';
codebook_size = 1000000;
top_n = 500;
top_query = 1;

fprintf('Step 1: Extracting features for each regions...\n');
baseline_load_region_features(prms, feat_name, method, codebook_size, top_n, top_query);