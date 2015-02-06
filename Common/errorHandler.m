function errorHandler(inputTag, inputMe, message, errorLog, uiMessageHandler, displayDialog)
% Handles errors for the chip control system
%
% errorHandler(inputTag, inputMe, message, errorLog, uiMessageHandler, displayDialog)
%
% inputTag = Tag from the function that is reporting the error
% inputMe = Matlab exception object captured by the catch statement that
%           resulted in calling this function
% message = Message to be reported, additional to the one given by le
% errorLog = Handles to the error logging closure
% uiMessageHandler = Handle to function that reports message on the GUI
% displayDialog = Boolean that specifies if a dialog box should shown to
%                 the user
%
% R. Gomez-Sjoberg 11/29/11

try
    if isempty(inputMe)
        inputMe.identifier = '';
        inputMe.message = '';
        inputMe.stack = [];
    end
    errTag = [inputTag ' - ' inputMe.identifier];
    if isempty(message)
        errMessage = inputMe.message;
    else
        errMessage = [message '. ' inputMe.message];
    end
    if ~isempty(inputMe.stack)
        errMessage=[errMessage ' ' inputMe.stack(1,1).name ', line: ' ...
            num2str(inputMe.stack(1,1).line)];
    end
    beep;
    disp(errTag);
    disp(errMessage);
    if ~isempty(uiMessageHandler)
        uiMessageHandler([errTag 10 13 errMessage]);
    end
    if ~isempty(errorLog)
        errorLog.addEventWithTitle(errTag, errMessage);
    end
    if displayDialog
        infodlg('Title', errTag, 'String', errMessage);
    end
catch myMe
    myTag = [inputTag ':errorHandler'];
    errMessage = myMe.message;
    if ~isempty(inputMe.stack)
        errMessage=[errMessage ' ' myMe.stack(1,1).name ', line: ' ...
            num2str(myMe.stack(1,1).line)];
    end
    disp(myTag);
    disp(errMessage);
    if ~isempty(uiMessageHandler)
        uiMessageHandler([myTag 10 13 errMessage]);
    end
    if ~isempty(errorLog)
        errorLog.addEventWithTitle(myTag, errMessage);
    end
    if displayDialog
        infodlg('Title', myTag, 'String', errMessage);
    end
end