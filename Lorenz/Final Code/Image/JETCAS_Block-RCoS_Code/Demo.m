% This demo implements the stategy for Block based Compressed Sensing Recovery via Collaborative Sparsity (RCoS)
%
% x: Image Matrix
% A: Random matrix without normality and orthogonality (real)
% b: Observed measurements with/without noise (real)
%
% Version 2.0
% Author: Jian Zhang
% Email:  jzhangcs@hit.edu.cn
% Last modified by J. Zhang, April 2014

%   For updated versions of RCoS, 
%   Consult: http://idm.pku.edu.cn/staff/zhangjian/RCoS/


clear;
close all;
cur = cd;
addpath(genpath(cur));



for ImgNo = 2
    
    switch ImgNo
        case 1
            OrgName = 'House256.tif';
        case 2
            OrgName = 'Vessels96.tif';          
    end
    
    % Three are free parameters: theta, beta, lambda
    for ratio = 0.2
        for tt = 1  % Control random seed
            for theta = 2 % Set theta from {2,3}             	        ---- parameter 1
                for beta = 7 % Set beta from {5,6,7}            	    ---- parameter 2
                    for lambda = 12 % Set lambda from {4,8,12} 	        ---- parameter 3
                        
                        x = double(imread(OrgName));
                        
                        if size(x,3)==3
                            x = double(rgb2gray(uint8(x)));
                        end
                        
                        block_size = 32;
                        
                        [x_row,x_col] = size(x);
                        
                        % Problem Size
                        m = round(ratio*block_size*block_size);
                        
                        % Sensing Matrix
                        projection_matrix_file = ['projections.' num2str(block_size) '.' ...
                            num2str(ratio) '.mat'];
                        
                        A = BCS_SPL_GenerateProjection(block_size, ratio, projection_matrix_file);
                        
                        
                        % Observed Measurements
                        
                        % b = A*x(:);
                        x_hat = im2col(x, [block_size block_size], 'distinct');
                        y = A*x_hat;
                                               
                        b = y(:);
                        
                        % Add Gaussian Noise
                        noise_sigma = 0;
                        %b = b + noise_sigma*randn(m,1);
                        
                        
                        %% Run RCoS %%
                        clear opts
                        opts.mu = 2^8;
                        opts.beta = 2^beta;
                        opts.tol = 1E-3;
                        opts.maxit = 400;
                        opts.theta = theta;
                        opts.lambda = lambda;
                        opts.Org = x;
                        opts.block_size = block_size;
                        opts.ratio = ratio;
                        opts.row = x_row;
                        opts.col = x_col;
                        %                         opts.Init = X_MH;
                        
                        t = cputime;
                        [x_Rec, out] = RCoS(A,b,x_row,x_col,opts);
                        t = cputime - t;
                        
                        Final_Name = strcat(OrgName,'_ratio',num2str(ratio),'_theta',num2str(opts.theta),'_beta',num2str(opts.beta),'_lambda',num2str(opts.lambda),'_',num2str(csnr(x_Rec,x,0,0)),'dB.tif');
                        imwrite(uint8(x_Rec),strcat('Results\',Final_Name));
                        %% End %%
                    end
                end
            end
        end
    end
end