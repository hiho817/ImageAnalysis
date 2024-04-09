close all
clear all
%Parameters
filename = 'midterm01a.mp4';
frame_num = 0;
outfilename = 'mid_109611112_03.mp4';
x=0;
y=0;
minCircularity = 0.9;
minArea = 200;
max = [0,0];
min = [1000,1000];
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
    
    %t = framenum/v.FrameRate;
     % extract the properties of white objects
    state = regionprops(bw, 'Area', 'Centroid','Circularity');

     % Filter regions based on area
    validRegions =state([state.Area] >= minArea & [state.Circularity] >= minCircularity);
    x(frame_num) = validRegions.Centroid(1);
    y(frame_num) = validRegions.Centroid(2);
    Area = validRegions.Area;
    
    %speed
    if (frame_num ~= 1)
        vel_x(frame_num) = (x(frame_num)-x(frame_num-1))*v.FrameRate;
        vel_y(frame_num) = (y(frame_num)-y(frame_num-1))*v.FrameRate;
    end

    radius(frame_num) = sqrt(Area/pi);
    %draw the wall
    if( x(frame_num) + radius(frame_num) > max(1))
        max(1) = x(frame_num) + radius(frame_num);
    end
    if( y(frame_num) + radius(frame_num) > max(2))
        max(2) = y(frame_num) + radius(frame_num);
    end
    if( x(frame_num) - radius(frame_num) < min(1))
        min(1) = x(frame_num) - radius(frame_num);
    end
    if( y(frame_num) - radius(frame_num) < min(2))
        min(2) = y(frame_num) - radius(frame_num);
    end

    imshow(frame)
    hold on
    rectangle('Position',[min(1) min(2) max(1)-min(1) max(2)-min(2)],'LineWidth',2,EdgeColor='b');
    plot(x, y, 'Color','black', 'LineWidth',3);
    hold off
    drawnow;
    
    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
end

close(out);