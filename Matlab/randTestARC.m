
hFig = figure(1);
set(hFig, 'Position', [100 0 1000 700])

counter=1;
for z=1:3
    for y=1:3

rndDeviation = 1;
rndMean = 0;
noPoints = 10000;
rndSample = rndDeviation.*randn(noPoints,1) + rndMean; 
rndSample = sort(rndSample);
rndLabels = sign(rndSample);
rndInitLabels = rndLabels;

% add falsely classified points
noFalseFields = 500; % number of distributions used to insert possible true rejects


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
subplot(3,3,counter);
set(0,'DefaultTextInterpreter', 'latex')
hold on
axis([0.5 1 0.8 1]);
if(counter>6)
    xlabel('$$ \frac{\left|A_{\bar{\Theta}}\right|}{|X|} $$');
    
else
    xlabel('');
    set(gca,'XTickLabel',{});
end
if(mod((counter-1),3) == 0)
    ylabel('$$ \frac{\left|L \cap A_{\bar{\Theta}}\right|}{\left|A_{\bar{\Theta}}\right|} $$');
else
    ylabel('');
    set(gca,'YTickLabel',{}) 
end
counter = counter+1;

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
    
    
    end
end
