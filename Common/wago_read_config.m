function [ip, polarity] = wago_read_config(fname)
% wago_read_config
% Reads Wago valve controller configuration from file on path fname
% Configuration file is a text file with the IP address and the valve
% polarities.
% The polarity is separated from the IP address by a TAB
% The polarity of each valve is specified by one letter:
% o = Normally open, c = Normally closed
% i.e.
% 128.3.129.237 <TAB> ccccoo
%
% [ip, polarity] = wago_read_config(fname)
%
% fname = Full path of configuration file
% ip = String with IP address of Wago controller
% polarity = Array with valve polarities
%            polarity(j) = 0 --> jth valve is normally open
%            polarity(j) = 1 --> jth valve is normally closed
%
% R. Gomez-Sjoberg 11/5/10
%
% Changes:
% RGS 10/16/11: Changed polarity specification from the manifolds to
% individual valves.


if ~exist(fname, 'file')
    error(['Wago controller configuration file "' fname '" does not exist!']);
else
    [ipadd pols] = textread(fname, '%s\t%s\n', ...
        'whitespace', '\r\n\t', 'commentstyle', 'matlab');
    if isempty(ipadd) || isempty(pols)
        error(['Wago controller configuration file is invalid!']);
    else
        ip = ipadd{1};
        pp = pols{1};
        np = length(pp);
        polarity = zeros(1, np);
        for ii = 1:np
            if lower(pp(ii)) == 'o'
                polarity(ii) = 0;
            elseif lower(pp(ii)) == 'c'
                polarity(ii) = 1;
            else
                error('Only letters ''c'' and ''o'' are allowed in the polarity specification!');
            end
        end
    end
end

end
