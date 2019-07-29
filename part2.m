clear all;

d_x0 = 0;
d_y0 = 0;
I1 = rgb2gray(im2double(imread('1.png')));
I2 = rgb2gray(im2double(imread('2.png')));
rho = 2;
epsilon = 0.03;


q = 10;
option = 2;
%1) Max Difference of Energies (Absolute)
%2) Difference of Max Energies (Absolute)
%3) Sum of absolute difference of energies.
%4) Max iterations

%One scale Lukas Kanade
[dx,dy] = lk(I1, I2, rho, epsilon, d_x0, d_y0, option);
close all;
figure;
dx_r=imresize(dx,0.3);
dy_r=imresize(dy,0.3);
quiver(-dx_r,-dy_r);


%Multiscale Lukas Kanade
N=5;
scale=0.5;
[dx,dy] = lk_mult(I1, I2, rho, epsilon, d_x0, d_y0, option, N, scale );
close all;
figure;
dx_r=imresize(dx,0.3);
dy_r=imresize(dy,0.3);
quiver(-dx_r,-dy_r);
