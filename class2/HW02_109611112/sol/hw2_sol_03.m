close all
clear all

%% parameters
videofilename = 'video.avi';
outfilename = 'hw2_sol_03.mp4';
se = strel('disk', 10);
se_line = strel('line', 10, 0);
smallremoval = 2000;
MaxArea = 20000;
minArea = 5000;
coin_n = 0; % coin data counter
coin_t = 0; % coin time
coin_x = 0; % coin x
coin_y = 0; % coin y
fn =0;  % frame counter

%% load the video
v = VideoReader(videofilename);

%% create an output video
o = VideoWriter(outfilename, 'MPEG-4');
o.FrameRate = v.FrameRate;
open(o)

%% play video with while loop
while hasFrame(v)
    frame = readFrame(v);
    fn = fn + 1;
    gray = rgb2gray(frame);
    BW1 = imbinarize(gray);
    BW2 = ~BW1; % inverse black and white 
    BW2 = bwareaopen(BW2, smallremoval);
    BW3 = imdilate(BW2, se);
    BW3 = imdilate(BW3, se_line);
    BW3 = imerode(BW3, se_line);
    BW3 = imerode(BW3, se);

    state = regionprops(BW3, 'Area', 'Centroid');

    for n = 1:numel(state)
        if state(n).Area < MaxArea && state(n).Area > minArea
            coin_n = coin_n + 1;
            coin_x(coin_n) = state(n).Centroid(1); 
            coin_y(coin_n) = state(n).Centroid(2);
            coin_t(coin_n) = v.CurrentTime;
        end
    end

    % display on screen & save to video
    subplot(2,2, [1 3])
    imshow(frame);
    title(['time = ' num2str(v.CurrentTime)])

    % plot the trajectory
    hold on;
    plot(coin_x, coin_y, 'Color', 'r')
    hold off;

    % label the coin size 
    for n = 1:numel(state)
        if state(n).Area < MaxArea && state(n).Area > minArea
            text(state(n).Centroid(1), state(n).Centroid(2), ...
                num2str(state(n).Area), 'FontSize', 18, 'Color', 'r')
        end
    end

    subplot(2,2,2)
    plot(coin_t, coin_x)
%     title(['region num = ' num2str(numel(state))])
    xlabel('Time [sec]')
    ylabel('x position [pixel]')
    
    subplot(2,2,4)
    plot(coin_t, coin_y)
%     title(['region num = ' num2str(numel(state))])
    xlabel('Time [sec]')
    ylabel('y position [pixel]')
%     imshow(BW3);
%     pause
    drawnow
    outframe = getframe(gcf);
    writeVideo(o, outframe);
end

close(o)