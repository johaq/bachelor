function opt = rejectDP( initLabels, methodLabels, measure)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% NEXT TODO: indexshift

noClass = size(unique(initLabels)); % number of classes
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
    
    T(i) = sum(init_Labels(index{i}) == methodLabels(index{i})); % number of correctly classified points in i
    F(i) = sum(init_Labels(index{i}) ~= methodLabels(index{i})); % number of incorrectly classified points in i
    N(i) = T(i)+F(i); % number of points in i
    
    l_init = initLabels(index{i}); % get original labels of points in i
    l_method = methodLabels(index{i}); % get labels of points in i returned by classificator
    v_i = ones(1,N(i));         % vector specifying for each point if it is correctly (1)...
    v_i(l_init~=l_method) = -1; % ...or incorrectly(-1) classified
    v{i} = v_i;
    
    v_i_help = [0 v_i];
    v_i = [v_i 0];
    theta{i} = [find(v_i==1 & v_i_help == -1)]; % possible thresholds where values in v_i change from -1 to 1
end

% compute number of false and true rejects for each found threshold
trueRejects = cell(noClass,1);
falseRejects = trueRejects;
for i = 1:noClass
    for j = 1:size(theta{i})
        trueRejects{i} = [trueRejects{i} sum(v{i}(1:j) == -1)]; % add up number of true rejects represented by -1
        falseRejects{i} = [falseRejects{i} sum(v{i}(1:j) == 1)-1]; % add up number of false rejects rpresented by 1; one less because threshold itself should not be counted
    end
end

% compute opt according to bellmann-equation
opt = zeros(noTrue,noClass)

h = sum(cellfun(@(first) first(1),trueRejects)); % get number of true rejects if first threshold is choosen in each class
for j=1:noClass
    opt(1,j) = h;
end
for n=1:noTrue
    opt(n,1) = h;
end

for n = 1:noTrue
    for j = 1:noClass
        for i = 1:min(n,falseRejects{j}(i))
        end
    end
end

end