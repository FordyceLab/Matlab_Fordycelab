[Idx, M0130dfx_all_mean] = kmeans(temp,[],'start',k);
temp=beads_M0130df_all.getCodeRatio(M0130df_goodAF_list);
GMM = gmdistribution.fit(temp, 24, 'Start', Idx);
S.Sigma = GMM.Sigma;
S.mu = GMM.mu;
S.PComponents = GMM.PComponents;

[trueidx,nlogL,P]=GMM.cluster(temp);

highP=[];
nexthighP=[];
nCV = 10;
CVset = cvpartition(numel(M0130df_goodAF_list),'kfold',nCV);
for n = 1: nCV
    %cross-validation
    train = CVset.training(n);
    test = CVset.test(n);
    GMMtrain = gmdistribution.fit(temp(train,:), 24, 'Start', S);
    [idx,nlogL,P]=GMMtrain.cluster(temp(test,:));
    P= sort(P,2,'descend');
    highP = [highP; P(:,1)];
    nexthighP = [nexthighP; P(:,2)];
    if any(idx ~= trueidx(test))
        disp('Miscall!')
    end
end

%sanity check
randpts = rand(size(temp));
[idx,nlogL,P]=GMM.cluster(randpts);
P= sort(P,2,'descend');

%calculating Nsigmas
[idx,nlogL,P]=GMM.cluster(temp);
for n = 1:size(idx,1)
    cluster = idx(n);
    L=chol(GMM.Sigma(:,:,cluster),'lower');
    nsigmas(n) = norm(inv(L) * (temp(n,:) - GMM.mu(cluster,:))');
end