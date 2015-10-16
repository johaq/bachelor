timeDP = zeros(100,1);
timeBF = zeros(100,1);

for z=1:100
    rndDeviation = 1;
    rndMean = 0;
    noPoints = z*100;
    rndSample = rndDeviation.*randn(noPoints,1) + rndMean; 
    rndSample = sort(rndSample);
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
    tic;
    optDP = rejectDP(rndInitLabels,rndLabels);
    timeDP(z) = toc;
    tic;
    optBF = rejectBruteForce(rndInitLabels,rndLabels);
    timeBF(z) = toc;
end