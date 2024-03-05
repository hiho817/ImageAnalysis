close all
clear all

%% Parameters
filename = 'bouncing_ball.mp4';
outfilename = 'week2_tracking.mp4'
framenum = 0;
v_x = 0;
v_y = 0;

%% Read the video
v = VideoReader(filename);


%% Create an output video and open it
out = VideoWriter(outfilename, "MPEG-4");
open(out)

%% Track the object in the video
while hasFrame(v)
    % Load frame
    frame = readFrame(v);
    framenum = framenum + 1;
    
    % preprocess for converting frames into BW images
    gray = rgb2gray(frame);
    bw = imbinarize(gray,"global"); % Otsu's method

    % extract the properties of white objects
    state = regionprops(bw, 'Area', 'Centroid');

    % store the history of motion (trajectory and so on)
    p_x(framenum) = state(1).Centroid(1);
    p_y(framenum) = state(1).Centroid(2);
    if framenum>1
        v_x(framenum) = (state(1).Centroid(1) - p_x(framenum-1))/(1/v.FrameRate);
        v_y(framenum) = (state(1).Centroid(2) - p_y(framenum-1))/(1/v.FrameRate);
    end

    % Display the results
    subplot(2, 3, 1)
    plot((0:framenum-1)/v.FrameRate, p_x)
    xlabel('Time [s]')
    ylabel('x position [pixel]')
    title('x-t diagram')

    subplot(2, 3, 4)
    plot((0:framenum-1)/v.FrameRate, p_y)
    xlabel('Time [s]')
    ylabel('y position [pixel]')
    title('y-t diagram')

    subplot(2, 3, 2)
    plot((0:framenum-1)/v.FrameRate, v_x)
    xlabel('Time [s]')
    ylabel('x vel [pixel/s]')
    title('vx-t diagram')

    subplot(2, 3, 5)
    plot((0:framenum-1)/v.FrameRate, v_y)
    xlabel('Time [s]')
    ylabel('y vel [pixel/s]')
    title('vy-t diagram')

    subplot(2, 3, [3 6])
    imshow(frame)
    hold on
    for sn = 1:numel(state)
        text(state(sn).Centroid(1), state(sn).Centroid(2), ...
            num2str(state(sn).Area), 'Color', 'white')
        plot(p_x, p_y, 'Color','yellow', 'LineWidth',3);
    end
    hold off
%     pause(0.05)
    drawnow
%     subplot(1,3,1)
%     imshow(frame)
%     subplot(1,3,2)
%     imshow(gray)
%     subplot(1,3,3)
%     imshow(bw)
%     drawnow
    f = getframe(gcf);
    [FF, junk] = frame2im(f);
    writeVideo(out, FF); % write gcf(get current figure) to a frame
end

close(out)