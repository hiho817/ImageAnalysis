close all

%parameters
videofilename = 'RBC20240304.wmv';
outfilename = 'HW04_109611112_2.mp4'
radii_range = [60,150];
bg_suffix = '_bg';
bg_ext = '.bmp';

threshold = 0.023 * 255;
smallremoval = 500;
se_dilate = strel('disk', 5);
se_rode = strel('disk', 5);

out = VideoWriter(outfilename, "MPEG-4");
open(out);

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
    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
end
close(out);

