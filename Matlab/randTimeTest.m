close all
hFig = figure(1);
set(hFig, 'Position', [100 0 1000 700])
%%
testDP=zeros(10,1);
testBF=zeros(10,1);

for z=1:10
    z
    rndDeviation = eye(3);
    rndMean = [0,0,0];
    noPoints = 100+z*10;
    rndSample = mvnrnd(rndMean,rndDeviation,noPoints); 
    %rndSample = sort(rndSample);
    rndLabels = sign(rndSample);
    rndInitLabels = rndLabels;

    % add falsely classified points
    noFalseFields = noPoints/20; % number of distributions used to insert possible true rejects


    for i = 1:noFalseFields
        rndMeanFalse = round(((noPoints/2)*rand)+(noPoints/4)); % random number in the intervall of 0 to 1000
        rndDeviationFalse = 2; % flip label of this amount of points around the mean
        noFalsePoints = 5;
        rndSampleFalse = unique(round(rndDeviationFalse.*randn(noFalsePoints,1) + rndMeanFalse));
        for j = 1:size(rndSampleFalse)
            rndLabels(rndSampleFalse(j)) = rndLabels(rndSampleFalse(j)) * -1; % flip labels
        end
    end

    rndLabels(rndLabels == -1) = 0;
    rndLabels = bi2de([rndLabels(:,1),rndLabels(:,2),rndLabels(:,3)])+1;

    rndInitLabels(rndInitLabels == -1) = 0;
    rndInitLabels = bi2de([rndInitLabels(:,1),rndInitLabels(:,2),rndInitLabels(:,3)])+1;


    % plot


    %apply measure (distance to descision plane)

    rndSample=arrayfun(@(idx) norm(rndSample(idx,:)), 1:size(rndSample,1));
    [rndSample index] = sort(rndSample);
    rndLabels = rndLabels(index);
    rndInitLabels = rndInitLabels(index);

    %test
    tic;
    optDP = rejectDP(rndInitLabels,rndLabels);
    testDP(z)=toc;
    tic;
    optBF = rejectBruteForce(rndInitLabels,rndLabels);
    testBF(z)=toc;
end
%%
X=[1:10];
X=X.*10;
X=X+100;
hold on
xlabel('Number of Points');
ylabel('Running Time');
plot(X,testDP,'g');
plot(X,testBF,'r');
hold off
