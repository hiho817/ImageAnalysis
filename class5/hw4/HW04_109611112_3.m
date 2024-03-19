close all

%parameters
videofilename = 'RBC20240304.wmv';
n = 0; % frame counter
threshold = 0.023 * 255;
radii_range = [10,50];
bg_suffix = '_bg';
bg_ext = '.bmp';
smallremoval = 500;
se = strel('disk', 15);

% generate or load background (bg)
[path filename ext] = fileparts(videofilename);
bgfilename = [filename bg_suffix bg_ext];

if exist(bgfilename)
    bg = imread(bgfilename);
else
    bg = genbg_median(videofilename);
    imwrite(bg, bgfilename);
end

v = VideoReader(videofilename);

while hasFrame(v)
    n = n+1;
    I = readFrame(v);
    nobg = (I-bg)+(bg-I);
    %BW = (rgb2gray(nobg)>threshold);
    %BW = bwareaopen(BW, smallremoval);
    %BW = imerode(imdilate(BW,se),se);
    [centers, radii, metric] = imfindcircles(nobg,radii_range);
    imshow(I);
    hold on
    viscircles(centers, radii, 'EdgeColor', 'y');
    hold off
    drawnow
    delete(gca().Children(1:end-1));
end


