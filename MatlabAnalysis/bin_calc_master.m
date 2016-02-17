function [bins, fval] = bin_calc_master(spectra,lambda,error_spectra,level_list)
%Generate synthetic bead spectra by summing of reference spectra

bins=[473 507 559 586 604 630 675];

%simulated annealing parameters
%ANNEAL is from Joachim Vandekerckhove, found on Matlab Central
options.Generator = @bins_generator;
%options.Verbosity = 0;
%options.InitTemp = 10;
%options.MaxConsRej = 3000;

[bins, fval] = anneal(@errfunc,bins,options);

%error function for simulated annealing
    function err = errfunc(bins)
        %rebin spectra according to new binning scheme
        %bins is a 1 x n array of bin boundaries in nm; binds go from
        %1:bins(1), bins(1)+1:bins(2), etc.
        %ends are always 450 and 750 nm, and not included in bins
        
        err_list=zeros(size(level_list));
        b=1;
        bound = find(lambda == bins(b));
        clear new_err_spectra new_ref_spectra
        new_err_spectra(1,:)=sum(error_spectra(1:bound,:),1);
        new_ref_spectra(1,:)=sum(spectra(1:bound,:),1);
        for b=1:(size(bins,2)-1)
            leftbound = find(lambda == (bins(b)+1));
            rightbound = find(lambda == bins(b+1));
            new_err_spectra(b+1,:)=sum(error_spectra(leftbound:rightbound,:),1);
            new_ref_spectra(b+1,:)=sum(spectra(leftbound:rightbound,:),1);
        end
        new_err_spectra(b+2,:)=sum(error_spectra(rightbound+1:end,:),1);
        new_ref_spectra(b+2,:)=sum(spectra(rightbound+1:end,:),1);
        
        for s=1:size(new_err_spectra,2)
            test_spectrum=new_err_spectra(:,s);
            %least-squares fit
            fit_levels=new_ref_spectra\test_spectrum;
            
            %normalize to internal standard
            %             fit_levels=fit_levels./fit_levels(int_std);
            
            err_list(:,s)=level_list(:,s)-fit_levels;
        end
        err = mean(std(err_list,[],2));
    end

    function bins = bins_generator (bins)
        %randomly perturb one bin boundary by +/- delta nm
        delta=5;    %standard deviation of bin move
        bin_to_move = randi(size(bins,2));
        bins(bin_to_move) = round(bins(bin_to_move) + randn(1) * delta);
        if bin_to_move == 1
            bins(bin_to_move) = max (451,bins(bin_to_move));
            bins(bin_to_move) = min (bins(bin_to_move+1)-1,bins(bin_to_move));
        elseif bin_to_move == size(bins,2)
            bins(bin_to_move) = max (bins(bin_to_move-1)+1,bins(bin_to_move));
            bins(bin_to_move) = min (749,bins(bin_to_move));
        else
            bins(bin_to_move) = max (bins(bin_to_move-1)+1,bins(bin_to_move));
            bins(bin_to_move) = min (bins(bin_to_move+1)-1,bins(bin_to_move));
        end
    end

end
