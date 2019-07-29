clear all;
close all;

filename = 'ogh.gif';
fdest = 'pictures/';

d_x0 = 0;
d_y0 = 0;
Io = im2double(imread([fdest,'1.png']));
box = calculate_box(Io);
box.Visible='off';
p = box.Position;

figure(1), imshow(zeros(p(4),p(3)),[]);

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
% best so far thr = 0.001
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

[dx,dy] = lk_mult(In_1(y0:(h+y0),x0:(w+x0)), In(y0:(h+y0),x0:(w+x0)), 6.5, 0.0002, 0, 0, 4, 4, 0.3);
%size(In_1(y0:(h+y0),x0:(w+x0)))
thr = 3;

figure(1);
dE = sqrt(dx.^2 +dy.^2);
imshow(dE,[])
%title(['Frame ',int2str(i-1),'$\rightarrow$',int2str(i)],'interpreter','Latex');


drawnow
frame = getframe(1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append');

%figure(3), hist(dE(:));
%figure, imshow(dE,[]);
dx(dE < thr) = 0;
dy(dE < thr) = 0;

tdx = dx(:);
tdy = dy(:);

ix = (tdx~=0);
iy = (tdy~=0);


%1.8
if(sum(ix(:))==0)
    bdx = 0;
else
    bdx = mean(tdx(tdx~=0));
end

if(sum(iy(:))==0)
    bdy = 0;
else
    bdy = mean(tdy(tdy~=0));
end

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