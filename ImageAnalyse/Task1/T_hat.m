function [fig_ed,fig_t_hat] =T_hat(fig,E)
%MY_T_HAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ������
fig_e = Erosion(fig,E);
fig_ed = Dilation(fig_e,E);

% ����
fig_t_hat = fig - fig_ed;

end