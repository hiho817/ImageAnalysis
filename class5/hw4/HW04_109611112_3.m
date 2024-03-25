close all

%parameters
videofilename = 'RBC20240304.wmv';
outfilename = 'HW04_109611112_3.mp4'
n = 0; % frame counter
threshold = 0.023 * 255;
radii_range = [15,50];
bg_suffix = '_bg';
bg_ext = '.bmp';

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

v = VideoReader(videofilename);
while hasFrame(v)
    n = n+1;
    I = readFrame(v);
    nobg = (I-bg)+(bg-I);
    nobg = rgb2gray(nobg);
    

    [centers, radii, metric] = imfindcircles(nobg,radii_range,Sensitivity = 0.9,EdgeThreshold=0.005);
    imshow(I);
    hold on
    viscircles(centers, radii, 'EdgeColor', 'y');
    hold off
    drawnow
    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
    delete(gca().Children(1:end-1));
end
close(out);