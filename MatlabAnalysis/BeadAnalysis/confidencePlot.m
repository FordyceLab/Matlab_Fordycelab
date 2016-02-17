function [ confidence, fxnCorrect ] = confidencePlot( P, range )
%confidencePlot Generate plot of fraction of beads identified vs confidence
%of identification.
%   P: P-value array from cluster or a vector of the probability that each
%   bead belongs to its most likely cluster
%   range: optional, [Pmax Pmin] where P is specified as the exponent; 
%   e.g. range [-2 -9] will calculate probabilities from 10^-9 to 10^-2

%so we can pass in either the probability array returned from cluster or
%precalculate maximum P
if size(P,2) > 1
    maxP = max(P, [], 2); %probability of belonging to the most likely Eu cluster
else
    maxP = P;
end

if nargin == 1
    range = [-2 -10];
end

confidence = logspace(max(range), min(range), max(range) - min(range) + 1);

for n=1:numel(confidence)
    nIdentified(n) = numel(find(maxP >= 1-confidence(n)));
end
fxnCorrect = nIdentified./numel(maxP);
figure('Position', [100 100 600 600])
semilogx(confidence, fxnCorrect);
xlabel('1 - Assignment Confidence')
ylabel('Fraction of Beads Identified')
end