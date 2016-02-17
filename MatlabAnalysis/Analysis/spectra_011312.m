%load images
camera_offset = 445;
probe_radius = 20;

Sm = squeeze(MMparse('Z:\Keck\011312\Sm_only_1'));
Eu = squeeze(MMparse('Z:\Keck\011312\Eu_only_2'));
Dy = squeeze(MMparse('Z:\Keck\011312\Dy_only_1'));

Dy = bkgd_subtract(Dy, 'estimate', probe_radius);
Dy = bkgd_subtract(Dy, 'median');
Sm = bkgd_subtract(Sm, 'estimate', probe_radius);
Sm = bkgd_subtract(Sm, 'median');
Eu = bkgd_subtract(Eu, 'estimate', probe_radius);
Eu = bkgd_subtract(Eu, 'median');

mask = Dy(:,:,5) > 2000;
for n=2:7
    slice = Dy(:,:,n);
    Dy_spec(n-1)=median(slice(mask));
end

mask = Eu(:,:,6) > 700;
for n=2:7
    slice = Eu(:,:,n);
    Eu_spec(n-1)=median(slice(mask));
end

mask = Sm(:,:,7) > 2000;
for n=2:7
    slice = Sm(:,:,n);
    Sm_spec(n-1)=median(slice(mask));
end

Dy_spec = Dy_spec./sum(Dy_spec);
Eu_spec = Eu_spec./sum(Eu_spec);
Sm_spec = Sm_spec./sum(Sm_spec);