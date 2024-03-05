clear all
close all
%Parameters
filename = 'video.avi';
framenum = 0;
outfilename = 'HW02_109611112_3.mp4';
p_x=0;
p_y=0;
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
     
    % store the history of motion (trajectory and so on)
    if (isempty(validRegions)) 
        p_x(framenum) = p_x(framenum-1);
        p_y(framenum) = p_y(framenum-1);
        Area = Area;
    else
        p_x(framenum) = validRegions.Centroid(1);
        p_y(framenum) = validRegions.Centroid(2);
        Area = validRegions.Area;
    end
       
    % Display the results
    subplot(2, 2, 1)
    plot((0:framenum-1)/v.FrameRate, p_x)
    xlabel('Time [s]')
    ylabel('x position [pixel]')
    title('x-t diagram')

    subplot(2, 2, 3)
    plot((0:framenum-1)/v.FrameRate, p_y)
    xlabel('Time [s]')
    ylabel('y position [pixel]')
    title('y-t diagram')

    subplot(2, 2, [2 4])
    imshow(frame);

    hold on
    text(p_x(framenum), p_y(framenum),num2str(Area), 'Color', 'red','FontSize',20);
    plot(p_x, p_y, 'Color','yellow', 'LineWidth',3);
    hold off
    drawnow;

    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
end
close(out);