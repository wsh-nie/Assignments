function fig_d = My_dilation(fig,E)
%MY_DILATION 膨胀函数，使用卷积
% fig 是传入二值矩阵，E是结构元素
% 以B的结构元进行腐蚀
E = rot90(E,2);
%% 得到图像尺寸
[M,N] = size(fig);

%% 得到B的尺度
[m,n] = size(E);
m_2 = floor((m+1)/2);
n_2 = floor((n+1)/2);
%disp(m_2)
%disp(n_2)
%% 图像延拓
fig = [fig(:,n-1:-1:1),fig,fig(:,N:-1:N-n+2)];
fig = [fig(m-1:-1:1,:);fig;fig(M:-1:M-m+2,:)];
fig = double(fig);

%% 图像膨胀
fig_d = zeros(M,N,'uint8');
for i = 1:M
    for j = 1:N
        im_sub = fig(i+m_2-1:i+m_2+m-2,j+n_2-1:j+n_2+n-2);
        C = im_sub.*E;
        fig_d(i,j) = max(C(:));
    end
end
end