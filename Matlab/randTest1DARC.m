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


% arc comparison

hold on

set(gca,'XDir','reverse');

[optBF,arc] = rejectBruteForceARC(rndInitLabels,rndLabels);

maxi = 0;
for i=1:length(optBF)
    if(optBF(i)<=maxi)
        optBF(i)=0;
    else
        maxi=optBF(i);
    end

end

[I,M] = find(optBF ~=0)

C = arc(:,1);
Acc = arc(:,2);


%scatter(C(I),Acc(I),'g');
plot(C(I),Acc(I),'g-','LineWidth',2);

[optBF,arc] = rejectGreedyARC(rndInitLabels,rndLabels);

maxi = 0;
for i=1:length(optBF)
    if(optBF(i)<=maxi)
        optBF(i)=0;
    else
        maxi=optBF(i);
    end

end

[I,M] = find(optBF ~=0)

C = arc(:,1);
Acc = arc(:,2);


%scatter(C(I),Acc(I),'r');
plot(C(I),Acc(I),'r--','LineWidth',2);

hold off