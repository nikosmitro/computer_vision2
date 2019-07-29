function r = calculate_box(Io)

s = open('skinSamplesRGB.mat');
a = im2double(s.skinSamplesRGB);
sample = rgb2ycbcr(a);
skin_ycbcr = reshape(sample,[size(sample,1)*size(sample,2) size(sample,3)]);
cbcr_s = skin_ycbcr(:,2:3);
cbcr_cov = cov(cbcr_s);
cbcr_mean = mean(cbcr_s);

%get Image
%-> ycbcr
Io_ycbcr = rgb2ycbcr(Io);
Io_cbcr = Io_ycbcr(:,:,2:3);
tmp = reshape(Io_cbcr,[size(Io_cbcr,1)*size(Io_cbcr,2) size(Io_cbcr,3)]);
Prob = mvnpdf(tmp,cbcr_mean,cbcr_cov);
Prob_2D = reshape(Prob,[size(Io_cbcr,1), size(Io_cbcr,2)]);
skin_thr = 0.08;
Binary_Skin_Img = (Prob_2D./max(Prob(:)) >= skin_thr);


Bs = strel('disk',1);
Bl = strel('disk',8);
Binary_Skin_Img_mod = imclose(imopen(Binary_Skin_Img,Bs),Bl);

bwl = bwlabel(Binary_Skin_Img_mod',4);

face = (bwl==1)';
face_region = regionprops(face,'BoundingBox');
fr = face_region.BoundingBox;
r = rectangle('Position',fr);
end