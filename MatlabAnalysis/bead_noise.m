basedir='Z:\Data\Kurt\033010'
basename='SD_beads_'
threshold=8000;
clear beadmean beadstd SNR
nbeads=1;
for n=0:4
    
    disp(['Loading ' fullfile(basedir,[basename sprintf('%d',n)]) ' ...'])
    imstack=MMparse(fullfile(basedir,[basename sprintf('%d',n)]));
    disp('Done')
    %background subtract
    imstack=imstack-median(imstack(:));
    proj=squeeze(mean(imstack,4));
    stdim=squeeze(std(double(imstack),[],4));
    mask=proj>threshold;
    mask=bwareaopen(mask,20); %remove small objects
    imshow(mask)
    pause
    [L,nobj]=bwlabel(mask);
    for o=1:nobj
        pix=find(L==o);
        tempmean=zeros([size(imstack,4) 1]);
        for t=1:size(imstack,4)
            slice=squeeze(imstack(:,:,:,t));
            tempmean(t)=mean(slice(pix));
        end
        beadmean(nbeads)=mean(tempmean);
        beadstd(nbeads)=std(tempmean);
        SNR(nbeads)=mean(proj(pix)./stdim(pix));
        nbeads=nbeads+1;
    end
end

