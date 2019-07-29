clear all;

d_x0 = 0.1;
d_y0 = 0.2;
I1 = rgb2gray(im2double(imread('1.png')));
I2 = rgb2gray(im2double(imread('2.png')));
rho = 2;
epsilon = 0.03;


ns = ceil(3*rho)*2 + 1;
Gr = fspecial('gaussian', [ns ns], rho);

[x0,y0] = meshgrid(1:size(I1,2),1:size(I1,1));

% [r,c] = find(zeros(size(I1,2),size(I1,1))==0);
% x = [c,r];
dx = d_x0 .* ones(size(I1,1),size(I1,2));
dy = d_y0 .* ones(size(I1,1),size(I1,2));


%1)
%q = 0.5

%2)
q = 0.001;


%3)
% q = 10;
% 0.01* taxh megethous

%4)
% q = 10;

% idxr = sub2ind(size(I1),x(:,1),x(:,2));
[Igrad_x, Igrad_y] =  imgradientxy(I1);

Ii = interp2(I1,x0+dx,y0+dy,'linear',0);
E = I2 - Ii;
Q = q+1;


i=0;
while(Q > q)
    i = i+1;    
    
    A1 = interp2(Igrad_x,x0+dx,y0+dy,'linear',0);
    A2 = interp2(Igrad_y,x0+dx,y0+dy,'linear',0);
    
    u11 = imfilter(A1.^2,Gr,'symmetric')+epsilon;
    u12 = imfilter(A1.*A2,Gr,'symmetric');
    u22 = imfilter(A2.^2,Gr,'symmetric')+epsilon;
    up1 = imfilter(A1.*E,Gr,'symmetric');
    up2 = imfilter(A2.*E,Gr,'symmetric');
    
    ud = u11.*u22 - u12.^2; %determinant
    
    ux = (u22.*up1 - up2.*u12)./ud;
    uy = (up2.*u11 - u12.*up1)./ud;
    
    dx = dx+ux;
    dy = dy+uy;
    
    Ii = interp2(I1,x0+dx,y0+dy,'linear',0);
    Ep = E;
    E = I2 - Ii;
    
%%% Convergence criteria
    
%% 1)
%      tp = E-Ep;
%      Q = max(abs(tp(:)))

%     or

%% 2) 
     Q = abs(max(abs(E(:)))-max(abs(Ep(:))))

%% 3)
%     tp = abs(E.^2-Ep.^2);
%     or
%     tp = abs(abs(E) - abs(Ep));
%     Q = sum(tp(:))

%% 4)
%    q = i;
end
display(['Took ',num2str(i), ' rounds to converge']);

close all;
figure;
dx_r=imresize(dx,0.3);
dy_r=imresize(dy,0.3);
quiver(-dx_r,-dy_r)
