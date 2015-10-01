function opt = rejectDPgraphic( initLabels, methodLabels)%, measure)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%TODO: might do -> index shift

noClass = length(unique(initLabels)); % number of classes
noTrue = sum(initLabels == methodLabels); % number of correctly classified points
noFalse = sum(initLabels ~= methodLabels); % number of incorrectly classified points


%inits
T = zeros(noClass,1);
F = T;
N = T;
theta = cell(noClass,1); % thresholds for each class
thetaall = cell(noClass,1);
v = cell(noClass,1); % indicator of correctly and incorrectly classified points in each class sorted by confidence

% find all possible threshold for each class
for i = 1:noClass
    index{i} = (methodLabels == i); % get index of every point classified in i
    
    T(i) = sum(initLabels(index{i}) == methodLabels(index{i})); % number of correctly classified points in i
    F(i) = sum(initLabels(index{i}) ~= methodLabels(index{i})); % number of incorrectly classified points in i
    N(i) = T(i)+F(i); % number of points in i
    
    l_init = initLabels(index{i}); % get original labels of points in i
    l_method = methodLabels(index{i}); % get labels of points in i returned by classificator
    v_i = ones(1,N(i));         % vector specifying for each point if it is correctly (1)...
    v_i(l_init~=l_method) = -1; % ...or incorrectly(-1) classified
    v{i} = v_i;
    
    v_i_help = [-1 v_i];
    v_i = [v_i 0];
    theta{i} = [0 find(v_i==1 & v_i_help == -1)]; % possible thresholds where values in v_i change from -1 to 1
    thetaall{i} = 0:length(v_i);
end

% compute number of false and true rejects for each found threshold
trueRejects = cell(noClass+1,1);
trueRejects{1} = [0 0];
falseRejects = trueRejects;
for i = 2:noClass+1
    for j = 1:length(theta{i-1})
        trueRejects{i} = [trueRejects{i} sum(v{i-1}(1:theta{i-1}(j)) == -1)]; % add up number of true rejects represented by -1
        falseRejects{i} = [falseRejects{i} sum(v{i-1}(1:theta{i-1}(j)) == 1)-1]; % add up number of false rejects rpresented by 1; one less because threshold itself should not be counted
    end
end


trueRejectsall = cell(noClass+1,1);
trueRejectsall{1} = [0 0];
falseRejectsall = trueRejectsall;
for i = 2:noClass+1
    for j = 1:(length(thetaall{i-1})-5)
        trueRejectsall{i} = [trueRejectsall{i} sum(v{i-1}(1:thetaall{i-1}(j)) == -1)]; % add up number of true rejects represented by -1
        falseRejectsall{i} = [falseRejectsall{i} sum(v{i-1}(1:thetaall{i-1}(j)) == 1)]; % add up number of false rejects rpresented by 1; one less because threshold itself should not be counted
    end
end



% compute opt according to bellmann-equation
opt = zeros(noTrue+1,noClass+1);

h = sum(cellfun(@(first) first(2),trueRejects)); % get number of true rejects if first threshold is choosen in each class
p = sum(cellfun(@(last) last(end),falseRejects)); % get number of false rejects if last threshold is choosen in each class


% just for a graphic ignore/delete me
close all
plot(trueRejectsall{2}, falseRejectsall{2},'r');
scatter(trueRejectsall{2}, falseRejectsall{2},'r');

hold on
xlabel('True Rejects');
ylabel('False Rejects');
axis([0 max(trueRejectsall{2}) 0 max(falseRejectsall{2})/2]);
plot(trueRejects{2}, falseRejects{2},'g');
scatter(trueRejects{2}, falseRejects{2},'g');
hold off

figure
hold on
xlabel('True Rejects');
ylabel('False Rejects');
axis([0 max(trueRejectsall{2}) 0 max(falseRejectsall{2})/2]);
scatter(trueRejectsall{2}, falseRejectsall{2},'b');
hold off

for j=1:noClass+1
    opt(1,j) = h;
end
for n=1:noTrue+1
    opt(n,1) = h;
end

for n = 2:p+1
    for j = 2:noClass+1
        opt(n,j) = opt(n,j-1);
        for i = 2:find(falseRejects{j}<n,1,'last') % look at all thresholds which result in a maximum of n false rejects
            newN = n-falseRejects{j}(i);
            gain = trueRejects{j}(i)-trueRejects{j}(2);
            h = opt (newN,j-1) + gain;
            if (h > opt(n,j))
                opt(n,j) = h;
            end
        end
    end
end

end