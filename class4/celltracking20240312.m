close all
clear all

%% parameters
videofilename = 'RBC20240304.wmv';
bg_suffix = '_bg';
bg_ext = '.bmp';
n = 0; % frame counter
cell_count = 0; % cell counter
threshold = 0.023 * 255;
smallremoval = 500;
maxmovedist = 50;
se = strel('disk', 10);
CellData = struct();
%%
[path filename ext] = fileparts(videofilename);
bgfilename = [filename bg_suffix bg_ext];


%% load the video
v = VideoReader(videofilename);

%% generate or load background (bg)
if exist(bgfilename)
    bg = imread(bgfilename);
else
    bg = genbg_median(videofilename);
    imwrite(bg, bgfilename);
end
% imshow(bg);
% title('median background')
% pause
%% loop for n-th frame
while hasFrame(v)
    n = n+1;
    I = readFrame(v);
    nobg = (I-bg)+(bg-I);
%     BW = imbinarize(rgb2gray(nobg));
    BW = (rgb2gray(nobg)>threshold);
    BW = bwareaopen(BW, smallremoval);
    BW = imerode(imdilate(BW,se),se);
    
    state = regionprops(BW, 'Area', 'Centroid');


    % object matching
    if n == 1
        for m = 1:numel(state)
            [CellData cell_count] = Add_cell(state, m, n, CellData, cell_count);
            state(m).cellnum = cell_count;
        end
    else
        for m = 1:numel(state)
            distance = 0;
            for checkn = 1:cell_count
                distance(checkn) = caldist(state, m, CellData, checkn);
                subplot(1,2,1)
            end
            [value id] = min(distance); % id is the nearest cell in the Celldata
%             text(state(m).Centroid(1),state(m).Centroid(2),'state', 'FontSize', 20, 'color','r')
%             text(CellData(id).Centroid(end, 1),CellData(id).Centroid(end,2),'cell', 'FontSize', 20, 'color','g')
%             title(['distance = ' num2str(value)])
%             pause
            if value <= maxmovedist
                CellData = Update_cell(state, m, n, CellData, id);
                state(m).cellnum = id;
            else
                [CellData cell_count] = Add_cell(state, m, n, CellData, cell_count);
            end
        end
    end


    % display
    subplot(1,2,1)
    imshow(BW);
    for ss = 1:numel(state)
        text(state(ss).Centroid(1), state(ss).Centroid(2),...
            num2str(state(ss).cellnum), 'FontSize', 18, 'color', 'r')
    end
    title(['number of region = ' num2str(numel(state))])
    subplot(1,2,2)
    imshow(nobg);
    title(['threshold = ' num2str(threshold)])
    drawnow
%     pause
end


function [CellData, cell_count] = Add_cell(state, m, n, CellData, cell_count)
    cell_count = cell_count + 1;
    CellData(cell_count).Area = state(m).Area;
    CellData(cell_count).Centroid = state(m).Centroid;
    CellData(cell_count).FrameN = n;
end

function CellData = Update_cell(state, m, n, CellData, id)
    CellData(id).Area = [CellData(id).Area ; state(m).Area];
    CellData(id).Centroid = [CellData(id).Centroid ; state(m).Centroid];
    CellData(id).FrameN = [CellData(id).FrameN ; n];
end

function distance = caldist(state, m, CellData, p)
    x1 = state(m).Centroid(1);
    y1 = state(m).Centroid(2);
    x2 = CellData(p).Centroid(end, 1);
    y2 = CellData(p).Centroid(end, 2);
    distance = ((x1-x2)^2+(y1-y2)^2)^.5;
end