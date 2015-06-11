% Break current loop if the user requested the script to stop
if scr.stopSignal()
    break;
elseif scr.pauseSignal()
    scr.pause('scriptCheck4Stop');
end
