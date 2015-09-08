% Using a normal distribution we get radom samples of points divided
% into 2 classes (above and below 0). To get some falsely classified
% points we add an array of false labels at randomly selected points.

rndDeviation = 1;
rndMean = 0;
noPoints = 1000;
rndSample = rndDeviation.*randn(noPoints,1) + rndMean; 
rndSample = sort(rndSample);
rndLabels = sign(rndSample);

% add falsely classified points
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

%NEXT TODO: apply measure (distance to descision plane)