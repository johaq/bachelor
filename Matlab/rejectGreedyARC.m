function [opt,arc] = rejectGreedyARC( initLabels, methodLabels)

noClass = length(unique(initLabels)); % number of classes
noTrue = sum(initLabels == methodLabels); % number of correctly classified points
noFalse = sum(initLabels ~= methodLabels); % number of incorrectly classified points


%inits
T = zeros(noClass,1);
F = T;
N = T;
theta = cell(noClass,1); % thresholds for each class
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

% compute difference of true and false rejects gained by each threshold
deltaTrueRejects = cell(noClass+1,1);
deltaTrueRejects{1} = [0 0];
deltaFalseRejects = deltaTrueRejects;
for i = 2:noClass+1
    deltaTrueRejects{i}=[0 0];
    deltaFalseRejects{i}=[0 0];
    for j = 3:length(theta{i-1})
        deltaTrueRejects{i} = [deltaTrueRejects{i} (trueRejects{i}(j)-trueRejects{i}(j-1))];
        deltaFalseRejects{i} = [deltaFalseRejects{i} (falseRejects{i}(j)-falseRejects{i}(j-1))];
    end
end

% compute opt greedily
opt = zeros(noTrue+1,1);

FR = 1;
TR = sum(cellfun(@(first) first(2),trueRejects));
curTheta = zeros(noClass+1,1)+2;
finTheta = cellfun(@(a) length(a),trueRejects);
opt(FR) = TR;

while(sum(curTheta ~= finTheta) > 0)
    g = zeros(noClass+1,1);
    for i=1:length(curTheta)
        if(curTheta(i)<finTheta(i))
            g(i) = deltaTrueRejects{i}(curTheta(i)+1) - deltaFalseRejects{i}(curTheta(i)+1);
        else
            g(i) = -Inf;
        end
    end
    [i,i] = max(g);
    curTheta(i)=curTheta(i)+1;
    FR = FR + deltaFalseRejects{i}(curTheta(i));
    TR = TR + deltaTrueRejects{i}(curTheta(i));
    if(opt(FR)<TR)
        opt(FR) = TR;
    end
end

arc = zeros(length(opt),2);

for i=1:(length(arc))
    arc(i,1) = (noTrue+noFalse-i-opt(i))/(noTrue+noFalse);
    arc(i,2) = (noTrue - i)/((noTrue+noFalse-i-opt(i)));
end

end

