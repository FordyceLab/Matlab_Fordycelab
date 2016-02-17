%Sm range 1:20, 45:50
%Dy range 1:3, 11:21, 30:50
%Er range 1:13, 28:50
%Eu range 1:25, 43:50
%Ho range 1:13, 28:38, 46:50
%Tm range 11:37

clf
YVO4_mean=mean(YVO4_bkgd,2);
YVO4_mean_temp=[YVO4_mean(11:37)];
for n=1:20
    Tm_temp=[Tm_bkgd(11:37,n)];
    bkgd_fit=Tm_temp\YVO4_mean_temp;
    subplot(4,5,n)
    plot(Tm_bkgd(:,n),'b')
    hold on
    plot(YVO4_mean/bkgd_fit,'r')
end
Tm_sub=Tm_bkgd-repmat(YVO4_mean/bkgd_fit,[1 size(Tm,2)]);