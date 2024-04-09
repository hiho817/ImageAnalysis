close all
%Parameters
filename = 'midterm01a.mp4';
frame_num = 0;
outfilename = 'mid_109611112_02.mp4';
p_x=0;
p_y=0;
minCircularity = 0.9;
minArea = 200;
% Read the video
v = VideoReader(filename);

% Create an output video and open it
out = VideoWriter(outfilename, "MPEG-4");
open(out);

while hasFrame(v)
    frame = readFrame(v);
    frame_num = frame_num + 1;
    gray = rgb2gray(frame);
    bw = imbinarize(gray,"global"); % Otsu's method
    bw=~bw;
    
     % extract the properties of white objects
    state = regionprops(bw, 'Area', 'Centroid','Circularity');

     % Filter regions based on area
    validRegions =state([state.Area] >= minArea & [state.Circularity] >= minCircularity);
    p_x(frame_num) = validRegions.Centroid(1);
    p_y(frame_num) = validRegions.Centroid(2);


    imshow(frame)
    hold on
    plot(p_x, p_y, 'Color','black', 'LineWidth',3);
    title(['frame=',num2str(frame_num)]);
    hold off
    drawnow;
    
    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
end

close(out);