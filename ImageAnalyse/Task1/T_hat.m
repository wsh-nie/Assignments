function fig_t_hat =T_hat(fig,E)
%MY_T_HAT 此处显示有关此函数的摘要
%   此处显示详细说明
% 开运算
fig_e = My_erosion(fig,E);
fig_ed = My_dilation(fig_e,E);

% 减法
fig_t_hat = fig - fig_ed;

end


