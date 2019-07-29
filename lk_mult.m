function [ dx,dy ] = lk_mult( I1, I2, rho, epsilon, d_x0, d_y0, option, N, scale )

I1_pyramid = pyramids(I1, rho, N, scale);
I2_pyramid = pyramids(I2, rho, N, scale);
% dx = d_x0 .* ones(size(I1,1),size(I1,2));
% dy = d_y0 .* ones(size(I1,1),size(I1,2));
  
%Multiscaled Lukas Kanade
for i=N:-1:1
    if (i==N)
        [temp_dx, temp_dy] = lk(I1_pyramid{i}, I2_pyramid{i}, rho, epsilon, d_x0, d_y0, option);
    else
        rows = size(I1_pyramid{i},1);
        columns = size(I1_pyramid{i},2);
        temp_dx = 2*imresize(temp_dx,[rows columns]);
        temp_dy = 2*imresize(temp_dy,[rows columns]);
        [temp_dx, temp_dy] = lk(I1_pyramid{i}, I2_pyramid{i}, rho, epsilon, temp_dx, temp_dy, option);
    end
end
dx = temp_dx;
dy = temp_dy;

end

