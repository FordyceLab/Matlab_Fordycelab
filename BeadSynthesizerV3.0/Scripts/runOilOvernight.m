while 1
    chip.openValve('Drops');
    pause(0.5);
    chip.closeValve('Drops');
    chip.openValve('Ro1');
    scr.wait(0, 3, 'Cleaning Ro1', true);
    chip.openValve('Ro0');
    scr.wait(0, 3, 'Cleaning Ro0', true);
    chip.closeValve('Ro0');
    pause(0.2)
    chip.closeValve('Ro1');
    pause(0.2)
    chip.openValve('Water');
    for ii=1:180
        scr.wait(0,10,'waiting', true);
        if scr.safeStopSignal()
            break
        end
    end

    if scr.safeStopSignal()
        break
    end
end
chip.closeAll();
chip.openValve('Ro2');
chip.openValve('Water');
