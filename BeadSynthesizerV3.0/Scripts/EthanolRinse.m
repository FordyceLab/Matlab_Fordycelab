% This code washes the chip after beads production
flushMfcsCh = 6;
flushPressure = 5;

ethanolRinseTime = 15;

cleanC1 = 1;
cleanC2 = 1;
cleanC3 = 1;
cleanC4 = 0;
cleanC5 = 0;
cleanC6 = 0;
cleanC7 = 0;
cleanC8 = 1;


chip.closeAll();

infodlg('Title', 'Ethanol rinse', 'String', 'Fill the flush water container with ethanol and click OK');
    mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
    chip.openValve('MxWaste');
    chip.openValve('Water');
    scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
    chip.closeAll();
    mfcs.setChannelsPressure([flushMfcsCh], [0]);

infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to oil input');
    chip.openValve('Sieve');
    mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
    chip.openValve('Ro2');
    scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
    chip.openValve('Ro1');
    scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
    chip.openValve('Ro0');
    scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
    chip.closeAll();
    mfcs.setChannelsPressure([flushMfcsCh], [0]);

    if cleanC1
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C1');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C1');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end

    if cleanC2
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C2');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C2');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end

    if cleanC3
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C3');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C3');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end

    if cleanC4
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C4');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C4');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end

    if cleanC5
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C5');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C5');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end

    if cleanC6
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C6');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C6');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end

    if cleanC7
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C7');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C7');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end

    if cleanC8
        infodlg('Title', 'Ethanol rinse', 'String', 'Connect the ethanol to input C8');
            mfcs.setChannelsPressure([flushMfcsCh], [flushPressure]);
            chip.openValve('MxWaste');
            chip.openValve('C8');
            scr.wait(0, ethanolRinseTime, ['Ethanol rinse'], true);
            chip.closeAll();
            mfcs.setChannelsPressure([flushMfcsCh], [0]);
    end
