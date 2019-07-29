function [bdx,bdy] = displ(dx,dy,thr)

%calculate euclidean distance
dE = sqrt(dx.^2 +dy.^2);

%thresholding based on a given value
dx(dE < thr) = 0;
dy(dE < thr) = 0;

tdx = dx(:);
tdy = dy(:);

ix = (tdx~=0);
iy = (tdy~=0);


%1.8
%calculate mean for everyone else
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

end