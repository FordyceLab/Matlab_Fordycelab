while ~scr.stopSignal()
    chip.openValve('SvA1');
    pause(0.2);
    chip.closeValve('SvA1');
    pause(0.2);
end
