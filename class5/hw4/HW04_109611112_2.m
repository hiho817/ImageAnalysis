close all

%parameters
videofilename = 'RBC20240304.wmv';
frame_num = 0;
radii_range = [60,150];
bg_suffix = '_bg';
bg_ext = '.bmp';



% generate or load background (bg)
[path filename ext] = fileparts(videofilename);
bgfilename = [filename bg_suffix bg_ext];

if exist(bgfilename)
    bg = imread(bgfilename);
else
    bg = genbg_median(videofilename);
    imwrite(bg, bgfilename);
end

im = imread(bgfilename);
[centers, radii, metric] = imfindcircles(im,radii_range);

v = VideoReader(videofilename);

while hasFrame(v)
    frame = readFrame(v);
    imshow(frame);
    hold on
    viscircles(centers, radii, 'EdgeColor', 'y');
    hold off
    drawnow
end


