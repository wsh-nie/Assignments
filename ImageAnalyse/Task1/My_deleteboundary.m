function fig_bd = My_deleteboundary(fig,E)
%MY_DELETEBOUNDARY 此处显示有关此函数的摘要
%   此处显示详细说明

[H,W] = size(fig);
%% 获得边界
fig_bd = [fig(2:H-1,1),zeros(H-2,W-2),fig(2:H-1,W)];
fig_bd = [fig(1,:);fig_bd;fig(H,:)];

%% 迭代膨胀
for i = 1:30
    fig_bd = My_dilation(fig_bd,E);
    fig_bd = logical(min(fig_bd,fig));
end
fig_bd = logical(fig-fig_bd);
end

