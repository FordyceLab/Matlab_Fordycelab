s0 = 0.01; %standard deviation at 0 intensity
m0 = 0;
n = 4.; %number of standard deviations to separate levels by
c = 0.01; %slope of standard deviation vs. mean line

m = m0;
s = s0;

clear ml
ml(1) = m0;
ind=2;
nc = n*c;
while m <= 1
    m = (m*(1+nc) +2*n*s0)/(1-nc);
    ml(ind)=m;
    ind=ind+1;
end
ml(ind-1)=[]