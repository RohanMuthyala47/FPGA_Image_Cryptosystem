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

% figure;
% imshow(img);
% title('Original Image');

data = uint8(img(:));

K = generateSHA256Hash(data); % K is the SHA-256 hash key

h_blocks = uint8(sscanf(K, '%2x').'); % h1, h2, h3, ..... h32

x0 = 0; y0 = 0; z0 = 8; w0 = 6; t0 = 0;

[X_Initial, Y_Initial, Z_Initial, W_Initial] = generateInitialConditions(h_blocks, x0, y0, z0, w0);

disp(K)

disp(h_blocks)

disp(X_Initial)
disp(Y_Initial)
disp(Z_Initial)
disp(W_Initial)

alpha = 35; gamma = 28; epsilon = 12; beta = 3; lambda = 0.5;
q = 0.95;

h = 0.01;
N = 20000;

[X_keys, Y_keys, Z_keys, W_keys, X_full, Y_full, Z_full, W_full] = ...
    Chen4D(X_Initial, Y_Initial, Z_Initial, W_Initial, alpha, gamma, epsilon, beta, lambda, h, N);

fprintf('\nGenerated %d encryption keys from each sequence\n', length(X_keys));

% Plot 3D projections
plotChen4D_3DProjections(X_full, Y_full, Z_full, W_full, 5000);

% Optional: Display some statistics
fprintf('\nSequence Statistics:\n');
fprintf('X range: [%.4f, %.4f]\n', min(X_full), max(X_full));
fprintf('Y range: [%.4f, %.4f]\n', min(Y_full), max(Y_full));
fprintf('Z range: [%.4f, %.4f]\n', min(Z_full), max(Z_full));
fprintf('W range: [%.4f, %.4f]\n', min(W_full), max(W_full));