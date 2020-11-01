function [fig_ed,fig_deed,fig_side] = Gradiant(fig)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
E1 = GetElementEnty(30);
fig_ed = Erosion(Dilation(fig,E1),E1);

E2 = GetElementEnty(60);
fig_deed = Dilation(Erosion(fig_ed,E2),E2);

[H,W] = size(fig);
fig_f = double(fig);

%% padding
fig_f = [fig_f(:,1:-1:1),fig_f,fig_f(:,W-1:W)];
fig_f = [fig_f(1:-1:1,:);fig_f;fig_f(H-1:H,:)];
fig_f = double(fig_f);

E3(1:3,1:3) = 1;
fig_e = zeros(H,W);
fig_d = zeros(H,W);
for i = 1:H
    for j = 1:W
        fig_sub = fig_f(i:i+2,j:j+2);
        C = fig_sub .* E3;
        fig_e(i,j) = min(C(:));
        fig_d(i,j) = max(C(:));
    end 
end
fig_side = uint8(fig_d - fig_e);
end

