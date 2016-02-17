%Generate synthetic bead spectra by summing of reference spectra
%spectra=[YVO4_norm,Dy_norm,Er_norm,Eu_norm,Ho_norm,Sm_norm,Tm_norm];
%weights=[1;0.55;0.203;0.384;0.136;1.06;0.236];  %relative intensity of each dye
init_spectra=[Dy_norm,Er_norm,Eu_norm,Ho_norm,Sm_norm,Tm_norm];
weights=[0.55;0.203;0.384;0.136;1.06;0.236];  %relative intensity of each dye

weights=weights/mean(weights); %normalize so mean = 1

%total number of photons from each dye in all channels at 100% doping

%test different spectral acquisition bands for performance
%idea: combine two bins together, see if # of miscalls goes up too high
%if not, combine two more bins, if so, report current bin pattern and try
%again

%do at constant 10k photon level
errorrate=0.05;
clear sol_size boundary_set
for run=1:100
    spectra=init_spectra;
    bins_combined=[];
    max_miscalls=0;
    while max_miscalls < errorrate
        
        bin=randi(size(spectra,1)-1);
        spectra=[spectra(1:bin-1,:);spectra(bin,:)+spectra(bin+1,:);spectra(bin+2:end,:)];
        bins_combined=[bins_combined,bin];
        read_noise=10;
        ntests=5000;
        err=zeros([size(spectra,2) ntests]);
        nphotons=10000;
        for n=1:ntests
            %doping level for each dye, random from 0% - 100% in 11% steps
            levels=(randi(10,[6 1])-1)/9;
            levels=levels.*weights; %weight by brightness
            
            %generate test spectrum - sum of each spectrum x it's abundance x nphotons
            test_spectrum=spectra*levels*nphotons;
            
            %add photon shot noise and read noise
            noise_spec=test_spectrum + sqrt(test_spectrum) .* randn(size(test_spectrum)) + read_noise*randn(size(test_spectrum));
            
            %least-squares fit
            fit_levels=spectra\noise_spec;
            err(:,n)=abs(levels-(fit_levels/nphotons));
        end
        
        
        clear fxn_miscalled
        for q=1:6
            fxn_miscalled(q)=numel(find(err(q,:)>errorrate))/numel(err(q,:));
        end
        max_miscalls=max(fxn_miscalled);
    end
    
    final_bound=boundary;
    for n=1:size(bins_combined,2)-1
        final_bound=[final_bound(1:bins_combined(n)),final_bound(bins_combined(n)+2:end)];
    end
    size(spectra,1)+1
    sol_size(run)=size(spectra,1)+1;
    boundary_set{run}=final_bound;
end        