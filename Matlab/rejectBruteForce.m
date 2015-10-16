function opt = rejectBruteForce( initLabels, methodLabels)
%REJECTBRUTEFORCE Summary of this function goes here
%   Detailed explanation goes here

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

% compute opt according to bellmann-equation
opt = zeros(noTrue+1,1);

for a=2:length(theta{1})
    for b=2:length(theta{2})
        for c=2:length(theta{3})
            for d=2:length(theta{4})
                for e=2:length(theta{5})
                    for f=2:length(theta{6})
                        for g=2:length(theta{7})
                            for h=2:length(theta{8})
                                configFalse = falseRejects{2}(a)+falseRejects{3}(b)+falseRejects{4}(c)+falseRejects{5}(d)+falseRejects{6}(e)+falseRejects{7}(f)+falseRejects{8}(g)+falseRejects{9}(h);
                                configTrue = trueRejects{2}(a)+trueRejects{3}(b)+trueRejects{4}(c)+trueRejects{5}(d)+trueRejects{6}(e)+trueRejects{7}(f)+trueRejects{8}(g)+trueRejects{9}(h);
                                if(opt(configFalse+1)<configTrue)
                                    opt(configFalse+1) = configTrue;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

end

