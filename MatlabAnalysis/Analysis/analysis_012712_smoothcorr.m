M0109_acc = Bead_accumulate([], I_M0109_1);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_2);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_3);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_4);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_5);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_6);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_7);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_8);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_9);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_10);
M0109_acc = Bead_accumulate(M0109_acc, I_M0109_11);

%initial values for k-means clustering
vals = [0, 0.12, 0.27, 0.46, 0.70, 1];
valsx = vals*1.3;
valsy = vals*1.5;
clear k24
index=1;
for n=1:numel(valsx)
    for m=1:numel(valsx)-n+1
        k24(index,:)=[valsx(n); valsy(m)];
        index=index+1;
    end
end
%then delete [0.91,0], add [0.351 1.055], [0.598 0.69], and [0.91 0.405]
[Idx, M0109_all_mean] = kmeans([M0109_acc.DyEu; M0109_acc.SmEu]',[],'start',k24);
clear M0109_all_std
for n=1:size(M0109_all_mean,1)
    list = Idx == n;
    M0109_all_std(n,1)= std(M0109_acc.DyEu(list),0,2);
    M0109_all_std(n,2)= std(M0109_acc.SmEu(list),0,2);
end

%now do smoothed ratio correction

for n=1:size(PT_test,2)
    testerror = testerror + sqrt(sum((PT_test(:,n) - PT_all_mean(PT_test_idx(n),:)').^2));
end
disp(['mean starting error ', sprintf('%f',testerror/ntest)])

%loop over smoothing values
for t=1:numel(taus)
    tau = taus(t);
    %predict offsets
    Dyoff = lwsmooth_nd(PT_training_abs_cent',PT_training_abs(1,:)', PT_test_cent', tau);
    Euoff = lwsmooth_nd(PT_training_abs_cent',PT_training_abs(2,:)', PT_test_cent', tau);
    for n=1:size(PT_test,2)
        adj_val = PT_test(:,n) - [Dyoff(n); Euoff(n)];
        testerror_abs(t) = testerror_abs(t) + sqrt(sum((adj_val - PT_all_mean(PT_test_idx(n),:)').^2));
    end
    %disp(['tau = ', sprintf('%d', tau), 'mean error ', sprintf('%f',testerror/ntest)])
end