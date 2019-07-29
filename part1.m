clear all;
close all;

%Get the skinSamplesRGB 
s = open('skinSamplesRGB.mat');
a = im2double(s.skinSamplesRGB);
%Convert them to YCbCr and keep only the Cb and Cr channels that describe
%the indetity of the colour
sample = rgb2ycbcr(a);
skin_ycbcr = reshape(sample,[size(sample,1)*size(sample,2) size(sample,3)]);
cbcr_s = skin_ycbcr(:,2:3);
%Take the covariance and mean of the skin samples
cbcr_cov = cov(cbcr_s);
cbcr_mean = mean(cbcr_s);

%Get the Image (first frame of the video)
Io = im2double(imread('1.png'));
figure;
imshow(Io,[]);
title('Αρχική Εικόνα (Πρώτο frame)');

%Call the function to create the bounding box
bounding_box=ld(Io,cbcr_mean,cbcr_cov);




