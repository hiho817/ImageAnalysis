close all
clear 

videofilename = 'final_test.mp4';
video = VideoReader(videofilename);
n=0;
while hasFrame(video)

    frame = readFrame(video);

    % BW = imbinarize(frame(:,:,2));
    % mask = repmat(BW, [1, 1, 3]);
    % frame_2 = frame;
    % frame(repmat(~BW, 1, 1, 3))=255;
    % imshowpair(frame, frame_2, 'montage');

    if video.CurrentTime>1
        imshow(prev-frame)
    end
    prev = frame;
end