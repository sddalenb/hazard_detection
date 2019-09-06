function [left_loc, mid_loc, right_loc, full_loc] = colour_hist(img_name,fps)
% use colour profile to determine dangerous driving behaviours

% --- INPUT ---
% img_name          name of the temporal profile img pref .jpg or .png
% fps               capture rate of the image
%
% --- OUTPUT --- 
% left_loc          list of dangerous locations on left third analysis
% mid_loc          list of dangerous locations on middle third analysis
% right_loc          list of dangerous locations on right third analysis
% full_loc          list of dangerous locations full img analysis
%
% Seth Dalenberg 2019-05-10
%% import images
full_img = imread(img_name);
grey_img = rgb2gray(full_img);
width = size(grey_img,2); height = size(grey_img,1);
set(groot,'defaultAxesColorOrder',[1 0 0; 0 1 0; 0 0 1]);

%% divide image into thirds
div = round(width / 3);
first = grey_img(:,1:div);
second = grey_img(:,div:(div*2));
third = grey_img(:,(div*2):(div*3)-1);

% average pixels across each section then flip to make local minima the local maxima
col_sum_rgb = sum(full_img,[9024 2]);
col_sum_grey = round(sum(grey_img,2) ./ 1280);
    col_sum_grey = max(col_sum_grey(:)) - col_sum_grey;

% left
cols_1 = sum(first,2) ./ div; cols_1 = max(cols_1(:)) - cols_1;
% middle
cols_2 = sum(second,2) ./ div; cols_2 = max(cols_2(:)) - cols_2;
% right
cols_3 = sum(third,2) ./ div; cols_3 = max(cols_3(:)) - cols_3;

%% graph points for rgb
r = col_sum_rgb(:,:,1); g = col_sum_rgb(:,:,2); b = col_sum_rgb(:,:,3);
rgb = round([r g b] ./ 1280);

%% find min and plot
[pks, loc] = findpeaks(col_sum_grey,'MinPeakDistance',60,'MinPeakProminence',20);
[pks_1, loc_1] = findpeaks(cols_1,'MinPeakDistance',60,'MinPeakProminence',30);
[pks_2, loc_2] = findpeaks(cols_2,'MinPeakDistance',60,'MinPeakProminence',30);
[pks_3, loc_3] = findpeaks(cols_3,'MinPeakDistance',60,'MinPeakProminence',30);

marks_1 = ones(size(loc_1)) + (width/6);
marks_1 = [marks_1 loc_1];
marks_2 = ones(size(loc_2)) + (width/2);
marks_2 = [marks_2 loc_2];
marks_3 = ones(size(loc_3)) + (5*width/6);
marks_3 = [marks_3 loc_3];
marks_g = ones(size(loc)) + (width/2);
marks_g = [marks_g, loc];

%% plot graphs and display images
figure
plot(rgb); title(strcat('rgb img ',img_name));

% put marks on rgb image with various colours to show which area risk shows

% left
mark_img = insertMarker(full_img,marks_1,'x','size',5,'color','red');
% middle
mark_img = insertMarker(mark_img,marks_2,'x','size',5,'color','green');
% right
mark_img = insertMarker(mark_img,marks_3,'x','size',5,'color','blue');
% over entire image
mark_img = insertMarker(mark_img,marks_g,'x','size',25,'color','magenta');

figure
imshow(mark_img); title(strcat(img_name,' - fully marked'));

% write out to file
imwrite(mark_img, strcat('marked-',img_name));

%% determine time of high risk (sec)
full_loc = (height - loc) ./ fps;
left_loc = (height - loc_1) ./ fps;
mid_loc = (height - loc_2) ./ fps;
right_loc = (height - loc_3) ./ fps;
end

