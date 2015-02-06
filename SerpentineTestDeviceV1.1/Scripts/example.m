for ii=1:1000
    scriptCheck4Stop;
    chip.openValve('SvA1');
    pause(0.1);
    chip.closeValve('SvA1');
    pause(0.3);
    chip.openValve('SvA2');
    pause(0.1);
    chip.closeValve('SvA2');
    pause(0.3);
    chip.openValve('SvA3');
    pause(0.1);
    chip.closeValve('SvA3');
    pause(0.3);
end
