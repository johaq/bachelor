% Using a normal distribution we get radom samples of points divided
% into 2 classes (above and below 0). To get some falsely classified
% points we add an array of false labels at randomly selected points.

hFig = figure(1);
set(hFig, 'Position', [100 0 1000 700])

counter=1;
for z=1:3
    for y=1:3
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
optBF = rejectBruteForce(rndInitLabels,rndLabels)
%optDP = rejectDPgraphic(rndInitLabels,rndLabels)
%optGreedy = rejectGreedy(rndInitLabels,rndLabels)


% paretofront comparison

%hold on

        subplot(3,3,counter);
        hold on
        axis([0 65 0 150]);
        if(counter>6)
            xlabel('True Rejects');
        else
            xlabel('');
            set(gca,'XTickLabel',{});
        end
        if(mod((counter-1),3) == 0)
            ylabel('False Rejects');
        else
            ylabel('');
            set(gca,'YTickLabel',{}) 
        end
        counter = counter + 1;
        

        maxi = 0;
        for i=1:length(optBF)
            if(optBF(i)<=maxi)
                optBF(i)=0;
            else
                maxi=optBF(i);
            end

        end

        [I,M] = find(optBF ~=0)

        plot(optBF(I),I,'g-');
        scatter(optBF(I),I,'g');
        
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
        plot(optDPmax(I), I,'r--');
        scatter(optDPmax(I), I,'r','+');
        
        hold off
    end
end
%hold off
