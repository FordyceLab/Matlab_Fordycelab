%Generate synthetic bead spectra by summing of reference spectra
%spectra=[YVO4_norm,Dy_norm,Er_norm,Eu_norm,Ho_norm,Sm_norm,Tm_norm];
%weights=[1;0.55;0.203;0.384;0.136;1.06;0.236];  %relative intensity of each dye
spectra=[Dy_norm,Er_norm,Eu_norm,Ho_norm,Sm_norm,Tm_norm];
weights=[0.55;0.203;0.384;0.136;1.06;0.236];  %relative intensity of each dye

weights=weights/mean(weights); %normalize so mean = 1

%total number of photons from each dye in all channels at 100% doping

read_noise=10;
ntests=20000;
photonlevels=logspace(3,5,20);
err=zeros([size(spectra,2) size(photonlevels,2) ntests]);
for p=1:size(photonlevels,2)
    nphotons=photonlevels(p)
    for n=1:ntests
        %doping level for each dye, random from 0% - 100% in 11% steps
        levels=(randi(10,[6 1])-1)/9;
        levels=levels.*weights; %weight by brightness
        
        %generate test spectrum - sum of each spectrum x it's abundance x nphotons
        %plus appropriate noise
        test_spectrum=zeros([size(spectra,1) 1]);
        for s=1:size(weights)
            temp_spectrum=spectra(:,s)*levels(s)*nphotons;
            test_spectrum=test_spectrum + temp_spectrum + sqrt(temp_spectrum) .* randn(size(temp_spectrum));
        end
        
        %add read noise
        noise_spec=test_spectrum + read_noise*randn(size(test_spectrum));
        
        %least-squares fit
        fit_levels=spectra\noise_spec;
        fit_levels=fit_levels/nphotons;
        
        %deweight levels and fit_levels so error is on a 0 - 1 scale.
        fit_levels=fit_levels./weights;
        levels=levels./weights;
        err(:,p,n)=levels-fit_levels;
    end
end

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
    while (delta_nstds>0.2)
        allowable_error=1/(codes(n)*10);
        q=norminv([0.5 1-allowable_error/2],0,1);
        delta_nstds=abs(nstds-q(2))
        nstds=mean([nstds,q(2)]);
        nlevels(:,n)=1./(std_err(:,n)*nstds); %number of distinguishable levels for each channel
        codes(:,n)=prod(max(floor(nlevels(:,n)),1),1); %initial coding capacity estimate\
        if codes(:,n) == 0
            break;
        end
    end
end