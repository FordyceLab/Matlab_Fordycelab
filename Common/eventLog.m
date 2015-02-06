function log = eventLog(headerString, filePath, append)
% Closure for event logging to a file
%
% log = eventLog(headerString, filePath, append)
%
% headerString = String to be written to the file header.
%                If headerString is empty, no header is written to the
%                file.
% filePath = Full path to file where logging will be written
% append = Boolean that specifies if we are appending to an existing file
%          or re-writing over it.
%
% Methods:
% --------
%
% log.addEvent(eventDescription)
% Writes an event to the log file, with date and time stamp.
% The description goes into the same line as the time stamp.
% eventDescription = String with description of the event
%
% log.addEventWithTitle(eventTitle, eventDescription)
% Writes an event to the log file, with date and time stamp, followed by a
% title in the same line.  The description goes into the following line(s).
% eventTitle = String with title for the event
% eventDescription = String with description of the event
%
% R. Gomez-Sjoberg, 11/28/11

log.addEvent = @addEvent;
log.addEventWithTitle = @addEventWithTitle;

initFile;

    function initFile
        % Open file and write header
        filePermission = 'at';
        %         if ~append && exist(filePath, 'file');
        %             opt = YesNoQuestion('Title', headerString, 'String', ...
        %                 [filePath 10 13 ...
        %                 'Specified log file already exists,' 10 13 'and it will be overwritten.' 10 13 ...
        %                 'Proceed with overwriting?' 10 13 'Pressing NO will switch to appending mode']);
        %             switch lower(opt)
        %                 case 'yes'
        %                     filePermission = 'wt';
        %             end
        %         end
        if ~append
            filePermission = 'wt';
        end
        try
            logfid = fopen(filePath, filePermission);
            if append
                fprintf(logfid, '%s\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                fprintf(logfid, '%s\n', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
            end
            fprintf(logfid, '%% %s\n', datestr(now));
            fprintf(logfid, '%% %s\n',  headerString);
            fclose(logfid);
        catch ME
            handleError(ME);
        end
    end

    function addEvent(eventDescription)
        try
            tt = now;
            % Open file and log event info
            logfid = fopen(filePath, 'at');
            fprintf(logfid, '%s - %s\n', datestr(tt),  eventDescription);
            fclose(logfid);
        catch ME
            handleError(ME);
        end
    end


    function addEventWithTitle(eventTitle, eventDescription)
        try
            tt = now;
            % Open file and log event info
            logfid = fopen(filePath, 'at');
            fprintf(logfid, '%s - %s\n', datestr(tt), eventTitle);
            fprintf(logfid, '\tDescription: %s\n', eventDescription);
            fclose(logfid);
        catch ME
            handleError(ME);
        end
    end

    function handleError(inputMe)
        beep;
        errMessage = inputMe.message;
        if isempty(inputMe.stack)
            errMessage=[errMessage ' ' inputMe.stack(1,1).name ', line: ' ...
                num2str(inputMe.stack(1,1).line)];
        end
        infodlg('Title', inputMe.identifier, 'String', errMessage);
    end
end
