function str = num2str_pad(num, l)
% num2str_pad
% Converts a number NUM to a string with padding zeros to make the
% string a certain minimum length L
%
% str = num2str_pad(num, l)
%
% str = Zero-padded string
% num = Number to convert
% l = Length to reach by padding with zeros
%
% R. Gomez-Sjoberg 8/8/05

z = '0000000000000000000000000000000000000000000000000000000000';
s1 = num2str(num);
l1 = length(s1);
if l1 < l
    str = [z(1:(l - l1)) s1];
else
    str = s1;
end
