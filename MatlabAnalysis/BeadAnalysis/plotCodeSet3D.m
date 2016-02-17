function plotCodeSet3D(ratios, target, idx, colorAxis, colorByMeasure, subsample)
%plotCodeSet3D: Plot an encoded bead set in 3D
%   Plots an econded bead set in 3D, with a 4th axis plotted as a color
%   Inputs:
%   ratios: the measured lanthanide ratios for the codeset; nbeads x 4 array
%   target: the target lanthanide ratios for the codeset; ncodes x 4 array
%   idx: the index in target of each bead; nbeads x 1 array
%   colorAxis: which axis to use as the color code; integer 1 - 4
%   colorByMeasure: True to color 4th axis by the measured ratio; False to
%                   color by the target ratio of that code
%   subsample: Plots only every nth bead; set to 1 to plot all beads

samples = 1:subsample:size(ratios,1);
ratios = ratios(samples,:);
idx = idx(samples,:);
nAxes = size(target,2);

plotAxes = setdiff(1:nAxes, colorAxis);
axisLabels ={'CeTb', 'Dy', 'Sm', 'Tm'};
for n=1:nAxes
    uniqueLevels{n} = unique(target(:,n));
end
colorLevels = uniqueLevels{colorAxis};
nColors = numel(colorLevels);

if colorByMeasure
    colors = ratios(:, colorAxis);
else
    [~,colors] = ismember(target(idx, colorAxis), uniqueLevels{colorAxis});
    cmap = colormap(parula(nColors));
    colors = cmap(colors,:);
end

figname = ['X-Axis ', axisLabels{plotAxes(1)}, '; Y-Axis ', axisLabels{plotAxes(2)}, '; Z-Axis ', axisLabels{plotAxes(3)}, '; Colors ', axisLabels{colorAxis}];
figure('Name', figname, 'Color', 'white', 'Position', [100 100 1024 1024])
%bead clusters to plot
scatter3(ratios(:,plotAxes(1)), ratios(:,plotAxes(2)), ratios(:,plotAxes(3)), 9, colors, 'filled')
axis equal
xlabel(axisLabels{plotAxes(1)})
ylabel(axisLabels{plotAxes(2)})
zlabel(axisLabels{plotAxes(3)})
if colorByMeasure
    colormap(jet);
    caxis([min(colors), max(colors)]);
end
end