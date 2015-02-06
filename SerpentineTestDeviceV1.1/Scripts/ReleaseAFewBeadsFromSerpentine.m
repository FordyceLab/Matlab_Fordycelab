chip.openValve('SvA1');
while ~scr.stopSignal()
    chip.openValve('SvA2');
    pause(0.05);
    chip.closeValve('SvA2');
    pause(0.05);
    chip.openValve('SvA3');
    pause(0.05);
    chip.closeValve('SvA3');
    pause(0.05);
end
chip.closeValve('SvA1');
chip.closeValve('SvA2');
chip.closeValve('SvA3');