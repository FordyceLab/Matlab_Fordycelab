pauseT = 0.01
chip.openValve('Sv2');
while ~scr.stopSignal()
    chip.openValve('P2');
    pause(pauseT);
    chip.openValve('P3');
    pause(pauseT);
    chip.closeValve('P2');
    pause(pauseT);
    chip.openValve('P1');
    pause(pauseT);
    chip.closeValve('P3');
    pause(pauseT);
    chip.openValve('P2');
    pause(pauseT);
    chip.closeValve('P1');
    pause(pauseT);
end
chip.closeValve('Sv2');
chip.closeValve('P1');
chip.closeValve('P2');
chip.closeValve('P3');