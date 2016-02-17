%partition PT_all data into test set and training set to find optimal
%smoothing parameter and whether absolute or fractional offsets work
%better

[Idx, PT_all_mean] = kmeans(PT_all',[],'start',k18);
clear PT_all_std
for n=1:size(PT_all_mean,1)
    list = Idx == n;
    PT_all_std(n,:)= std(PT_all(:,list),0,2);
end
clear PT_all_delta_frac PT_select_centroid
index=1;
for n=1:size(PT_all,2)
    if all(PT_all(:,n)>0.1)
        PT_all_delta_frac(:,index)= (PT_all(:,n) - PT_all_mean(Idx(n),:)')./PT_all_mean(Idx(n),:)';
        PT_select_centroid(:,index) = PT_centroid(:,n);
        index=index+1;
    end
end
PT_Idx = Idx;

testerror = 0;
taus=10:5:50;
testerror_abs = zeros(size(taus));
for iters =1:10
    %select test set of 200 points
    %first, absolute deviates
    ndata = size(PT_all,2);
    ntest=200;
    testvals = randsample(ndata, ntest);
    PT_test = PT_all(:,testvals);
    PT_test_idx = PT_Idx(testvals);
    PT_test_cent = PT_centroid(:,testvals);
    PT_training_abs = PT_all_delta;
    PT_training_abs(:,testvals)=[];
    PT_training_abs_cent = PT_centroid;
    PT_training_abs_cent(:,testvals)=[];
    
    %starting delta
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
end

%now, fractional errors
testerror = 0;
taus=10:5:50;
testerror_frac = zeros(size(taus));
for iters =1:10
    testvals = randsample(ndata, ntest);
    PT_test = PT_all(:,testvals);
    PT_test_cent = PT_centroid(:,testvals);
    PT_training = PT_all;
    PT_training(:,testvals)=[];
    PT_test_idx = PT_Idx(testvals);
    PT_training_idx = PT_Idx;
    PT_training_idx(testvals)=[];
    PT_training_frac_cent = PT_centroid;
    PT_training_frac_cent(:,testvals)=[];
    
    clear PT_training_frac PT_select_centroid
    index=1;
    for n=1:size(PT_training,2)
        if all(PT_training(:,n)>0.1)
            PT_training_frac(:,index)= (PT_training(:,n) - PT_all_mean(PT_training_idx(n),:)')./PT_all_mean(PT_training_idx(n),:)';
            PT_select_centroid(:,index) = PT_training_frac_cent(:,n);
            index=index+1;
        end
    end
    %starting delta
    for n=1:size(PT_test,2)
        testerror = testerror + sqrt(sum((PT_test(:,n) - PT_all_mean(PT_test_idx(n),:)').^2));
    end
    disp(['mean starting error ', sprintf('%f',testerror/ntest)])
    
    %loop over smoothing values
    for t=1:numel(taus)
        tau = taus(t);
        %predict offsets
        Dyoff = lwsmooth_nd(PT_select_centroid',PT_training_frac(1,:)', PT_test_cent', tau);
        Euoff = lwsmooth_nd(PT_select_centroid',PT_training_frac(2,:)', PT_test_cent', tau);
        for n=1:size(PT_test,2)
            adj_val = PT_test(:,n) - [Dyoff(n).*PT_test(1,n); Euoff(n).*PT_test(2,n)];
            testerror_frac(t) = testerror_frac(t) + sqrt(sum((adj_val - PT_all_mean(PT_test_idx(n),:)').^2));
        end
        %disp(['tau = ', sprintf('%d', tau), 'mean error ', sprintf('%f',testerror/ntest)])
    end
end

Dyoff = lwsmooth_nd(PT_select_centroid',PT_all_delta_frac(1,:)', PT_centroid', 50);
Euoff = lwsmooth_nd(PT_select_centroid',PT_all_delta_frac(2,:)', PT_centroid', 50);
figure
plot(PT_all(1,:),PT_all(2,:),'.');
hold on
plot(PT_all(1,:)-Dyoff'.*PT_all(1,:), PT_all(2,:)-Euoff'.*PT_all(2,:),'r.');



figure
plot(PT_all(1,:),PT_all(2,:),'.');
hold on
plot(PT_all(1,:)-Dyoff'.*PT_all(1,:), PT_all(2,:)-Euoff'.*PT_all(2,:),'r.');




Dyoff = lwsmooth_nd(PT_centroid',PT_all_delta(1,:)', PT_centroid', 50);
Euoff = lwsmooth_nd(PT_centroid',PT_all_delta(2,:)', PT_centroid', 50);
plot(PT_all(1,:),PT_all(2,:),'.');
hold on
plot(PT_all(1,:)-Dyoff', PT_all(2,:)-Euoff','r.');