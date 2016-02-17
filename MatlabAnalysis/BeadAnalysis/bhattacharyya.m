function B = bhattacharyya (mu1, cov1, mu2, cov2)
%Bhattacharyya Computes the Bhattacharyya distance between two
%multivariate gaussian distributions
%   Detailed explanation goes here

cov = cov1 + cov2 /2;

B = 1/8 * (mu1 - mu2) * inv(cov) * (mu1 - mu2)';
B = B + 1/2 * log (det(cov)/sqrt(det(cov1)*det(cov2))); 

end

