function bounding_box = ld(Io,mu,cov)

%Convert Input Image to YCbCr and keep only the Cb and Cr channels
Io_ycbcr = rgb2ycbcr(Io);
Io_cbcr = Io_ycbcr(:,:,2:3);
tmp = reshape(Io_cbcr,[size(Io_cbcr,1)*size(Io_cbcr,2) size(Io_cbcr,3)]);

%Construct the Gaussian normal propability density function
Prob = mvnpdf(tmp,mu,cov);
figure,plot(Prob);
title('Επιφάνεια Γκαουσιανής Κτανομής');
Prob_2D = reshape(Prob,[size(Io_cbcr,1), size(Io_cbcr,2)]);
figure,imshow(Prob_2D,[]);
title('Εικόνα Πιθανότητας Δέρματος');
%Get the binary image of the skin detection using a threshold
skin_thr = 0.08;
Binary_Skin_Img = (Prob_2D./max(Prob(:)) >= skin_thr);
figure,imshow(Binary_Skin_Img,[]);
title('Δυαδική Εικόνα Δέρματος πριν την επεξεργασία με Μορφολογικά Φίλτρα');

%Morphological filters 
Bs = strel('disk',1);
Bl = strel('disk',8);
Binary_Skin_Img_mod = imclose(imopen(Binary_Skin_Img,Bs),Bl);
figure, imshow(Binary_Skin_Img_mod,[]);
title('Δυαδική Εικόνα Δέρματος μετά την επεξεργασία με Μορφολογικά Φίλτρα');

%Choosing the face
bwl = bwlabel(Binary_Skin_Img_mod',4);
face = (bwl==1)';
figure, imshow(face,[]);
title('Δυαδική Απεικόνιση Μόνο του Προσώπου(μετά τη μορφολογική επεξεργασία)');
figure, imshow(Io,[]);
title('Tελική Ανίχνευση Προσώπου με το Bounding Box');
%Construct the bounding box and return his region
face_region = regionprops(face,'BoundingBox');
bounding_box = face_region.BoundingBox;
r = rectangle('Position',bounding_box);
r.EdgeColor = 'g';

end