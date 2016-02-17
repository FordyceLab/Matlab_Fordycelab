%Generate synthetic bead spectra by summing of reference spectra
%spectra=[YVO4_norm,Dy_norm,Er_norm,Eu_norm,Ho_norm,Sm_norm,Tm_norm];
%weights=[1;0.55;0.203;0.384;0.136;1.06;0.236];  %relative intensity of each dye
init_spectra=[Dy_norm,Er_norm,Eu_norm,Ho_norm,Sm_norm,Tm_norm];
weights=[0.55;0.203;0.384;0.136;1.06;0.236];  %relative intensity of each dye

weights=weights/mean(weights); %normalize so mean = 1

%total number of photons from each dye in all channels at 100% doping

%test different spectral acquisition bands for performance
%combine adjacent bins together and measure error rate relative to all 50
%bins; do for each pair of bins to see which bins are most informative.
%do at constant 10k photon level
read_noise=10;
nphotons=10000;
ntests=50000;
errorrate=0.05;

spectra=init_spectra;
%Do test with all bins
for q=1:50
    err=zeros([size(spectra,2) ntests]);
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
    
    %calculate number of miscalls
    %we're using 10% doping levels, so a code is miscalled if the error for any peak >
    %5%
    
    miscalls = squeeze(any(err>errorrate,1));
    fxn_miscalled_orig(q) = numel(find(miscalls))/numel(miscalls);
end

clear sol_size boundary_set
for bin=1:49
    spectra=init_spectra;
    max_miscalls=0;
    
    spectra=[spectra(1:bin-1,:);spectra(bin,:)+spectra(bin+1,:);spectra(bin+2:end,:)];
    
    err=zeros([size(spectra,2) ntests]);
    
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
    
    miscalls = squeeze(any(err>errorrate,1));
    fxn_miscalled_bin(bin) = numel(find(miscalls))/numel(miscalls);
end