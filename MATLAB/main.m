clc;
clear;
close all;

% Load the image
img = imread('resized_image.png');

% Convert to grayscale if it's RGB
if size(img, 3) == 3
    img = rgb2gray(img);
end

% Resize image to 256x256
img = imresize(img, [256 256]);

[H, W] = size(img);

% figure;
% imshow(img);
% title('Original Image');

data = uint8(img(:));

K = generateSHA256Hash(data); % K is the SHA-256 hash key

h_blocks = uint8(sscanf(K, '%2x').'); % h1, h2, h3, ..... h32

x0 = 0; y0 = 0; z0 = 8; w0 = 6;

alpha = 35; gamma = 28; epsilon = 12; beta = 3; lambda = 0.5;
q = 0.95;

h = 0.01;
N = 20000;

[X_Initial, Y_Initial, Z_Initial, W_Initial] = generateInitialConditions(h_blocks, x0, y0, z0, w0);

disp("K = ");
disp(K);

%disp(h_blocks)

% disp(X_Initial)
% disp(Y_Initial)
% disp(Z_Initial)
% disp(W_Initial)

[X_key, Y_key, Z_key, W_key, X_full, Y_full, Z_full, W_full] = ...
    Chen4D(X_Initial, Y_Initial, Z_Initial, W_Initial, alpha, gamma, epsilon, beta, lambda, h, N + (H*W));

fprintf('\nGenerated %d encryption keys from each sequence\n', length(X_key));

% Plot 3D projections
%plotChen4D_3DProjections(X_full, Y_full, Z_full, W_full, 5000);

Whitened_Image = Whiten_Image(X_key, img);

figure;
imshow(Whitened_Image);
title('Whitened Image');

R = FisherYates(Whitened_Image, Y_key);

figure;
imshow(R);
title('Randomized Image');
