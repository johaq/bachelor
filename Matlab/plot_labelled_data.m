function [axHandle] = plot_labelled_data( Data, Labels, axHandle )
% Plots 1D, 2D, or 3D data as a scatterplot, colored by given class labels.
%
% DESCRIPTION:
%   The function expects a data matrix with each row being a data vector,
%   and a column vector Labels, where each entry is a number in {1,...,c}
%   if c is the number of classes. The size of Labels must correspond to
%   the rows of the data matrix. Note that higher number of classes are
%   harder to display.
%
% REQUIRED INPUT: 
%   Data ... the data vectors, where each row is one vector
%
% OPTIONAL INPUT:
%   Labels ... the class labels, where each label is an integer number
%   axHandle ... a Matlab handle to the existing figure axes to plot into
%
% OUTPUT:
%   axHandle ... a Matlab handle (i.e. address) of the figure window
%
% ----------- (c) 2012, Bassam Mokbel, Universität Bielefeld -------------


% if optional inputs are omitted, set default parameters/inputs
if nargin<2 || isempty(Labels)  % if no Labels are given
    Labels = ones(size(Data,1), 1);  % assign all points to one class
end
if nargin<3 || isempty(axHandle) % if no axHandle, create a figure and axes
    figTitle = 'data';  % use a very general figure title
    scrsz = get( 0, 'ScreenSize' );  % determine screen size
    figHandle = figure( 'Name', figTitle, ...
                        'Position', [floor(scrsz(3)*0.2) floor(scrsz(3)*0.2) floor(scrsz(3)*0.5) floor(scrsz(4)*0.5)] ...
                       );  % create new figure window
    axHandle = axes;  % create axes
else
    assert( strcmp(get(axHandle,'type'), 'axes') );  % ensure proper handle
end

% setup
numClasses = numel(unique(Labels));
if (numClasses > 8)
    disp( 'WARNING: Number of class labels exceeds 8, so they are displayed as combinations of marker shapes and marker colors.' );
end
cm = lines(numClasses);  % use "lines" as the colormap for the data classes
% cm = hot(numClasses);  % alternative colormap with continuous colors
markers = 'ovsd^><p';  % use a default sequence of marker types
mk = repmat( markers, 1, ceil(numClasses/8));  % repeat markers
sz = 6;  % constant MarkerSize
lw = 1;  % constant LineWidth
hold( axHandle, 'on' );  % add everything that follows to the existing plot

% plot
for i=min(Labels):max(Labels)  % iterate through data classes
    Class = Data(Labels==i,:);  % all data points with class labels i
    switch size(Data,2)  % switch according to data dimensionality
        case 3
            % plot in 3D
            plot3( axHandle, Class(:,1), Class(:,2), Class(:,3), ...
                   'LineStyle', 'none', 'Marker', mk(i), ...
                   'MarkerEdgeColor', 'k', 'MarkerFaceColor', cm(i,:), ...
                   'MarkerSize', sz, 'LineWidth', lw ...
                   );
            view([-0.2 -0.8 0.1]);  % set view point of 3D figure
            axis(axHandle,'equal');
            axis(axHandle,'tight');  % set coordinate axes to fit the data
        case 2
            % plot in 2D
            plot( axHandle, Class(:,1), Class(:,2), ...
                  'LineStyle', 'none', 'Marker', mk(i), ...
                  'MarkerEdgeColor', 'k', 'MarkerFaceColor', cm(i,:), ...
                  'MarkerSize', sz, 'LineWidth', lw ...
                  );
            axis(axHandle,'equal');
            axis(axHandle,'tight');  % set coordinate axes to fit the data
        case 1
            % plot in 1D
            plot( axHandle, Class(:,1), zeros(numel(Class(:,1)),1), ...
                  'LineStyle', 'none', 'Marker', mk(i), ...
                  'MarkerEdgeColor', 'k', 'MarkerFaceColor', cm(i,:), ...
                  'MarkerSize', sz, 'LineWidth', lw ...
                  );
            axis(axHandle,'equal');
            axis(axHandle,'tight');  % set coordinate axes to fit the data
        otherwise
            disp( 'Error: Data cannot be plotted! The data vectors must be 1-, 2- or 3-dimensional.' );
    end
end

% add a legend with the label numbers
LegendStrings = strtrim(cellstr(num2str(unique(Labels))));
legend( LegendStrings, 'Location', 'BestOutside', 'FontSize', 12, 'FontWeight', 'bold' );
hold( axHandle, 'off');

