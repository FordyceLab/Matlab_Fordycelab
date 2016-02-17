%Set root folder
if filesep() == '\'
    rootFolder = 'Z:';
else
    rootFolder = '/Volumes/data';
end

imgFolder = fullfile(rootFolder, 'NewImages');

%% Eu water droplet

MCAD4_137_01 = squeeze(MMparse(fullfile(imgFolder, '20130523', 'CAD4-137-01_3')));
MCAD4_137_01 = double(MCAD4_137_01);
EuDroplet = MCAD4_137_01(:,:,2:end); %drop brightfield


for n=1:size(EuDroplet,3)
    slice = EuDroplet(50:120,50:120,n);
    backgroundVal = mean(slice(:));
    slice = EuDroplet(:,:,n);
    EuDroplet(:,:,n) = slice - backgroundVal;
end


for n=1:size(EuDroplet,3)
    slice = EuDroplet(180:270,240:350,n);
    Eu_spec(n) = mean(slice(:));
end


%% Dy water droplet

MCAD4_137_02 = squeeze(MMparse(fullfile(imgFolder, '20130523', 'CAD4-137-02_2')));
MCAD4_137_02 = double(MCAD4_137_02);
DyDroplet = MCAD4_137_02(:,:,2:end); %drop brightfield

for n=1:size(DyDroplet,3)
    slice = DyDroplet(50:150,50:150,n);
    backgroundVal = mean(slice(:));
    slice = DyDroplet(:,:,n);
    DyDroplet(:,:,n) = slice - backgroundVal;
end

target4xbeadBF = MCAD4_137_02(188:211,150:173,1);

BFim = MCAD4_137_02(:,:,1);
BFim(181:288,38:268) = mean(BFim(:));
[coords, mask, CC] = xcorrFindBeads(BFim(:,:,1), target4xbeadBF, 7,0.7);


for n=1:size(DyDroplet,3)
    slice = DyDroplet(:,:,n);
    Dy_spec(n) = mean(slice(mask));
end

%% Sm water droplet

MCAD4_137_03 = squeeze(MMparse(fullfile(imgFolder, '20130523', 'CAD4-137-03_3')));
MCAD4_137_03 = double(MCAD4_137_03);
SmDroplet = MCAD4_137_03(:,:,2:end); %drop brightfield

for n=1:size(SmDroplet,3)
    slice = SmDroplet(60:300,30:100,n);
    backgroundVal = mean(slice(:));
    slice = SmDroplet(:,:,n);
    SmDroplet(:,:,n) = slice - backgroundVal;
end


target4xbeadBF = MCAD4_137_03(146:168,162:184,1);

BFim = MCAD4_137_03(:,:,1);
[coords, mask, CC] = xcorrFindBeads(BFim(:,:,1), target4xbeadBF, 7,0.7);


for n=1:size(SmDroplet,3)
    slice = SmDroplet(:,:,n);
    Sm_spec(n) = mean(slice(mask));
end

%% Tm water droplet

MCAD4_137_04 = squeeze(MMparse(fullfile(imgFolder, '20130523', 'CAD4-137-04_3')));
MCAD4_137_04 = double(MCAD4_137_04);
TmDroplet = MCAD4_137_04(:,:,2:end); %drop brightfield

for n=1:size(TmDroplet,3)
    slice = TmDroplet(70:200,370:470,n);
    backgroundVal = mean(slice(:));
    slice = TmDroplet(:,:,n);
    TmDroplet(:,:,n) = slice - backgroundVal;
end


target4xbeadBF = MCAD4_137_04(132:155,323:346,1);

BFim = MCAD4_137_04(:,:,1);
BFim(394:424,100:127) = mean(BFim(:));
[coords, mask, CC] = xcorrFindBeads(BFim(:,:,1), target4xbeadBF, 7,0.7);


for n=1:size(TmDroplet,3)
    slice = TmDroplet(:,:,n);
    Tm_spec(n) = mean(slice(mask));
end


%% Stock 1% Tm water droplet

MCAD4_137_05 = squeeze(MMparse(fullfile(imgFolder, '20130523', 'CAD4-137-05_2')));
MCAD4_137_05 = double(MCAD4_137_05);
Tm = MCAD4_137_05(:,:,2:end); %drop brightfield

for n=1:size(Tm,3)
    slice = Tm(70:140,320:400,n);
    backgroundVal = mean(slice(:));
    slice = Tm(:,:,n);
    Tm(:,:,n) = slice - backgroundVal;
end


for n=1:size(Tm,3)
    slice = Tm(220:290,140:215,n);
    Tm_spec(n) = mean(slice(:));
end

%%


figure('name', 'Eu, Dy, Sm and Tm spectra')
hold on
plot(1:9, Dy_spec, 'color', 'blue');
plot(1:9, Sm_spec, 'color', 'red');
plot(1:9, Eu_spec, 'color', 'cyan');
plot(1:9, Tm_spec, 'color', 'green');
legend({'Dy', 'Sm', 'Eu', 'Tm'}, 'fontweight', 'Bold', 'fontsize', 14, 'location', 'best')
xlabel('Channel', 'fontweight', 'Bold', 'fontsize', 14)
ylabel('Intensity', 'fontweight', 'Bold', 'fontsize', 14)
title('Eu, Dy, Sm and Tm absolute spectra', 'fontweight', 'Bold', 'fontsize', 16)
set(gca, 'xticklabel', {'Em435', 'Em474', 'Em527', 'Em536', 'Em546', 'Em572', 'Em620', 'Em630', 'Em650'}); 


%%
figure('name', 'Eu, Dy, Sm and Tm normalized spectra');
hold on
plot(1:9, Dy_spec./max(Dy_spec), 'color', 'blue');
plot(1:9, Sm_spec./max(Sm_spec), 'color', 'red');
plot(1:9, Eu_spec./max(Eu_spec), 'color', 'cyan');
plot(1:9, Tm_spec./max(Tm_spec), 'color', 'green');
legend({'Dy', 'Sm', 'Eu', 'Tm'}, 'fontweight', 'Bold', 'fontsize', 14, 'location', 'best')
xlabel('Channel', 'fontweight', 'Bold', 'fontsize', 14)
ylabel('Normalized intensity', 'fontweight', 'Bold', 'fontsize', 14)
title('Eu, Dy, Sm and Tm normalized spectra', 'fontweight', 'Bold', 'fontsize', 16)
set(gca, 'xticklabel', {'Em435', 'Em474', 'Em527', 'Em536', 'Em546', 'Em572', 'Em620', 'Em630', 'Em650'});


