function dataset = MMparse_bioformats(filename)
% 
% First attempt at using BioFormats reader to read Micro-manager files into
% Matlab. Currently does not work for data with multiple timepoints or Z
% positions.

data = bfopen(filename);
ims = data{1};
nChan = size(ims,1);
dataset = zeros([size(ims{1, 1}), nChan]);

for n=1:nChan
    dataset(:,:,n) = ims{n,1};
end
    