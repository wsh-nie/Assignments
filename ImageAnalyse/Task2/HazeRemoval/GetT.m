function t = GetT(img,t_hat)
%GETT 此处显示有关此函数的摘要
%   此处显示详细说明
lambda = 0.0001;
[M,N] = size(t_hat);
t = zeros(M,N);


% set bound t0 = 0.1
t = max(t(:,:),0.1);
end

