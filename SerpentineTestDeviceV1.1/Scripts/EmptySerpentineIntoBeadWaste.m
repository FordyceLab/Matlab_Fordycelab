for ii=1:2
    chip.closeAll();
    pause(0.5);
    chip.openValve('BeadOut');
    chip.openValve('SerpIn');
    pause(0.5);
    chip.openValve('Inj1');
    pause(0.5);
    chip.openValve('SvA1');
    chip.openValve('SvA2');
    chip.openValve('SvA3');
    pause(1.0);
    chip.closeValve('SvA1');
    chip.closeValve('SvA2');
    chip.closeValve('SvA3');
    pause(1.0);
    chip.openValve('Sv2');
    pause(1.0);
    chip.closeValve('Sv2');
    chip.closeAll();
end
