function fig_get = My_getletter(fig_ed,E,fig)
%MY_GETLETTER 使用结构元素E对fig_ed进行膨胀，fig用于限制fig_ed的膨胀
%   此处显示详细说明
fig_get = min(fig_ed,fig);% 初始化为开启操作保留的长串结构

for i = 1:30 %迭代
    fig_get  = My_dilation(fig_get,E); % 膨胀操作
    fig_get = min(fig_get,fig);% 使用原图进行限制
end
end

