function [ code ] = kcbencode( feats, codebook, kdtree )
%KCBENCODE Summary of this function goes here
%   Detailed explanation goes here

     norm_type = 'l2';
	 max_comps = 500; %default: 500;
     %max_comps = size(codebook, 2)/4;
     num_nn = 5;
     sigma = 45;
     kcb_type = 'unc';
            
     if max_comps ~= 1
        % using ann...
        code = featpipem.lib.KCBEncode(feats, codebook, num_nn, ...
            sigma, kdtree, max_comps, kcb_type, false);
    else
        % using exact assignment...
        code = featpipem.lib.KCBEncode(feats, codebook, num_nn, ...
            sigma, [], [], kcb_type, false);
    end
    
    % Normalize -----------------------------------------------------------
    
    if strcmp(norm_type, 'l1')
        code = code / norm(code,1);
    end
	
    if strcmp(norm_type, 'l2')
        code = code / norm(code,2);
    end
    
end

