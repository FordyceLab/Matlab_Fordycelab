function levels = predictLevelsFromStdDev(s0, slope, nsigma)
%
%Predict the number of levels of a code from
%s0, the standard deviation at 0 intensity,
%slope, the slope of the standard deviation versus intensity
%nsigma the number of standard deviations to separate levels by

m = 0;
levels(1) = 0;
ind = 2;
nc = nsigma*slope;
while levels(ind-1) <= 1
    levels(ind) = (levels(ind-1)*(1+nc) +2*nsigma*s0)/(1-nc);
    ind = ind+1;
end
levels(ind-1) = [];
