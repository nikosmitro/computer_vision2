function [ I_pyramid ] = pyramids( I, rho, N, scale )

ns = ceil(3*rho)*2 + 1;
Gr = fspecial('gaussian', [ns ns], rho);

%Generate the image pyramid
I_pyramid=cell(1,N);
for i=1:N
    if (i == 1)
        I_pyramid{i} = I;
    else
        pyr = imfilter(I_pyramid{i-1}, Gr, 'symmetric');
        I_pyramid{i} = imresize(pyr, scale);
    end
end



end

