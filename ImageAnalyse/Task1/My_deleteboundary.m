function fig_bd = My_deleteboundary(fig,E)
%MY_DELETEBOUNDARY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

[H,W] = size(fig);
%% ��ñ߽�
fig_bd = [fig(2:H-1,1),zeros(H-2,W-2),fig(2:H-1,W)];
fig_bd = [fig(1,:);fig_bd;fig(H,:)];

%% ��������
for i = 1:30
    fig_bd = My_dilation(fig_bd,E);
    fig_bd = logical(min(fig_bd,fig));
end
fig_bd = logical(fig-fig_bd);
end

