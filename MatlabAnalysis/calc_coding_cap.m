%calculate standard deviation for each code intensity as a function of
%photon level
nstds=3;
std_err=std(err,[],3);
nlevels=1./(std_err*nstds); %number of distinguishable levels for each channel
codes=prod(max(floor(nlevels),1),1); %initial coding capacity estimate

%now estimate coding capactity based on having a miscall rate equal to 10x
%the code space - i.e. for 100 codes, miscall rate would be 1/1000.

for n=1:20
    delta_nstds=6;
    while (delta_nstds>0.15)
        allowable_error=1/(codes(n)*10);
        q=norminv([0.5 1-allowable_error/2],0,1);
        delta_nstds=abs(nstds-q(2));
        nstds=mean([nstds,q(2)]);
        nlevels(:,n)=1./(std_err(:,n)*nstds); %number of distinguishable levels for each channel
        codes(:,n)=prod(max(floor(nlevels(:,n)),1),1); %initial coding capacity estimate\
        if codes(:,n) == 0
            break;
        end
    end
end