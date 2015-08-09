
%reme_build_inverted_files(prms, 'heslap', 'vq', 100000);
%reme_assemble_ind(prms, 'heslap', 'vq', 100000);
%reme_build_inverted_files(prms, 'heslap', 'vq', 1000000);
%reme_assemble_ind(prms, 'heslap', 'vq', 1000000);



matlabpool open
prms = reme_get_prms('mqa100k');
%reme_build_inverted_files(prms, 'heslap', 'vq', 10000);
%reme_assemble_ind(prms, 'heslap', 'vq', 10000);
%reme_cal_mean_recall_save (prms, 'heslap', 'vq', 10000, 500, 52, 1);
%reme_encode_ikm_save(prms, 'heslap', 'vq', 10000);

prms = reme_get_prms('oxford100k');
%reme_build_inverted_files(prms, 'heslap', 'vq', 10000);
%reme_assemble_ind(prms, 'heslap', 'vq', 10000);
reme_cal_mean_recall_save (prms, 'heslap', 'vq', 10000, 500, 13, 1);
reme_encode_ikm_save(prms, 'heslap', 'vq', 10000);
matlabpool close
