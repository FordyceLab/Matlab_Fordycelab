function boundComplex = quadraticBinding(params, Abconc);
Pepconc = abs(params(1));
Kd = params(2);
scale = params(3);

b = Abconc + Pepconc + Kd;
boundComplex = (b - sqrt(b.^2 - (4.*Abconc*Pepconc)))/2;
boundComplex = scale * boundComplex/Pepconc;