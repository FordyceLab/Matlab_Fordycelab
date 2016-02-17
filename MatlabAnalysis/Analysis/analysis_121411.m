camera_offset = 446;

Code1010_02 = squeeze(MMparse('Z:\Keck\121411\single codes\1010-02_3'));
Code1010_03 = squeeze(MMparse('Z:\Keck\121411\single codes\1010-03_1'));
Code1010_04 = squeeze(MMparse('Z:\Keck\121411\single codes\1010-04_1'));

Code1010_02 = double(Code1010_02) - camera_offset;
Code1010_03 = double(Code1010_03) - camera_offset;
Code1010_04 = double(Code1010_04) - camera_offset;


%get device background
for n=1:5
    slice = Code1010_02(10:250,10:40,n);
    Device_spec(n) = median(slice(:));
end
Device_spec = Device_spec./sum(Device_spec);

spectra = [Dy_spec;Eu_spec;Device_spec];

[Code1010_02u,err] = unmix(Code1010_02, spectra);
median(abs(err(:)./Code1010_02(:)))
[Code1010_03u,err] = unmix(Code1010_03, spectra);
median(abs(err(:)./Code1010_03(:)))
[Code1010_04u,err] = unmix(Code1010_04, spectra);
median(abs(err(:)./Code1010_04(:)))