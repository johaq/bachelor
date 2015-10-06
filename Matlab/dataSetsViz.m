close all
hFig = figure(1);
set(hFig, 'Position', [100 100 1000 300])

x = [-3:.1:3];
norm = normpdf(x,0,1);

rndDeviation = 1;
rndMean = 0;
noPoints = 40;
rndSample = rndDeviation.*randn(noPoints,1) + rndMean; 
rndSample = sort(rndSample);
rndLabels = sign(rndSample);
rndInitLabels = rndLabels;

noFalseFields = 5; % number of distributions used to insert possible true rejects


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

hold on
scatter(rndSample(rndLabels == 2),zeros(length(rndSample(rndLabels == 2)),1),50,'ko');
scatter(rndSample(rndLabels == 1),zeros(length(rndSample(rndLabels == 1)),1),50,'ko','filled');
plot(x,norm);
hold off
