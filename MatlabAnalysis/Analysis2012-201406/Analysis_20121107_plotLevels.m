level1 = [];
level2 = [];
level3 = [];
level4 = [];
level5 = [];
level6 = [];

for ii=1:8
    for jj=1:beads_M1105_1_struct{ii}.NumBeads
        if beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)) < 0.05
            level1 = [level1 beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm))];
        elseif   beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)) < 0.2
            level2 = [level2 beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm))];
        elseif   beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)) < 0.3
            level3 = [level3 beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm))];
        elseif   beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)) < 0.55
            level4 = [level4 beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm))];
        elseif   beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)) < 0.7
            level5 = [level5 beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm))];
        else
            level6 = [level6 beads_M1105_1_struct{ii}.getRatio(jj,lanthanideChannels.Tm)/max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm))];
        end
    end
end

levels = {level1; level2; level3; level4; level5; level6};
for ii=1:6
    levels{ii,2} = std(levels{ii,1});
end

for ii=1:6
    levels{ii,3} = median(levels{ii,1});
end


hold on
colors = [];
figure
for ii=1:beads_M1105_1_struct{1}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{1}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{1}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii,beads_M1105_1_struct{1}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end

for ii=1:beads_M1105_1_struct{2}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{2}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{2}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36,beads_M1105_1_struct{2}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{2}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end

for ii=1:beads_M1105_1_struct{3}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{3}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{3}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35,beads_M1105_1_struct{3}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{3}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end


for ii=1:beads_M1105_1_struct{4}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{4}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{4}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16,beads_M1105_1_struct{4}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{4}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end

for ii=1:beads_M1105_1_struct{5}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{5}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{5}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15,beads_M1105_1_struct{5}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{5}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end

for ii=1:beads_M1105_1_struct{6}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{6}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{6}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27,beads_M1105_1_struct{6}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{6}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end

for ii=1:beads_M1105_1_struct{7}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{7}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{7}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27+30,beads_M1105_1_struct{7}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{7}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end

for ii=1:beads_M1105_1_struct{8}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{8}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{8}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27+30+24,beads_M1105_1_struct{8}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{8}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid])
    hold on
end
        
plot(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)./max(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)),'.','color', {colors})
index = beads_M1105_1_struct{1}.NumBeads +1;
for ii=2:8
%     [beads_M1105_1_struct{ii-1}.NumBeads + 1:beads_M1105_1_struct{ii-1}.NumBeads + beads_M1105_1_struct{ii}.NumBeads]
    plot(index:index + beads_M1105_1_struct{ii}.NumBeads-1,beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)./max(beads_M1105_1_struct{ii}.getRatio(:,lanthanideChannels.Tm)),'.')
    index = index + beads_M1105_1_struct{ii}.NumBeads;
end

%%

figure
for ii=1:beads_M1105_1_struct{1}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{1}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{1}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii,beads_M1105_1_struct{1}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{2}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{2}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{2}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36,beads_M1105_1_struct{2}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{2}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{3}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{3}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{3}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35,beads_M1105_1_struct{3}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{3}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end


for ii=1:beads_M1105_1_struct{4}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{4}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{4}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16,beads_M1105_1_struct{4}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{4}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{5}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{5}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{5}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15,beads_M1105_1_struct{5}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{5}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{6}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{6}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{6}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27,beads_M1105_1_struct{6}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{6}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{7}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{7}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{7}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27+30,beads_M1105_1_struct{7}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{7}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{8}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{8}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{8}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27+30+24,beads_M1105_1_struct{8}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{8}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [relCentroid relCentroid relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end


%%

figure
for ii=1:beads_M1105_1_struct{1}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{1}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{1}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii,beads_M1105_1_struct{1}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{2}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{2}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{2}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36,beads_M1105_1_struct{2}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{2}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{3}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{3}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{3}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35,beads_M1105_1_struct{3}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{3}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end


for ii=1:beads_M1105_1_struct{4}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{4}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{4}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16,beads_M1105_1_struct{4}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{4}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{5}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{5}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{5}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15,beads_M1105_1_struct{5}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{5}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{6}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{6}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{6}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27,beads_M1105_1_struct{6}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{6}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{7}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{7}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{7}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27+30,beads_M1105_1_struct{7}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{7}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

for ii=1:beads_M1105_1_struct{8}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{8}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{8}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
%     colors{ii} = [relCentroid*255 relCentroid*255 relCentroid*255];
    plot(ii+36+35+16+15+27+30+24,beads_M1105_1_struct{8}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{8}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', [1-relCentroid 1-relCentroid 1-relCentroid],'Markersize',30/(relCentroid*10))
    hold on
end

%%

figure
for ii=1:beads_M1105_1_struct{1}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{1}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{1}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii,beads_M1105_1_struct{1}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'b')
    text(ii,beads_M1105_1_struct{1}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{1}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1105_1_struct{2}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{2}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{2}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+36,beads_M1105_1_struct{2}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{2}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'g')
    text(ii+36,beads_M1105_1_struct{2}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{2}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1105_1_struct{3}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{3}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{3}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+36+35,beads_M1105_1_struct{3}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{3}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'b')
    text(ii+36+35,beads_M1105_1_struct{3}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{3}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end


for ii=1:beads_M1105_1_struct{4}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{4}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{4}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+36+35+16,beads_M1105_1_struct{4}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{4}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'g')
    text(ii+36+35+16,beads_M1105_1_struct{4}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{4}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1105_1_struct{5}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{5}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{5}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+36+35+16+15,beads_M1105_1_struct{5}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{5}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'b')
    text(ii+36+35+16+15,beads_M1105_1_struct{5}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{5}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1105_1_struct{6}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{6}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{6}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+36+35+16+15+27,beads_M1105_1_struct{6}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{6}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'g')
    text(ii+36+35+16+15+27,beads_M1105_1_struct{6}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{6}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1105_1_struct{7}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{7}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{7}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+36+35+16+15+27+30,beads_M1105_1_struct{7}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{7}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'b')
    text(ii+36+35+16+15+27+30,beads_M1105_1_struct{7}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{7}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end

for ii=1:beads_M1105_1_struct{8}.NumBeads
    relCentroid = sqrt((beads_M1105_1_struct{8}.Centroid(ii,1)-226)^2 + (beads_M1105_1_struct{8}.Centroid(ii,2)-226)^2);
    relCentroid = relCentroid/250;
    plot(ii+36+35+16+15+27+30+24,beads_M1105_1_struct{8}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{8}.getRatio(:,lanthanideChannels.Tm)),'.', 'color', 'g')
    text(ii+36+35+16+15+27+30+24,beads_M1105_1_struct{8}.getRatio(ii,lanthanideChannels.Tm)./max(beads_M1105_1_struct{8}.getRatio(:,lanthanideChannels.Tm)),num2str(ii), 'color', 'r')
    hold on
end
