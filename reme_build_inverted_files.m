function reme_build_inverted_files(prms, feat_name, method, codebook_size, sidx, eidx)
	imgs = textread(prms.img_list, '%s');
	inds = [1:prms.chunk_size:length(imgs)];
	
	if ~exist('sidx', 'var'),
		sidx = 1;
	end
	
	if ~exist('eidx', 'var'),
		eidx = length(inds);
	end
	
	parfor ii=sidx:eidx,
		fprintf('[%d/%d] Building chunk...\n', ii - sidx + 1, eidx - sidx + 1);
		start_i = inds(ii);
		end_i = inds(ii) + prms.chunk_size - 1;
		if (end_i > length(imgs)), end_i = length(imgs); end;
	    build_inverted_files_chunk(prms, feat_name, method, codebook_size, start_i, end_i);
	end
	
	%reme_assemble_ind(prms, feat_name, method, codebook_size);
end

function build_inverted_files_chunk(prms, feat_name, method, codebook_size, start_i, end_i)
    imgs = textread(prms.img_list, '%s');
	if (start_i < 1), start_i = 1; end;
    if (end_i > length(imgs)), end_i = length(imgs); end;
	
	%codebook_size = 1000000;
    feat_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.feat_dir, feat_name, method, codebook_size);
	
	output_dir = sprintf('%s/bow_hkm_%s.%s.%d', prms.invfiles_dir, feat_name, method, codebook_size);
	if ~exist(output_dir, 'file'),
		mkdir(output_dir);
	end
	
	output_file = sprintf('%s/bow_hkm_%s.%s.%d_%d_%d.mat', output_dir, feat_name, method, codebook_size, start_i, end_i);
	%output_file = ['/net/per900a/raid0/plsang/recommendme/inverted_files/bow_hkm_' num2str(start_i) '_' num2str(end_i) '.mat'];
	
	if exist(output_file, 'file'),
		fprintf('File [%s] already exist. Skipped!!\n', output_file);
		return;
	end
	
	indxs = zeros(end_i - start_i + 1, codebook_size);
	indxs = logical(indxs);
	
	for ii=start_i:end_i,
        img = imgs{ii};		
		%fprintf('[%d/%d] Loading feature %s.mat ...\n', ii - start_i + 1, end_i - start_i + 1, img(1:end-4));
		
        feat_file = [feat_dir '/' img(1:end-3) 'mat'] ;
        if ~exist(feat_file, 'file'),
			fprintf('---Warning: No feature file for image %s\n', img);
			code = logical(zeros(1, codebook_size));
		else
			code_ = load(feat_file, 'code');	
			if (any(isnan(code_.code))),
				fprintf('---Warning: NAN code detected for image %s\n', img);
				code = logical(zeros(1, codebook_size));
			else			
				code = logical(code_.code);
			end
		end
		indxs(ii - start_i + 1, :) = code;						
    end
	fprintf('\n');    
	
	%fprintf('Do transpose...\n');
	%tic;indxs = indxs';toc;
	
	fprintf('Convert to sparse matrix...\n');
	tic;
	indxs = sparse(indxs);
	toc;
	
	fprintf('Saving files...\n');
	save( output_file, 'indxs', '-v7.3');
	clear indxs;
end