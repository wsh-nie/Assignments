function t = GetT(img,t_hat)
%GETT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
lambda = 0.0001;
[M,N] = size(t_hat);
t = zeros(M,N);


% set bound t0 = 0.1
t = max(t(:,:),0.1);
end

