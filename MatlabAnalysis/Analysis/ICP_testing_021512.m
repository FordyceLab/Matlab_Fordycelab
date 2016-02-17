%testing whether ICP produces a significant improvement in CV by performing
%ICP on random subsamples of the data


temp = M0130_all_x;
[Idx, NoICP_mean] = kmeans(temp,[],'start',k);
clear NoICP_std
for n=1:size(NoICP_mean,1)
    list = Idx == n;
    NoICP_std(n,:)= std(temp(list,:),0,1);
end

temp = x_all;
[Idx, ICP_mean] = kmeans(temp,[],'start',k);
clear ICP_std
for n=1:size(ICP_mean,1)
    list = Idx == n;
    ICP_std(n,:)= std(temp(list,:),0,1);
end

for rep=1:100
    %now split data into 10 random subsets, run ICP on each
    c = cvpartition(size(M0130_all_x,1),'kfold',10);
    resampled = [];
    for part = 1:10
        subsample = M0130_all_x(test(c,part),:);
        q = ICP(subsample, target);
        resampled=[resampled;subsample*q];
    end
    
    temp = resampled;
    [Idx, Resamp_mean] = kmeans(temp,[],'start',k);
    clear Resamp_std
    for n=1:size(Resamp_mean,1)
        list = Idx == n;
        Resamp_std(n,:)= std(temp(list,:),0,1);
    end
    Resamp_mean_all(:,:,rep) = Resamp_mean;
    Resamp_std_all(:,:,rep) = Resamp_std;
end