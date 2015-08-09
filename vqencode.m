function [ code ] = vqencode( feats, codebook, kdtree)
%VQENCODE Summary of this function goes here
%   Detailed explanation goes here
    
    % setup encoder
    norm_type = 'l2';
    max_comps = 1000; %default 25;
	%max_comps = size(codebook, 2)/4;
    %kdtree = vl_kdtreebuild(codebook);
            
    if max_comps ~= -1
        % using ann...
        codeids = vl_kdtreequery(kdtree, codebook, feats, ...
            'MaxComparisons', max_comps);
    else
        % using exact assignment...
        [~, codeids] = min(vl_alldist(codebook, feats), [], 1);
    end
    
    code = vl_binsum(zeros(size(codebook, 2), 1), 1, double(codeids));
    %code = single(code);
    
    % Normalize -----------------------------------------------------------
    
    if strcmp(norm_type, 'l1')
        code = code / norm(code, 1);
    end
    if strcmp(norm_type, 'l2')
        code = code / norm(code, 2);
    end 
end

