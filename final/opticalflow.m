% Load video
videoReader = VideoReader('final_test.mp4');
frame1 = readFrame(videoReader);

% Loop through video frames
while hasFrame(videoReader)
    frame2 = readFrame(videoReader);
    % Convert to grayscale
    grayFrame1 = rgb2gray(frame1);
    grayFrame2 = rgb2gray(frame2);
    % Calculate optical flow
    opticFlow = opticalFlowLK;
    flow = estimateFlow(opticFlow, grayFrame1);
    flow = estimateFlow(opticFlow, grayFrame2);
    % Threshold the flow to create binary mask
    magnitude = sqrt(flow.Vx.^2 + flow.Vy.^2);
    foregroundMask = magnitude > 2; % Adjust threshold as needed
    % Apply mask to original frame
    result = frame2 .* uint8(foregroundMask);
    % Show result
    imshow(result);
    drawnow;
    % Update frame
    frame1 = frame2;
end
