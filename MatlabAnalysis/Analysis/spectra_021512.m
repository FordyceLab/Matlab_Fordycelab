%building reference spectra for 2/15/12 data 
%use good dark images
%load images
camera_offset = 445;
probe_radius = 20;

Sm = squeeze(MMparse('Z:\Images\021512\Sm_only_1'));
Eu = squeeze(MMparse('Z:\Images\021512\Eu_only_1'));
Dy = squeeze(MMparse('Z:\Images\021512\Dy_only_1'));

Dy = bkgd_subtract(Dy, 'estimate', probe_radius);
Dy = bkgd_subtract(Dy, 'median');
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Sm = bkgd_subtract(Sm, 'median');
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

%remove lint in Eu channel
Eu(1:116,266:368,:)=0;

mask = Dy(:,:,5) > 1000;
for n=2:7
    slice = Dy(:,:,n);
    Dy_spec_new(n-1)=median(slice(mask));
end

mask = Eu(:,:,6) > 400;
for n=2:7
    slice = Eu(:,:,n);
    Eu_spec_new(n-1)=median(slice(mask));
end

mask = Sm(:,:,7) > 1000;
for n=2:7
    slice = Sm(:,:,n);
    Sm_spec_new(n-1)=median(slice(mask));
end

Dy_spec_new = Dy_spec_new./sum(Dy_spec_new);
Eu_spec_new = Eu_spec_new./sum(Eu_spec_new);
Sm_spec_new = Sm_spec_new./sum(Sm_spec_new);

%with flat field correction
corrim = ones([501 502]);
corrim(:,:,2:7) = 1./mnflat;

Sm = squeeze(MMparse('Z:\Images\021512\Sm_only_1'));
Eu = squeeze(MMparse('Z:\Images\021512\Eu_only_1'));
Dy = squeeze(MMparse('Z:\Images\021512\Dy_only_1'));
Dy = (double(Dy) - dark_stack).*corrim;
Eu = (double(Eu) - dark_stack).*corrim;
Sm = (double(Sm) - dark_stack).*corrim;

Dy = bkgd_subtract(Dy, 'estimate', probe_radius);
Dy = bkgd_subtract(Dy, 'median');
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Sm = bkgd_subtract(Sm, 'median');
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

%remove lint in Eu channel
%Eu(1:116,266:368,:)=0;

mask = Dy(:,:,5) > 1000;
for n=2:7
    slice = Dy(:,:,n);
    Dy_spec_new(n-1)=median(slice(mask));
end

mask = Eu(:,:,6) > 400;
for n=2:7
    slice = Eu(:,:,n);
    Eu_spec_new(n-1)=median(slice(mask));
end

mask = Sm(:,:,7) > 1000;
for n=2:7
    slice = Sm(:,:,n);
    Sm_spec_new(n-1)=median(slice(mask));
end

Dy_spec_new = Dy_spec_new./sum(Dy_spec_new);
Eu_spec_new = Eu_spec_new./sum(Eu_spec_new);
Sm_spec_new = Sm_spec_new./sum(Sm_spec_new);
