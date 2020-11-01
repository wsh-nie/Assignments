function fig_fill = My_fillhole(fig,E)
%MY_FILLHOLE 此处显示有关此函数的摘要
%   此处显示详细说明
[H,W] = size(fig);
%% 获得边界
fig_fill = [fig(2:H-1,1),zeros(H-2,W-2),fig(2:H-1,W)];
fig_fill = [fig(1,:);fig_fill;fig(H,:)];

%% 迭代膨胀
for i = 1:500
    fig_fill = My_dilation(fig_fill,E);
    fig_fill = logical(min(fig_fill,fig));
end
fig_fill = logical(1-fig_fill);
end

