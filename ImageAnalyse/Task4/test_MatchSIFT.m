
%% Set path and parameters
clear;
close all;
clc;

%  src_1 = './test images/37967br1.jpg';  
%  src_2 = './test images/791.jpg';

% src_1 = './test images/4.jpg';  
% src_2 = './test images/Apollo-266.jpg';

% src_1 = './test images/771.jpg';  
% src_2 = './test images/305.jpg';

 src_1 = './test images/Apollo-49.jpg';
 src_2 = './test images/Apollo-266.jpg';


ext = '.sift'; % extension name of SIFT file
siftDim = 128;
maxAxis = 400;


%%  Load image
im_1 = imread(src_1);
if max(size(im_1)) > maxAxis
    im_1 = imresize(im_1, maxAxis / max(size(im_1)));
end

im_2 = imread(src_2);
if max(size(im_2)) > maxAxis
    im_2 = imresize(im_2, maxAxis / max(size(im_2)));
end


%%  Load SIFT feature from file
featPath_1 = [src_1, ext];% src_1.sift
featPath_2 = [src_2, ext];% src_2.sift

fid_1 = fopen(featPath_1, 'rb');
featNum_1 = fread(fid_1, 1, 'int32');                       % src_1�� SIFT������Ŀ
SiftFeat_1 = zeros(siftDim, featNum_1);
paraFeat_1 = zeros(4, featNum_1);
for i = 1 : featNum_1                                       % �����ȡSIFT����
    SiftFeat_1(:, i) = fread(fid_1, siftDim, 'uchar');      %�ȶ���128ά������
    paraFeat_1(:, i) = fread(fid_1, 4, 'float32');          %�ٶ���[x, y, scale, orientation]��Ϣ
end
fclose(fid_1);

fid_2 = fopen(featPath_2, 'rb');
featNum_2 = fread(fid_2, 1, 'int32');                       % src_2�� SIFT������Ŀ
SiftFeat_2 = zeros(siftDim, featNum_2);
paraFeat_2 = zeros(4, featNum_2);
for i = 1 : featNum_2                                       % �����ȡSIFT����
    SiftFeat_2(:, i) = fread(fid_2, siftDim, 'uchar');      %�ȶ���128ά������
    paraFeat_2(:, i) = fread(fid_2, 4, 'float32');          %�ٶ���[x, y, scale, orientation]��Ϣ
end
fclose(fid_1);


%% Normalization
SiftFeat_1 = SiftFeat_1 ./ repmat(sqrt(sum(SiftFeat_1.^2)), size(SiftFeat_1, 1), 1);
SiftFeat_2 = SiftFeat_2 ./ repmat(sqrt(sum(SiftFeat_2.^2)), size(SiftFeat_2, 1), 1);


%% Check match based on distances between SIFT descriptors across images
normVal = mean(sqrt(sum(SiftFeat_1.^2)));
matchInd = zeros(featNum_1, 1);
matchDis = zeros(featNum_1, 1);
validDis = [];
gridDisVec = [];
ic = 0;
for i = 1 : featNum_1                                       %��src_1��sift����Ϊ׼������ƥ��
    tmpFeat = repmat(SiftFeat_1(:, i), 1, featNum_2);       %repmat(A,m,n) ������A����m*n�飬����ͬsrc_2sift��������ƥ��
    d = sqrt(sum((tmpFeat - SiftFeat_2).^2)) / normVal;     % L2 distance
    matchDis(i) = min(d);                                   % ͼ1��i��������ͬͼ2���������ӵ���̾���
    [v, ind] = sort(d);                                     % [B,I]=sort(A) I �Ĵ�С�� A �Ĵ�С��ͬ���������� A ��Ԫ�����������ά���� B �е����������A==A(I)
    if v(1) < 0.4                                           % ��С����С��0.4������Ϊ����һ��ƥ��
        matchInd(i) = ind(1);                               % ����ǰ������
        ic = ic + 1;                                        % ƥ������++
        validDis(ic, 1 : 3) = [v(1), v(2), v(1) / v(2)];    % ��̾��룬�ζ̾��룬���߱�ֵ
        tmp = (SiftFeat_1(:, i) - SiftFeat_2(:, ind(1))).^2;% ����ƽ��
        tmp2 = reshape(tmp(:), 8, 16);
        gridDisVec(ic, 1 : 16) = sqrt(sum(tmp2));           % L2����
    end
end
figure; stem(matchDis); ylim([0, 1.2]);                     % ͼ1��i��������ͬͼ2���������ӵ���̾���
figure; stem(matchDis(matchInd > 0)); ylim([0, 1.2]);       % ƥ��ɹ�

%% ʵ��spatial coding����������ƥ��У��׼��
Map1 = [];
Map2 = [];
m = 1;
for i = 1 : featNum_1           % ����src_1��sift����Ϊ׼
    if matchInd(i) > 0          % ƥ��ɹ���sift��������ϸ��Ϣ[x, y, scale, orientation]
        Map1 = [Map1, paraFeat_1(1:2, i)];
        Map2 = [Map2, paraFeat_2(1:2, matchInd(i))];
    end
end

r = 4;    
Xq(ic, ic, r) = 0;
Xm(ic, ic, r) = 0;
Yq(ic, ic, r) = 0;
Ym(ic, ic, r) = 0;

for k = 1:r
    %����ֽ�Ϊr����������������תk����λ�����꼯
    theta = (k-1)*pi/(2*r);         %ÿ��45��
    V1(1:2, 1:ic, k) = [cos(theta), -sin(theta); sin(theta), cos(theta)]*Map1;
    V2(1:2, 1:ic, k) = [cos(theta), -sin(theta); sin(theta), cos(theta)]*Map2;
    %��ȡ�ռ����01����
    for i = 1:ic
        for j = 1:ic
            if V1(1, i, k) >= V1(1, j, k) 
                Xq(j, i, k) = 1;
            end
            if V1(2, i, k) >= V1(2, j, k) 
                Xm(i, j, k) = 1;
            end
            if V2(1, i, k) >= V2(1, j, k) 
                Yq(j, i, k) = 1;
            end
            if V2(2, i, k) >= V2(2, j, k) 
                Ym(i, j, k) = 1;
            end
        end
    end
end
Vx = xor(Xq, Yq);
Vy = xor(Xm, Ym);

%% Show the local matching results on RGB image
[row, col, cn] = size(im_1);
[r2, c2, n2] = size(im_2);
imgBig = 255 * ones(max(row, r2), col + c2, 3);
imgBig(1 : row, 1 : col, :) = im_1;
imgBig(1 : r2, col + 1 : end, :) = im_2;
np = 40;
thr = linspace(0,2*pi,np) ;
Xp = cos(thr);
Yp = sin(thr);
paraFeat_2(1, :) = paraFeat_2(1, :) + col;
figure(3); imshow(uint8(imgBig)); axis on;
hold on;
matchCount = 0;
for i = 1 : featNum_1
    if matchInd(i) > 0
        matchCount = matchCount + 1;
        xys = paraFeat_1(:, i);
        xys2 = paraFeat_2(:, matchInd(i));
        figure(3);
        hold on;
        % plot(xys(1) + Xp * xys(3) * 6, xys(2) + Yp * xys(3) * 6, 'r');
        % plot(xys2(1) + Xp * xys2(3) * 6, xys2(2) + Yp * xys2(3) * 6, 'r');
        hold on; plot([xys(1), xys2(1)], [xys(2), xys2(2)], '-b', 'LineWidth', 0.8);

%         figure(4);
%         clf;
%         subplot(311); stem(SiftFeat_1(:, i)); xlim([0, 128]); ylim([0, 0.5]);
%         title(sprintf('Feature pair %d', matchCount));
%         subplot(312); stem(SiftFeat_2(:, matchInd(i))); xlim([0, 128]); ylim([0, 0.5]);
%         tmp = SiftFeat_1(:, i) - SiftFeat_2(:, matchInd(i));
%         subplot(313); stem(tmp); xlim([0, 128]);
%         title('Difference between the above two features per dimension');
%         disVal = sum(sqrt(tmp.^2));
%         ylim([0, 0.2]);
    end
end

%% ����ƥ��У��
Map2(1, :) = Map2(1, :) + col;          %Ϊ��������ͼ���沢�ţ�ʹ�Ҳ�ͼx��������col����λ
threshold = floor(ic*0.8);              %���ý���
for i = 1:ic
    Sx = sum(sum(Vx, 2), 3);            %�������Ԫ����ͣ��ٶ�k���������Ԫ�غ����ܺ�
    [Cx, Ix] = max(Sx(:, :), [], 1);    %�����k������������ֵ
    if Cx > threshold
        Vx(Ix, :, :) = 0;               %���ƥ���������mask
        Vx(:, Ix, :) = 0;
        Vy(Ix, :, :) = 0;               %���ƥ���������mask
        Vy(:, Ix, :) = 0;
        hold on;plot([Map1(1, Ix), Map2(1, Ix)], [Map1(2, Ix), Map2(2, Ix)], '-r', 'LineWidth', 0.8);    %��ƥ��������������
    end
    Sy = sum(sum(Vy, 2), 3);            %����Ը���Ԫ�����
    [Cy, Iy] = max(Sy(:, :), [], 1);
    if Cy > threshold
        Vx(Iy, :, :) = 0;               %���ƥ���������mask
        Vx(:, Iy, :) = 0;
        Vy(Iy, :, :) = 0;               %���ƥ���������mask
        Vy(:, Iy, :) = 0;
        
        
        hold on;plot([Map1(1, Iy), Map2(1, Iy)], [Map1(2, Iy), Map2(2, Iy)], '-r', 'LineWidth', 0.8);    %��ƥ��������������
    end
end

figure(3);
title(sprintf('Total local matches : %d (%d-%d)', length(find(matchInd)), featNum_1 ,featNum_2));
hold off;

