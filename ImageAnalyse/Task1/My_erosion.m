function my_e = My_erosion(fig,E)
%MY_ELAPTION ��ʴ����
%   fig�Ƕ�ֵ����E�ǽṹԪ��

%% ���ͼ��ߴ�
[H,W] = size(fig); %918 * 2018
%fig_f = double(fig);

%% ��ýṹԪ�صĳߴ�
[h,w] = size(E);

%% ͼ��ʴ
my_e = zeros(H,W);
for i = 1:H-h+1
    for j = 1:W
        fig_sub = fig(i:i+h-1,j:j+w-1);
        C = fig_sub .* E + (1-E);
        my_e(i,j) = min(C(:));
    end
end

