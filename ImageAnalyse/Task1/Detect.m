function [fig_5,fig_10,fig_20,fig_25,fig_30,y] = Detect(fig)
%DETECT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
E = GetElementEnty(5);
fig_5 = Dilation(Erosion(fig,E),E);
fig_5 = Erosion(Dilation(fig_5,E),E);

y = zeros(1,35);
temp = fig_5;
for i = 6:35
    E = GetElementEnty(i);
    fig_s = Dilation(Erosion(fig_5,E),E);
    C = temp - fig_s;
    y(i) = sum(C(:));
    temp = fig_s;
    if(i == 10)
        fig_10 = fig_s;
    elseif(i == 20)
        fig_20 = fig_s;
    elseif(i == 25)
        fig_25 = fig_s;
    elseif(i == 30)
        fig_30 = fig_s;
    end
end
end

