function fig_t_hat =T_hat(fig,E)
%MY_T_HAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ������
fig_e = My_erosion(fig,E);
fig_ed = My_dilation(fig_e,E);

% ����
fig_t_hat = fig - fig_ed;

end


