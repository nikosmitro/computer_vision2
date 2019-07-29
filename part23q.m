clear all;
close all;

filename = 'box_move_q.gif';
fdest = 'pictures/';


% d_x0 = 0.1;
% d_y0 = 0.2;
d_x0 = 0;
d_y0 = 0;
Io = im2double(imread([fdest,'1.png']));
box = calculate_box(Io);
box.Visible='off';
p = box.Position;

% figure(1), imshow(Io,[]);
% box = rectangle('Position',p);
% box.EdgeColor = 'm';
% title('Frame 1','interpreter','Latex');

drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif', 'Loopcount',0);

x0 = p(1);
y0 = p(2);
w = p(3);
h = p(4);

% else
%          

Ion_1 = Io;

%rho = 7.5;

%stability
%thr 2.4
%rho 6.8

%result
%thr 2.6
%thr 7

rho = 6;
epsilon = 0.0002;
thr = 3;

%1.7
option = 4;
%1) Max Difference of Energies (Absolute)
%2) Difference of Max Energies (Absolute)
%3) Sum of absolute difference of energies.
%4) Max iterations


In_1 = rgb2gray(Ion_1);

for i=2:72

Ion = im2double(imread([fdest,int2str(i),'.png']));
    
In = rgb2gray(Ion);

q = size(In_1);
A = zeros(q(1),q(2));

%A(x0:(w+x0),y0:(h+y0))=1;

% [dx,dy] = lk(In_1(y0:(h+y0),x0:(w+x0)), In(y0:(h+y0),x0:(w+x0)), rho, epsilon, d_x0, d_y0, option);
[dx,dy] = lk_mult(In_1(y0:(h+y0),x0:(w+x0)), In(y0:(h+y0),x0:(w+x0)), 6.5, 0.0002, 0, 0, 4, 4, 0.3);

figure(1);
dx_r=imresize(dx,0.3);
dy_r=imresize(dy,0.3);
quiver(-dx_r,-dy_r);

title(['Frame ',int2str(i-1),'$\rightarrow$',int2str(i)],'interpreter','Latex');

drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append');

[bdx,bdy]=displ(dx,dy,thr);

% **
x0 = x0-bdx;
y0 = y0-bdy;
%figure(1), imshow(Ion,[]);
box = rectangle('Position',[x0, y0, w, h]);
box.Visible='off';
% box.EdgeColor = 'm';

%pause(0.1);
In_1 = In;
end
