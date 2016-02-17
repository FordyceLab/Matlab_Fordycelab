%Gaussian mixture model
temp = beads_M0130df_all.getTransformedCodeRatio(M0130df_goodAF_list);
[Idx, M0130df_all_mean] = kmeans(temp,[],'start',k);
GMM = gmdistribution.fit(temp, 24, 'Start', Idx);
theta = 2*pi*(0:0.01:1);
[x,y] = pol2cart(theta,1);
unitcircle=[x;y];

bins = -0.1:0.01:1.2;

%making figure 5 for the paper
figure(3)
clf
%scatter plot
ax1 = axes('Position', [0.2 0.2 0.7 0.7])
%plot(x_all(M0130_centerbeads,1), x_all(M0130_centerbeads,2), '.k')
%fancy coloring
hold on

%draw sigma contours - along axes
% for nsigma = 3:4;
%     for n=1:size(M0130df_all_mean,1)
%         C = M0130df_all_mean(n,:) - nsigma*M0130df_all_std(n,:);
%         rectangle('Position', [C(1) C(2) 2*nsigma*M0130df_all_std(n,1) 2*nsigma*M0130df_all_std(n,2)], 'Curvature', [1 1],'EdgeColor',[0.5 0.5 0.5])
%     end
% end

%with covariance, from GMM
for nsigma = 3:4
    for n=1:size(M0130df_all_mean,1)
        L=chol(GMM.Sigma(:,:,n),'lower');
        C=(nsigma*L*unitcircle) + repmat(GMM.mu(n,:)', [1 size(unitcircle,2)]);
        plot(C(1,:),C(2,:),'Color',[0.5 0.5 0.5])
    end
end

for n=1:size(temp,1)
    C = [temp(n,2) 0 temp(n,1)];
    C = max(C,0);
    C = min(C,1);
    plot(temp(n,1), temp(n,2), '.', 'MarkerEdgeColor', C)
end



xlim([-0.1 1.2]);
ylim([-0.1 1.2]);
set(gca, 'XTickLabel',[],'YTickLabel',[], 'DataAspectRatio', [1 1 1], 'Box', 'on');% 'DataAspectRatioMode', 'manual', 'PlotBoxAspectRatioMode', 'manual');

%bottom histogram
ax2 = axes('Position', [0.2 0.1 0.7 0.1])
[Y,X] = hist(temp(:,1), bins);
bar(X,Y,'k')
hold on
sixgauss = @(x) x(13)*normpdf(X,x(1),x(7)) + x(14)*normpdf(X,x(2),x(8)) + x(15)*normpdf(X,x(3),x(9)) + x(16)*normpdf(X,x(4),x(10)) + x(17)*normpdf(X,x(5),x(11)) + x(18)*normpdf(X,x(6),x(12));
sixgauss_err = @(x) sum((Y-sixgauss(x)).^2);
gauss_params = fminsearch(sixgauss_err,[0 0.12 .27 .46 .7 0.97 .01 .01 .02 .02 .02 .03 5 4 4 3 2 1])
gauss_params = fminsearch(sixgauss_err, gauss_params)
plot(X, sixgauss(gauss_params),'r')
set(gca,'YDir','reverse','YTickLabel',[]);
xlim([-0.1 1.2]);
xlabel('Dy/Eu ratio')

figure(4)
clf
plot(gauss_params(1:6),gauss_params(7:12),'bo')
hold on
xlabel('Mean ratio');ylabel('Distribution width')
figure(3)
%side histogram
ax3 = axes('Position', [0.1 0.2 0.1 0.7])
[Y,X] = hist(temp(:,2), bins);
barh(X,Y,'k')
hold on
sixgauss = @(x) x(13)*normpdf(X,x(1),x(7)) + x(14)*normpdf(X,x(2),x(8)) + x(15)*normpdf(X,x(3),x(9)) + x(16)*normpdf(X,x(4),x(10)) + x(17)*normpdf(X,x(5),x(11)) + x(18)*normpdf(X,x(6),x(12));
sixgauss_err = @(x) sum((Y-sixgauss(x)).^2);
gauss_params = fminsearch(sixgauss_err,[0 0.12 .27 .46 .7 1 .01 .01 .02 .02 .03 .04 5 4 4 3 2 1])
gauss_params = fminsearch(sixgauss_err, gauss_params)
plot(sixgauss(gauss_params), X,'r')
set(gca,'XDir','reverse','XTickLabel',[]);
ylim([-0.1 1.2]);
ylabel('Sm/Eu ratio')
figure(4)
plot(gauss_params(1:6),gauss_params(7:12),'ro')

figure(3)
%linkaxes([ax1, ax2, ax3]);

%add in statistical error
figure(4)
plot((M0130_replicate_mean_Dy+M0109_replicate_mean_Dy)/2, (M0130_replicate_std_Sm+M0109_replicate_std_Dy)/2, 'sb')
plot((M0130_replicate_mean_Sm+M0109_replicate_mean_Sm)/2, (M0130_replicate_std_Sm+M0109_replicate_std_Sm)/2, 'sr')
xlim([-0.1 1.2]);
ylim auto

%inset
figure(5)
clf
plot(k(:,1), k(:,2), 'b.')
hold on
plot(M0130dfx_all_mean(:,1), M0130dfx_all_mean(:,2), 'r.')
xlim([-0.05 1.05]);
ylim([-0.05 1.05]);
set(gca, 'XTick',[0 0.5 1.0], 'YTick',[0 0.5 1.0])
axis square



