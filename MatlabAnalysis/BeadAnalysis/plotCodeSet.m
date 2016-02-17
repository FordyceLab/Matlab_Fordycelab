function plotCodeSet(ratios, target, idx, sliceAxis, colorAxis, colorByMeasure, subsample, swapAxes)
%plotCodeSet: Plot an encoded bead set in 2D in multiple panels
%   Plots an econded bead set in 2D, with a 3rd axis sliced into multiple
%   panels by target values, and a 4th axis plotted as a color
%   Inputs:
%   ratios: the measured lanthanide ratios for the codeset; nbeads x 4 array
%   target: the target lanthanide ratios for the codeset; ncodes x 4 array
%   idx: the index in target of each bead; nbeads x 1 array
%   sliceAxis: which axis to use for slicing into subplots; integer 1 - 4
%   colorAxis: which axis to use as the color code; integer 1 - 4
%   colorByMeasure: True to color 4th axis by the measured ratio; False to
%                   color by the target ratio of that code
%   subsample: Plots only every nth bead; set to 1 to plot all beads
%   swapAxes: Swaps X and Y axes if True

if sliceAxis == colorAxis
    error('sliceAxis and colorAxis must be different');
end

samples = 1:subsample:size(ratios,1);
ratios = (ratios(samples,:));
idx = idx(samples,:);
nAxes = size(target,2);

plotAxes = setdiff(1:nAxes,[sliceAxis, colorAxis]);
if swapAxes
    plotAxes = fliplr(plotAxes);
end
axisLabels ={'CeTb', 'Dy', 'Sm', 'Tm'};
for n=1:nAxes
    uniqueLevels{n} = unique(target(:,n));
end

sliceLevels = uniqueLevels{sliceAxis};
nSlices = numel(sliceLevels);
colorLevels = uniqueLevels{colorAxis};
nColors = numel(colorLevels);
cmap = colormap(parula(nColors));
%cmap = distinguishable_colors(nColors);

figure('Name', 'colorbar')
coloraxes = gca(); %create a new figure to put the colorbar in
figname = ['X-Axis ', axisLabels{plotAxes(1)}, '; Y-Axis ', axisLabels{plotAxes(2)}, '; Colors ', axisLabels{colorAxis}];
figure('Name', figname)


xsubplot = round(sqrt(nSlices));
ysubplot = ceil(nSlices/xsubplot);
for s=1:nSlices
    subplot(xsubplot, ysubplot,s)
    if ~colorByMeasure
        %bead clusters to plot
        for c=1:nColors
            cidx = find(target(:,sliceAxis) == sliceLevels(s) & target(:,colorAxis) == colorLevels(c));
            b=[];
            for n=1:numel(cidx)
                b = [b; find(idx == cidx(n))];
            end
            plot(ratios(b,plotAxes(1)), ratios(b,plotAxes(2)),'LineStyle', 'None', 'Marker','.', 'MarkerFaceColor', cmap(c,:), 'Color', cmap(c,:))
            hold on
        end
    else
        cidx = find(target(:,sliceAxis) == sliceLevels(s));
        b=[];
        for n=1:numel(cidx)
            b = [b; find(idx == cidx(n))];
        end
        b = randsample(b, numel(b)); %reorder b so that points of different colors are plotted at different times. This way not all points of one code end up at the bottom of the plot.
        scatter(ratios(b,plotAxes(1)), ratios(b,plotAxes(2)), 4, ratios(b, colorAxis),'filled')
        hold on
        colormap(jet);
        caxis([min(ratios(:,colorAxis)), max(ratios(:,colorAxis))]);
    end
    axis tight
    title([axisLabels{sliceAxis}, ' = ', sprintf('%3.3f', sliceLevels(s))]);
    %make all plots have the same axes as the first
    if s==1
        axlim = axis;
        axlim = axlim + [-0.01 0.01 -0.01 0.01]; %pad for future plots
        axis(axlim);
        ax1 = gca;
    else
        axis(axlim);
        h = gca;
        h.XTick = ax1.XTick;
        h.YTick = ax1.YTick;
        h.XTickLabel = ax1.XTickLabel;
        h.YTickLabel = ax1.YTickLabel;
    end
end
colormap(coloraxes, cmap)
colorbar(coloraxes, 'TickLabels', colorLevels, 'Ticks',(0:nColors-1)/(nColors-1))

end