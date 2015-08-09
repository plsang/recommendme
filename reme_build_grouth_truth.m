function gt = reme_build_grouth_truth(prms)
	 
	if exist(prms.gt_file, 'file'),
		fprintf('File [%s] already exist. Skipped!!\n', prms.gt_file);
		return;
    end
    
	
	
    imgs = textread(prms.img_list, '%s');
    
    
	gt = struct;
	   
	switch prms.dataset
		case 'mqa10k'
		case 'mqa100k'
			insts = dir([prms.inst_dir '/*']);
			
			for ii = 1:length(insts),
				
				subname = insts(ii).name;
				fprintf('[%d/%d] building for class name [%s]...\n', ii, length(insts), subname);
				
				if ~strcmp(subname, '.') & ~strcmp(subname, '..'),
				
					imgs_ = dir(sprintf('%s/%s/*.jpg', prms.inst_dir, subname));

					arr = {};
					id = [];
					
					for jj = 1:length(imgs_),
						arr{jj} = imgs_(jj).name;
						hits = cellfun(@(x)strcmp(x, imgs_(jj).name), imgs);
						id(jj) = find(hits > 0);
					end
					
					gt.(subname).list = arr;
					gt.(subname).id = id;					
				end				
			end   
		case 'oxford100k'
		
			insts = dir([prms.inst_dir '/*.jpg']);
			
			for ii = 1:length(insts),
        
				img_name = insts(ii).name;
				img_parts = strfind(img_name, '_');
				subname = img_name(1:img_parts(end)-1);
				if isfield(gt, subname),
					fprintf('[%d/%d] ... ', ii, length(insts));
					continue;
				end		
				fprintf('[%d/%d] building for class name [%s]...\n', ii, length(insts), subname);
				
						   
				imgs_ = dir([prms.inst_dir '/' subname '_*.jpg']);

				arr = {};
				id = [];
				
				for jj = 1:length(imgs_),
					arr{jj} = imgs_(jj).name;
					hits = cellfun(@(x)strcmp(x, imgs_(jj).name), imgs);
					id(jj) = find(hits > 0);
				end

				gt.(subname).list = arr;
				gt.(subname).id = id;
							
			end
		case 'reme1m'
			insts = dir([prms.inst_dir '/*']);
			
			parfor ii = 1:length(insts),
				
				subname = insts(ii).name;
				fprintf('[%d/%d] building for class name [%s]...\n', ii, length(insts), subname);
				
				if ~strcmp(subname, '.') & ~strcmp(subname, '..'),
				
					imgs_ = dir(sprintf('%s/%s/*.jpg', prms.inst_dir, subname));

					arr = {};
					id = [];
					
					for jj = 1:length(imgs_),
						arr{jj} = imgs_(jj).name;
						hits = cellfun(@(x)strcmp(x, imgs_(jj).name), imgs);
						id(jj) = find(hits > 0);
					end
					
					gt.(subname).list = arr;
					gt.(subname).id = id;					
				end				
			end   
		otherwise		
			error('unknown dataset');
	end	
	
	
    save(prms.gt_file, 'gt');
    
end