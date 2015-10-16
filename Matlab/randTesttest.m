% Using a normal distribution we get radom samples of points divided
% into 2 classes (above and below 0). To get some falsely classified
% points we add an array of false labels at randomly selected points.
rndDeviation = 1;
rndMean = 0;
noPoints = 400;
rndSample = rndDeviation.*randn(noPoints,1) + rndMean; 
rndSample = sort(rndSample);
rndLabels = sign(rndSample);
rndInitLabels = rndLabels;

% add falsely classified points
noFalseFields = 20; % number of distributions used to insert possible true rejects


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

% plot


%apply measure (distance to descision plane)
rndSample = abs(rndSample);
[rndSample index] = sort(rndSample);
rndLabels = rndLabels(index);
rndInitLabels = rndInitLabels(index);

%test

optDP = rejectDP(rndInitLabels,rndLabels)
%optBF = rejectBruteForce(rndInitLabels,rndLabels)
%optDP = rejectDPgraphic(rndInitLabels,rndLabels)
optGreedy = rejectGreedy(rndInitLabels,rndLabels)


% paretofront comparison

hold on

[I,M] = find(optGreedy ~=0)
plot(optGreedy(I), I,'r');
scatter(optGreedy(I), I,'r','+');

optDPmax = zeros(length(optDP),1);
for l=1:length(optDP)
    optDPmax(l) = max(optDP(l,:));
end

maxi = 0;
for i=1:length(optDPmax)
    if(optDPmax(i)<=maxi)
        optDPmax(i)=0;
    else
        maxi=optDPmax(i);
    end

end

[I,M] = find(optDPmax ~=0)
plot(optDPmax(I), I,'g--');
scatter(optDPmax(I), I,'g','+');
hold off