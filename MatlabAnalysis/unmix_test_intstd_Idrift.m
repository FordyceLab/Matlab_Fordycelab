%Generate synthetic bead spectra by summing of reference spectra

spectra=[dy_norm,er_norm,eu_norm,sm_norm,tm_norm,ho_norm];
nspec=size(spectra,2);
ntests=20000;
errorlevels=logspace(-2,-0.5,20);

%which lanthanide to use as internal standard.
int_std=1;

err=zeros([size(spectra,2) size(errorlevels,2) ntests]);
for p=1:size(errorlevels,2)
    errorlev=errorlevels(p)
    for n=1:ntests
        %doping level for each dye, random from 0% - 100% in 11% steps
        levels=(randi(10,[nspec 1])-1)/9;
        %Set internal standard to constant value.
        levels(int_std)=1;
        
        %generate test spectrum - sum of each spectrum x it's abundance 
        %plus appropriate noise
        %noise is linear with spectral intensity - eg fractional
        %photobleaching or similar - standard deviation (CV) is given by
        %errorlev
        test_spectrum=zeros([size(spectra,1) 1]);
        for s=1:nspec
            temp_spectrum=spectra(:,s)*levels(s);
            test_spectrum=test_spectrum + temp_spectrum .* (1 + (errorlev .* randn(1)));
        end
                
        %least-squares fit
        fit_levels=spectra\test_spectrum;
        
        %normalize to internal standard
        fit_levels=fit_levels./fit_levels(int_std);
        
        err(:,p,n)=levels-fit_levels;
    end
end


%delete internal standard column from err
err(int_std,:,:)=[];

%calculate standard deviation for each code intensity as a function of
%photon level
nstds=3;
std_err=std(err,[],3);
nlevels=1./(std_err*nstds); %number of distinguishable levels for each channel
codes=prod(max(floor(nlevels),1),1); %initial coding capacity estimate

%now estimate coding capactity based on having a miscall rate equal to 10x
%the code space - i.e. for 100 codes, miscall rate would be 1/1000.

for n=1:size(errorlevels,2)
    delta_nstds=6;
    while (delta_nstds>0.75)
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