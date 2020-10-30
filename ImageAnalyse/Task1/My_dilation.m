function my_imd = My_dilation(fig,E)
%MY_DILATION 膨胀函数，使用卷积
% fig 是传入二值矩阵，E是结构元素
my_imd = conv2(fig,E,"same");
my_imd = logical(my_imd);
end