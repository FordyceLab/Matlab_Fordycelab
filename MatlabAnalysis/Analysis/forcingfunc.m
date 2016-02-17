function [ err ] = forcingfunc( params, Dy, Eu, Sm )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

a = params(1);
b = params(2);
%c = params(3);
u = params(3:end);

err = sum(abs(Dy - (1 + u)) + abs(Eu - (1 + a*u)) + abs(Sm - (1+b*u)));

end

