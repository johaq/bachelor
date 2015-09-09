function opt = rejectDP( initLabels, methodLabels, measure)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% NEXT TODO: get theta-matrix and f_ij-matrix

noClass = size(unique(initLabels)); % number of classes


%inits
T = zeros(noClass,1);
F = T;
N = T;
theta = cell(noClass,1); % thresholds for each class

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
    
    v_i_help = [0 v_i];
    v_i = [v_i 0];
    theta{i} = [find(v_i==1 & v_i_help == -1)]; % possible thresholds where values in v_i change from -1 to 1
end

% compute number of false and true rejects for each found threshold


end