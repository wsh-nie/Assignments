function fig_fill = My_fillhole(fig,E)
%MY_FILLHOLE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[H,W] = size(fig);
%% ��ñ߽�
fig_fill = [fig(2:H-1,1),zeros(H-2,W-2),fig(2:H-1,W)];
fig_fill = [fig(1,:);fig_fill;fig(H,:)];

%% ��������
for i = 1:500
    fig_fill = My_dilation(fig_fill,E);
    fig_fill = logical(min(fig_fill,fig));
end
fig_fill = logical(1-fig_fill);
end

