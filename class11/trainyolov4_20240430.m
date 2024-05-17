close all
clear all

% GroundTruthFilename = 'bubble_label_video.mat';
GroundTruthFilename = 'bubble_label_image.mat';
inputSize = [224 224 3];
numAnchors = 6;
yoloname = 'tiny-yolov4-coco';
learnrate = 0.00001;
epoch = 100;
batch = 10;
verbf = 10;


%% load data and transform it

load(GroundTruthFilename)

[imds blds] = objectDetectorTrainingData(gTruth);
ds = combine(imds, blds);
trainingDataForEstimation = transform(ds, @(data)preprocessData(data,inputSize));

%% set NN and training parameters
[anchors IOU] = estimateAnchorBoxes(trainingDataForEstimation, numAnchors);
area = anchors(:,1).*anchors(:,2);
[~, idx] = sort(area, 'descend');
anchors = anchors(idx, :);
anchorBoxes = {anchors(1:3, :) ; anchors(4:6, :)};

classes = gTruth.LabelData.Properties.VariableNames; %'bubble'
detector = yolov4ObjectDetector(yoloname, classes, anchorBoxes, 'InputSize', inputSize);
Options = trainingOptions('sgdm', 'InitialLearnRate', learnrate, 'MaxEpochs', epoch, ...
    'MiniBatchSize', batch, 'Plots', 'training-progress', 'Verbose', true, 'VerboseFrequency', verbf);


%% train NN
trainedDetector = trainYOLOv4ObjectDetector(trainingDataForEstimation, detector, Options);



function data = preprocessData(data,targetSize)
for num = 1:size(data,1)
    I = data{num,1};
    imgSize = size(I);
    bboxes = data{num,2};
    I = im2single(imresize(I,targetSize(1:2)));
    scale = targetSize(1:2)./imgSize(1:2);
    bboxes = bboxresize(bboxes,scale);
    data(num,1:2) = {I,bboxes};
end
end