function fig_get = My_getletter(fig_ed,E,fig)
%MY_GETLETTER ʹ�ýṹԪ��E��fig_ed�������ͣ�fig��������fig_ed������
%   �˴���ʾ��ϸ˵��
fig_get = min(fig_ed,fig);% ��ʼ��Ϊ�������������ĳ����ṹ

for i = 1:30 %����
    fig_get  = My_dilation(fig_get,E); % ���Ͳ���
    fig_get = min(fig_get,fig);% ʹ��ԭͼ��������
end
end

