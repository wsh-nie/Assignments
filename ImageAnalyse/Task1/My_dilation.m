function fig_d = My_dilation(fig,E)
%MY_DILATION ���ͺ�����ʹ�þ��
% fig �Ǵ����ֵ����E�ǽṹԪ��
fig_d = conv2(fig,E,"same");
fig_d = logical(fig_d);
end
