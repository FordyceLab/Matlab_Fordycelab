postest=[];
for x = 0:10:500
    for y = 0:10:500
        postest=[postest;[x,y]];
    end
end

subplot(1,2,1)
npts = sqrt(size(postest,1));
newY = lwsmooth_nd(PT_centroid',PT_all_delta(1,:)', postest, 35);
surf(reshape(postest(:,1),[npts npts]), reshape(postest(:,2),[npts npts]), reshape(newY,[npts npts]))
xlabel('X');ylabel('Y');title('Dy error')

subplot(1,2,2);

newY = lwsmooth_nd(PT_centroid',PT_all_delta(2,:)', postest, 35);
surf(reshape(postest(:,1),[npts npts]), reshape(postest(:,2),[npts npts]), reshape(newY,[npts npts]))
xlabel('X');ylabel('Y');title('Sm error');

Dyoff = lwsmooth_nd(PT_centroid',PT_all_delta(1,:)', PT_centroid', 50);
Euoff = lwsmooth_nd(PT_centroid',PT_all_delta(2,:)', PT_centroid', 50);
plot(PT_all(1,:),PT_all(2,:),'.');
hold on
plot(PT_all(1,:)-Dyoff', PT_all(2,:)-Euoff','r.');

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

Dyoff = lwsmooth_nd(PT_select_centroid',PT_all_delta_frac(1,:)', PT_centroid', 50);
Euoff = lwsmooth_nd(PT_select_centroid',PT_all_delta_frac(2,:)', PT_centroid', 50);
figure
plot(PT_all(1,:),PT_all(2,:),'.');
hold on
plot(PT_all(1,:)-Dyoff'.*PT_all(1,:), PT_all(2,:)-Euoff'.*PT_all(2,:),'r.');
