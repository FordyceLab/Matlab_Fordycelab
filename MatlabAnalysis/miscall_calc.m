% for n=1:20
%     fxn_miscalled_5(n)=prod(size(find(err(:,n,:)>0.05)))/prod(size(err(:,n,:)));
% end

clear fxn_miscalled_5
clear fxn_miscalled
for q=1:6
    subplot(2,3,q)
    for s=1:20
        fxn_miscalled(s,q)=numel(find(err(q,10,:)>s/100))/numel(err(q,10,:));
    end
    plot((3:20)/100,fxn_miscalled(3:20,q))
end