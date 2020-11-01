function fig_d = My_dilation(fig,E)
%MY_DILATION 膨胀函数，使用卷积
% fig 是传入二值矩阵，E是结构元素
fig_d = conv2(fig,E,"same");
fig_d = logical(fig_d);
end