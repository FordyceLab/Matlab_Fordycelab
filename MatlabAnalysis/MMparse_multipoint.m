function imstack = MMparse_multipoint(imdir)

%get directory of directory to read
top_dir = dir(imdir);
for n=1:size(top_dir,1)
    if top_dir(n).isdir && ~strcmp(top_dir(n).name ,'.') && ~strcmp(top_dir(n).name,'..')
        temp = MMparse(fullfile(imdir,top_dir(n).name));
        if exist('imstack','var')
            imstack = cat(6,imstack,temp);
        else
            imstack = temp;
        end
    end
end

        