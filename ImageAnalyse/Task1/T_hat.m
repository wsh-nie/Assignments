function [fig_ed,fig_t_hat] =T_hat(fig,E)
%MY_T_HAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ������
fig_e = imerode(fig,E);
fig_ed = imdilate(fig_e,E);

% ����
fig_t_hat = fig - fig_ed;

end