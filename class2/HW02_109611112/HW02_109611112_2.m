%Parameters
filename = 'video.avi';
framenum = 0;
outfilename = 'HW02_109611112_2.mp4';
% Read the video
v = VideoReader(filename);

% Create an output video and open it
out = VideoWriter(outfilename, "MPEG-4");
open(out);

% Track the object in the video
while hasFrame(v)
    frame = readFrame(v);  
    framenum = framenum + 1;
    gray = rgb2gray(frame);
    bw = imbinarize(gray,"global"); % Otsu's method
    bw=~bw;
    % extract the properties of white objects
    state = regionprops(bw, 'Area', 'Centroid','Circularity');

    % Set minimum and maximum area thresholds
    minArea = 5000;  
    maxArea = 7000; 
    minCircularity = 0.5 ;
    
    % Filter regions based on area
    validRegions = state([state.Area] >= minArea & [state.Area] <= maxArea & [state.Circularity] >= minCircularity);

    imshow(bw);
    hold on
    for sn = 1:numel(validRegions)
        text(validRegions(sn).Centroid(1), validRegions(sn).Centroid(2),num2str(validRegions(sn).Area), 'Color', 'blue')
    end
    hold off
    drawnow;

    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
end
close(out);