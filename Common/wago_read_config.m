function [ip, polarity] = wago_read_config(fname)
% wago_read_config
% Reads Wago valve controller configuration from file on path fname
% Configuration file is a text file with the IP address and the manifold
% polarities.
% The polarity is separated from the IP address by a TAB
% The polarity of each manifold is specified by one letter:
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

if ~exist(fname, 'file')
    error(['Wago controller configuration file "' fname '" does not exist!']);
else
    [ipadd pols] = textread(fname, '%s\t%s\n', ...
        'whitespace', '\r\n\t', 'commentstyle', 'matlab');
    if isempty(ipadd) || isempty(pols)
        error(['Wago controller configuration file is invalid!']);
    else
        ip = ipadd{1};
        pols = pols{1};
        np = length(pols);
        nv = np*8;
        polarity = zeros(1, nv);
        for ii = 1:np
            idx = 8*(ii - 1) + 1;
            if lower(pols(ii)) == 'o'
                polarity(idx:(idx + 7)) = '00000000';
            elseif lower(pols(ii)) == 'c'
                polarity(idx:(idx + 7)) = '11111111';
            else
                error('Only letters ''c'' and ''o'' are allowed in the polarity specification!');
            end
        end
    end
end

end
