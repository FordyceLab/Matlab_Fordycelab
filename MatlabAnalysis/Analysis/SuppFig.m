%versions of Supplemental figure comparing 1/9 and 1/30 bead sets

%scatter plots
figure(1); clf
centerbeadeads_ = find(all(beads_M0109.Centroid>100,2) & all(beads_M0109.Centroid<400,2));
plot(beads_M0109.getTransformedCodeRatio(centerbeads,lanthanideChannels.Dy),beads_M0109.getTransformedCodeRatio(centerbeads,lanthanideChannels.Sm),'r.')
hold on
temp = beads_M0130df_all.getTransformedCodeRatio(M0130df_goodAF_list);
plot(temp(:,1),temp(:,2),'b.');
xlabel('Dy/Eu ratio'); ylabel('Sm/Eu ratio')
xlim([-0.1 1.2]);
ylim([-0.1 1.2]);

%centroids plus error ellipses
theta = 2*pi*(0:0.01:1);
[x,y] = pol2cart(theta,1);
unitcircle=[x;y];

figure(2); clf
plot(k(:,1), k(:,2),'k.');
hold on
temp = beads_M0130df_all.getTransformedCodeRatio(M0130df_goodAF_list);
[Idx, M0130df_all_mean] = kmeans(temp,[],'start',k);
plot(M0130df_all_mean(:,1), M0130df_all_mean(:,2),'c.');
GMM_0130 = gmdistribution.fit(temp, 24, 'Start', Idx);
nsigma = 3;
for n=1:size(M0130df_all_mean,1)
    L=chol(GMM_0130.Sigma(:,:,n),'lower');
    C=(nsigma*L*unitcircle) + repmat(GMM_0130.mu(n,:)', [1 size(unitcircle,2)]);
    plot(C(1,:),C(2,:),'Color',[0.5 1 1])
end


centerbeadeads = find(all(beads_M0109.Centroid>100,2) & all(beads_M0109.Centroid<400,2));
temp = beads_M0109.getTransformedCodeRatio(centerbeads);
[Idx, M0109_all_mean] = kmeans(temp,[],'start',k23);
plot(M0109_all_mean(:,1), M0109_all_mean(:,2),'r.');
GMM_0109 = gmdistribution.fit(temp, 23, 'Start', Idx);
nsigma = 3;
for n=1:size(M0109_all_mean,1)
    L=chol(GMM_0109.Sigma(:,:,n),'lower');
    C=(nsigma*L*unitcircle) + repmat(GMM_0109.mu(n,:)', [1 size(unitcircle,2)]);
    plot(C(1,:),C(2,:),'Color',[1 0 0])
end
xlabel('Dy/Eu ratio'); ylabel('Sm/Eu ratio')
xlim([-0.1 1.2]);
ylim([-0.1 1.2]);