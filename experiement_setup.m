close all;
clearvars;

Screen('Preference', 'SkipSyncTests', 1);

%% Initial Set up
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
theImage = imread('instructions.png');
[s1, s2, s3] = size(theImage);
HideCursor();
imageTexture = Screen('MakeTexture', window, theImage);
Screen('DrawTexture', window, imageTexture, [], [], 0);
Screen('Flip', window);
KbStrokeWait;

%% Define the percentage of target objects
numberOfElements = 90;  % Whatever.
percentageOfOnes = 80; % Whatever.
numberOfOnes = round(numberOfElements * percentageOfOnes / 100);
% Make initial signal with proper number of 0's and 1's.
signal = [ones(1, numberOfOnes), zeros(1, numberOfElements - numberOfOnes)];
% Scramble them up with randperm
signal = signal(randperm(length(signal)));

data = {};
target_objects = [];
responses = {};
rt = [];
%% define trials
for k = 1:5
% Define object's borders
z = clusters_screen(360,240);
distance = 300;

grid = clusters_grid(z, distance);
all_cluster_centers = cell2mat(grid);

% Delete the center point of the grid 
all_cluster_centers(8,:) = [];

% the below code is to draw the grid for all clusters
all_cluster_grid = circular_grid(all_cluster_centers);
reshape_all_cluster_grid = permute(all_cluster_grid,[1 3 2]);
reshape_all_cluster_grid = reshape(reshape_all_cluster_grid,[],size(all_cluster_grid,2),1);


%% Randomly pick the 3 to 8 clusters; clusterCenter return the x and y of the center of the clusters 

cluster_num = randi([3 8],1,1);

% randomly choose clusters 
p = sort(randperm(14,cluster_num));

clusterCenters = [];
for i = 1: cluster_num
    clusterCenters = [clusterCenters ;all_cluster_centers(p(i),:)];
end


%% Add Randomness to the cluster's centers
 randomness = [];
for i = 1:size(clusterCenters, 1)
    for j = 1:size(clusterCenters, 2)
        randomness(i,j) = randi([clusterCenters(i,j)-30 clusterCenters(i,j)+30],1 ,1);
    end
end

random_cluster_grid = circular_grid(randomness);

% arrange all grid points of all clusters under each other to draw the
% grids
C = permute(random_cluster_grid,[1 3 2]);
C = reshape(C,[],size(random_cluster_grid,2),1);
 
all_rand_obj = {}; 
obj_num_clus = [];
r_grid_points = {};
for i = 1:size(random_cluster_grid,3)
    obj_num = randi([3 8],1,1);
    obj_num_clus = [obj_num_clus, obj_num];
    % randomly choose clusters 
    s = sort(randperm(20,obj_num));
    r_grid_points = [r_grid_points; s];
    %all_rand_obj = [all_rand_obj; random_cluster_grid(s,:,i)];
    all_rand_obj{i,1} = random_cluster_grid(s,:,i);
end

% arrange the randomly selected in each randomly selected cluster to draw 
all_rand_obj_init = [];
for i = 1:size(all_rand_obj)
    all_rand_obj_init = [all_rand_obj_init; all_rand_obj{i}];
end

all_rand_obj_final = all_rand_obj_init;

%% Calculate the object's changes of x and y in reference to the center for each cluster
delta_x_y = {};

for i = 1:size(randomness,1) 
    delta_x_y = [delta_x_y; all_rand_obj{i} - randomness(i,:)];
end

%% arrange the object's changes of x and y in an array

delta_x_y1 = [];
for i = 1:size(delta_x_y)
    delta_x_y1 = [delta_x_y1; delta_x_y{i}];
end

%% Calculate the ratio
ratio = [];
 
for i = 1:length(delta_x_y1)
    ratio(i,1) = delta_x_y1(i,1)/100;
    ratio(i,2) = delta_x_y1(i,2)/100;
end

%% Move objects
ifi = Screen('GetFlipInterval', window);
time = 0;

%% Draw Fixation cross
fixCrossDimPix = 30;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 4;

%% randomly choose a cluster and flickering object
if signal(k) == 1
    r_c = randi([1 size(all_rand_obj_init,1)],1,1);
    target_objects = [target_objects; r_c];
end
if signal(k) ==0
    target_objects = [target_objects; 0];
end

%% Specify color & size

objectsColor = [1 1 0];
fadingColor = [1 1 0];

dotColor = [1 1 1];
dotSizePix = 20;

centerDot = 10;
centerColor = [1 1 1];

% Randomly change the size of the objects
objs_size = randi([20 40],size(all_rand_obj_final,1) ,1);


while time < 2.2
 
 % un/comment to draw fixation cross
 Screen('DrawLines', window, allCoords, lineWidthPix, white, [xCenter yCenter]); 
 
 if time > 1
    
   all_rand_obj_final = all_rand_obj_final + ratio/4;
     
   % un/comment to draw the randomly selected objects in the randomly selected clusters
   Screen('DrawDots', window, all_rand_obj_final', objs_size, objectsColor, [], 2);

 end

%% flickering object task
if signal(k) == 1
    if time > 1.6
             Screen('DrawDots', window, all_rand_obj_final(r_c ,:)',dotSizePix , [0 0 0], [], 2);
    end

    if time > 1.62
             Screen('DrawDots', window, all_rand_obj_final(r_c ,:)',dotSizePix , objectsColor, [], 2);
    end
end
initSec=GetSecs();
time = time + ifi;
Screen('Flip', window);
end
 
KbWait;   
[t1 ,t2, t3] = KbCheck;
finSec=GetSecs();

responses = [responses; KbName(t3)];
rt=[rt, finSec-initSec];

%% write the data
trials = {};
f = 1;
for i = 1:size(r_grid_points,1)
    for j = 1:size(r_grid_points{i,1},2)
        trials{f,1} = k;
        trials{f,2} = p(i);
        trials{f,3} = r_grid_points{i,1}(j);
        trials{f,4} = randomness(i,:);
        trials{f,5} = all_rand_obj_init(f,:);
        trials{f,6} = all_rand_obj_final(f,:);
        trials{f,7} = objs_size(f);
        f = f + 1;
    end
end
for t = 1:size(all_rand_obj_init,1)
    if t == target_objects(k)
        trials{t,8} = 1;
    else
        trials{t,8} = 0;
    end
    
end
data = [data; trials];


end
responses = convertCharsToStrings(responses);
rsp = [];
for t = 1:3
    if responses(t) == 'RightArrow'
        rsp(t,1) = 1;
        rsp(t,2) = rt(t);
    elseif responses(t) == 'LeftArrow'
        rsp(t,1) = 0;
        rsp(t,2) = rt(t);
    end
end

save('data.mat', 'data')
save('response.mat','rsp')
save('target.mat','signal')

ShowCursor();
sca;