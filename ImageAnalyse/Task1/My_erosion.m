function my_e = My_erosion(fig,E)
%MY_ELAPTION ��ʴ����
%   fig�Ƕ�ֵ����E�ǽṹԪ��

%% ���ͼ��ߴ�
[H,W] = size(fig); %918 * 2018
%fig_f = double(fig);

%% ��ýṹԪ�صĳߴ�
[h,w] = size(E);

%% ͼ��padding
fig = [zeros(H,w),fig,zeros(H,w)];
fig = [zeros(h,W+2*w);fig;zeros(h,W+2*w)];
%% ͼ��ʴ
my_e = zeros(H,W);
for i = 1:H
    for j = 1:W
        fig_sub = fig(i+h:i+2*h-1,j+w:j+2*w-1);
        C = fig_sub .* E + (1-E);
        my_e(i,j) = min(C(:));
    end
end

