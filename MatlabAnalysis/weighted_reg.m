
function theta = weighted_reg(query, X, y, tau)
W = weight(query, X, tau);
theta = (inv(X'*W*X))*X'*W*y;

function W = weight(x, xi, tau)
% x is a single query value; xi is a vector of training data
W = zeros(size(xi,1));
w = exp(-((x-xi).^2)/(2*tau^2));
for i = 1:size(xi,1)
W(i,i) = w(i);
end