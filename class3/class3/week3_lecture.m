close all
clear all

%% parameters
videofilename = 'RBC20240304.wmv';

fn = 0;

%% load the video
v = VideoReader(videofilename);

%% play video with while loop
while hasFrame(v)
    frame = readFrame(v);
    fn = fn + 1; % frame counter
    
    if fn == 1
        bg = double(frame);
    else
        bg = bg + double(frame);
    end


    % display on the screen
    subplot(1,2,1)
    imshow(frame);
    title(['frame = ' num2str(fn)])

    subplot(1,2,2)
    imshow(uint8(bg/fn));

%     pause(1)
    drawnow
end

backg = uint8(bg/fn);
save('lec20240305', 'backg')