clear all;
close all;

%position of pictures
fdest = 'pictures/';

Io = im2double(imread([fdest,'1.png']));
box = calculate_box(Io);
p = box.Position;
figure(1), imshow(Io,[]);
%plot image with rect
box = rectangle('Position',p);
box.EdgeColor = 'm';
title('Frame 1','interpreter','Latex');

pause(0.01);

x0 = p(1);
y0 = p(2);
w = p(3);
h = p(4);

% else
%          

Ion_1 = Io;


% single scale bests
% d_x0 = 0;
% d_y0 = 0;
% rho = 6;
% epsilon = 0.0002;
% thr = 3;


option = 4;
%1) Max Difference of Energies (Absolute)
%2) Difference of Max Energies (Absolute)
%3) Sum of absolute difference of energies.
%4) Max iterations

%multiscale bests
rho = 6.5;
epsilon = 0.0002;
d_x0 = 0;
d_y0 = 0;
option = 4;
N = 4;
sigma = 0.3;

thr = 3;

In_1 = rgb2gray(Ion_1);

for i=2:72

Ion = im2double(imread([fdest,int2str(i),'.png']));
    
In = rgb2gray(Ion);


%single scale
%[dx,dy] = lk(In_1(y0:(h+y0),x0:(w+x0)), In(y0:(h+y0),x0:(w+x0)), rho, epsilon, d_x0, d_y0, option);

%multiscale
[dx,dy] = lk_mult(In_1(y0:(h+y0),x0:(w+x0)), In(y0:(h+y0),x0:(w+x0)), rho, epsilon, d_x0, d_y0, option, N, sigma);

%calculate mean moving distance for bounding box
[bdx,bdy]=displ(dx,dy,thr);

%transpose
x0 = x0-bdx;
y0 = y0-bdy;

%plot on top
figure(1), imshow(Ion,[]);
box = rectangle('Position',[x0, y0, w, h]);
box.EdgeColor = 'm';
figure(1), title(['Frame ',int2str(i)],'interpreter','Latex');

In_1 = In;
pause(0.01)
end
figure(1), imshow(Ion,[]);
box = rectangle('Position',[x0, y0, w, h]);
box.EdgeColor = 'm';
figure(1), title('Multiscale LK: $N=4, \sigma = 0.3, \rho = 6.5, N_{iter}=24, \epsilon=0.0002, Thr=3$','interpreter','Latex');
