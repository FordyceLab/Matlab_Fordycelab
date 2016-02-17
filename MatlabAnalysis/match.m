function [ order ] = match( test, target )
%returns order of indices in test to minimize distances between items in
%test and target

if size(test,1) ~= size(target,1)
    error('Test and target must have same number of rows');
end
nitems = size(test,1);

distances = pdist2(test, target);
[r, c] = find(distances == repmat(min(distances,[],2), [1 nitems]));

%want to add something like this to make sure each bead is matched
%once and only once
%         [~,m,~] = unique(row);
%         ru = row(m);
%         cu = col(m);

order = r; %item in test that best matches the corresponding item in target

end

