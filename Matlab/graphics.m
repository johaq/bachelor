%% two classes
rndDeviation = 1;
rndMean = 0;
noPoints = 100;
rndSample = rndDeviation.*randn(noPoints,1) + rndMean; 
rndSample = sort(rndSample);
rndLabels = sign(rndSample);
rndInitLabels = rndLabels;

% add falsely classified points
noFalseFields = 3; % number of distributions used to insert possible true rejects


for i = 1:noFalseFields
    rndMeanFalse = round(((noPoints/2)*rand)+(noPoints/4)); % random number in the intervall of 0 to 1000
    rndDeviationFalse = 2; % flip label of this amount of points around the mean
    noFalsePoints = 5;
    rndSampleFalse = unique(round(rndDeviationFalse.*randn(noFalsePoints,1) + rndMeanFalse));
    for j = 1:size(rndSampleFalse)
        rndLabels(rndSampleFalse(j)) = rndLabels(rndSampleFalse(j)) * -1; % flip labels
    end
end

rndLabels(rndLabels == 1) = 2;
rndLabels(rndLabels == -1) = 1;
rndInitLabels(rndInitLabels == 1) = 2;
rndInitLabels(rndInitLabels == -1) = 1;

rndSample = [rndSample,rand(100,1)];

plot_labelled_data(rndSample,rndLabels);

%% paretofront
clear all

hold on
X = [0.1; 0.22; 0.29; 0.40; 0.45; 0.63; 0.75; 0.88; 0.9];
Y = [0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9];

scatter(X,Y);

X = [0; X];
Y = [0; Y];

plot(X,Y);
hold off