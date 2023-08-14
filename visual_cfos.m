warning off;
clear all;
clc;
close all;


tmp_file = 'Output_03_HOM.tif';

I0 = imread(tmp_file);

I0_R = I0(:,:, 1);  % 8-bit
I0_G = I0(:,:, 2);
I0_B = I0(:,:, 3);

h_fig = figure;
figure(1);
imshow(I0_G);

[I0_R_w,noise]=wiener2(I0_G,[30 30]);  % Filtering, to be set
figure(2);
imshow(I0_R_w)
I0_R_w_a = imadjust(I0_R_w,[0.25 1], [0.2 1]);  % Adjust contrast, to be set
figure(3);
imshow(I0_R_w_a)
I0_R_BW = im2bw(I0_R_w_a, 0.25);  % Gray to BW,  to be set
figure(4);
imshow(I0_R_BW)

I0_R_BW_m = medfilt2(I0_R_BW,[5,5]);  % Medium Filter, get rid of pepper noise
figure(5);
imshow(I0_R_BW_m)

% Count the connected area
L = bwlabeln(I0_R_BW_m, 8);
S = regionprops(L, 'Area');
pos = ([S.Area] <= 400) & ([S.Area] >= 15);  % To be set the area threshold
pos_ex = ~pos;
bw2 = ismember(L, find(pos));
bw2_ex = ismember(L, find(pos_ex));

% Plot normal and exceptions
%{
    figure(101);
    imshow(bw2);
    figure(102);
    imshow(bw2_ex);
%}

S1 = [S.Area];
S1 = S1(pos);  % Final Area and number of connected regions

N = length(S1);  % Number
disp('Cell Number:')
disp(N);

% Get the center of connected areas
C = regionprops(bw2, 'Centroid');  % to be processed
C1 = [C.Centroid];
C1 = reshape(C1, 2, length(C1)/2)';

% For exception
C_ex = regionprops(bw2_ex, 'Centroid');  % to be processed
C1_ex = [C_ex.Centroid];
C1_ex = reshape(C1_ex, 2, length(C1_ex)/2)';


% Mark the connected region on the orignal picture
figure(h_fig); hold on;
plot(C1(:,1), C1(:,2), 'r+', 'MarkerSize', 10);
plot(C1_ex(:,1), C1_ex(:,2), 'g+', 'MarkerSize', 10);
hold off;
title([tmp_file, '  Cell Number:', num2str(N)]);

