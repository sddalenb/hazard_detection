% This code implements the colour_hist.m method to determine dangerous
% driving behaviours in temporal profiles.
% Must have temporal profiling images to work correctly.
%
% Seth Dalenberg 2019-05-10

% read in image, assumed fps
full_img = imread('1157060613161600041_m2.png');
fps = 30;

% read in images & combine
img1 = imread('1157060613161600041_m1.png');
img2 = imread('1157060613161600041_m2.png');
img3 = imread('1157060613161600041_m3.png');

new_img = (img1 + img2 + img3);
imwrite(new_img, 'combined-img.png');

% call function, return times of hazard zones in sec
[m1_left,m1_mid,m1_right,m1_full] = colour_hist('1157060613161600041_m1.png',fps);
[m2_left,m2_mid,m2_right,m2_full] = colour_hist('1157060613161600041_m2.png',fps);
[m3_left,m3_mid,m3_right,m3_full] = colour_hist('1157060613161600041_m3.png',fps);
[comb_left,comb_mid,comb_right,comb_full] = colour_hist('combined-img.png',30);