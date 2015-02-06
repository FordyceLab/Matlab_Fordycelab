% The goal here is to generate a large code set from Eu, Sm, Dy, and Tm.
% The levels to use here were calculated from measuring SD vs mean for the
% 24 Eu/Sm/Dy code set and the 4 Eu/Tm code set produced on 06/02/14.
% Pressures were recalibrated prior to starting.
% Omit Tm and this becomes 45 code set.  Successfully made on 6/6/2014,
% with the strange omission of 2 codes, repeating on 7/22/2014

% P. Fordyce and B. Baxter 07/22/14
% Attempting to add additional logging about actual MFCS pressures

% Path and name of file to write log to
logFile = fullfile(uigetdir(), filesep, 'SynthesisLog_20140722-01.txt');
mfcsLogFile = fullfile(uigetdir(), filesep, 'PressureLog_20140722-01.txt');

% Chip serial code
chipSerial = 'BS3.0B-PMF-06.12.14-ch02';

% Number of lanthanides including reference color
colors = {'Sm', 'Dy', 'Tm', 'Eu'};
numColors = numel(colors);

% Lanthanides levels wanted
Sm = [0, 0.1035, 0.2363, 0.4067, 0.6253, 0.9058];
Dy = [0, 0.0411, 0.0917, 0.1541, 0.2307, 0.3252, 0.4414, 0.5844, 0.7604, 0.9771];
Tm = [0];

allLevels = {colors{1}, Sm; colors{2}, Dy; colors{3}, Tm};

% Mixer cleaning/flushing time [seconds]
mixerCleanTime = 6;

% Lanthanide mixing time [minutes, seconds]
% Changed from 3:30 to 1:45 minutes mixing time 6/24/2014)
mixingTime = [1,45];

% Drop stabilization time [seconds]
dropStabilizationTime = 45;
% Reducing DropStabTime from 30 to 25 sec for linear polym (not labyrinth)
% June 19, 2014 BB  ...and back up for labyrinth with a 9 psi push...

% Drop push stabilization time [seconds]
% Changed from 25 to 15 seconds (6/24/2014) 
dropPushStabilizationTime = 15;

% Polymerization time for each code [minutes, seconds]
% UV exposure time
polymerTime = [2,00];
% Objective used for polymerization
% polymerObj = '40x'; % Not used at UCSF
% IL Field Diaphragm used for polymerization
% polymerILFD = 6; % Not used at UCSF
% Excitation used for polymerization
polymerChannel = 'Polymerization';

% MFCS channel used to pressurize the oil
oilMfcsCh = 3;
% Desired pressure for the oil (psi)
oilPressure = 9.0;

% MFCS channel used to pressurize the push water
pushWaterMfcsCh = 2;
% Desired pressure for the push water (psi)
pushWaterPressure = 5.5;
% Push water resistor
pushWaterResistor = 'Rp1';

% MFCS channel used to pressurize the flush water
flushMfcsCh = 1;
% Desired pressure for the flush water (psi)
flushPressure = 6;

% MFCS channel used for the lanthanides
% [Sm, Dy, Tm, Eu]
lanthanideMfcsCh = [6, 7, 4, 5];

% Chip input valve names used for the lanthanides
% [Sm, Dy, Tm, Eu]
lanthanideValves = {'C2'; 'C3'; 'C4'; 'C1'};


% Approximate maximum pressure desired for inputs (psi)
maxPressure = 14;

%Mfcs maximum pressure
maxMfcsPressure = 15;

mixData = [];
% Correction factors for input resistances
% Mixer 1
mixData.M1.C1 = 1.0182; %RSm/REu = WidthEu/WidthSm
mixData.M1.C2 = 1.08865; %RDy/REu = WidthEu/WidthDy
mixData.M1.C3 = 1.0000000; %RTm/REu = WidthEu/WidthTm
mixData.M1.Cmix = 1/22.809; %Rmix/REu = Pmix/(PEu - Pmix)
% Mixer 2
mixData.M2.C1 = 1.069; %RSm/REu = WidthEu/WidthSm
mixData.M2.C2 = 1.053; %RDy/REu = WidthEu/WidthDy
mixData.M2.C3 = 1.13559322; %RTm/REu = WidthEu/WidthTm
mixData.M2.Cmix = 1/49.00; %Rmix/REu = Pmix/(PEu - Pmix)


% Input and mixer resistances
% Mixer 1
mixData.M1.R4 = maxPressure; %Eu
mixData.M1.R1 = mixData.M1.C1*mixData.M1.R4; %Sm
mixData.M1.R2 = mixData.M1.C2*mixData.M1.R4; %Dy
mixData.M1.R3 = mixData.M1.C3*mixData.M1.R4; %Tm
mixData.M1.Rmix = mixData.M1.Cmix*mixData.M1.R4;
mixData.M1.Resistors = {mixData.M1.R1, mixData.M1.R2, mixData.M1.R3, mixData.M1.R4, mixData.M1.Rmix};
% Mixer 2
mixData.M2.R4 = maxPressure; %Eu
mixData.M2.R1 = mixData.M2.C1*mixData.M2.R4; %Sm
mixData.M2.R2 = mixData.M2.C2*mixData.M2.R4; %Dy
mixData.M2.R3 = mixData.M2.C3*mixData.M2.R4; %Tm
mixData.M2.Rmix = mixData.M2.Cmix*mixData.M2.R4;
mixData.M2.Resistors = {mixData.M2.R1, mixData.M2.R2, mixData.M2.R3, mixData.M2.R4, mixData.M2.Rmix};

if numel(lanthanideMfcsCh) ~= numColors || numel(lanthanideValves) ~= numColors
    msgbox('The number of colors does not match the number of MFCS channels or number of valves', ...
        'Error');
    scr.stop();
end

if ~isempty(logFile)
    fclose('all');
    if exist(logFile, 'file')
        opt = YesNoCancelDlg('Title', 'Log File Already Exists!', 'String', ...
            ['Log file' 10 13 logFile 10 13 'exists!' 10 13 'Do you want to replace it?' 10 13 ...
            'No log file will be created if you press No!']);
        switch lower(opt)
            case 'no'
                logFile = '';
            case 'cancel'
                scr.stop();
        end
    end
end

% Start log file
if ~scr.stopSignal()
    if ~isempty(logFile)
        logFid = fopen(logFile, 'wt');
        fprintf(logFid, '%s\n', datestr(now));
        fprintf(logFid, '%s\n', logFile);
        fprintf(logFid, 'BEAD PRODUCTION LOG\n');
        fprintf(logFid, 'Chip serial code: %s\n', chipSerial);
        fprintf(logFid, 'Sm = [%s]\n', num2str(Sm, '%4.2f  '));
        fprintf(logFid, 'Dy = [%s]\n', num2str(Dy, '%4.2f  '));
        fprintf(logFid, 'Tm = [%s]\n', num2str(Tm, '%4.2f  '));
        fprintf(logFid, 'Mixer cleaning time = %4.2f sec\n', mixerCleanTime);
        fprintf(logFid, 'Mixing time = %4.2f min %4.2f sec\n', mixingTime(1), mixingTime(2));
        fprintf(logFid, 'Drop stabilization time = %4.2f sec\n', dropStabilizationTime);
        fprintf(logFid, 'UV polymerization time = %4.2f min %4.2f sec\n', polymerTime(1), polymerTime(2));
        fprintf(logFid, 'Polymerization channel = %s\n', polymerChannel);
        fprintf(logFid, 'Resistances Mixer 1 = [Sm, Dy, Tm, Eu, mix] [%s]\n', num2str([mixData.M1.R1, mixData.M1.R2, mixData.M1.R3, mixData.M1.R4, mixData.M1.Rmix], '%4.2f  '));
        fprintf(logFid, 'Resistances Mix2r 2 = [Sm, Dy, Tm, Eu, mix] [%s]\n', num2str([mixData.M2.R1, mixData.M2.R2, mixData.M2.R3, mixData.M2.R4, mixData.M2.Rmix], '%4.2f  '));
        fprintf(logFid, 'Flush/clean water: ch = %i, press = %4.2f psi\n', flushMfcsCh, flushPressure);
        fprintf(logFid, 'Oil: ch = %i, press = %4.2f psi\n', oilMfcsCh, oilPressure);
        fprintf(logFid, 'Push Water: ch = %i, press = %4.2f psi\n', pushWaterMfcsCh, pushWaterPressure);
        fprintf(logFid, 'Lanthanide MFCS Channels: [Sm, Dy, Tm, Eu]  [%s]\n', num2str(lanthanideMfcsCh, '%i,  '));
        str = lanthanideValves{1};
        for ii = 2:length(lanthanideValves)
            str = [str ',  ' lanthanideValves{ii}];
        end
        fprintf(logFid, 'Lanthanide Valves: [Sm, Dy, Tm, Eu]  [%s]\n', str);
        fprintf(logFid, 'Mixer 1\n');
        fprintf(logFid, 'Code#\tFlow_Sm\tFlow_Dy\tFlow_Tm\tFlow_Eu\tP_Sm\tP_Dy\tP_Tm\tP_Eu\n');
        doLog = true;
    else
        doLog = false;
    end
    
    % Start MFCS log file0
    if ~isempty(mfcsLogFile)
        mfcsLogFid = fopen(mfcsLogFile, 'wt');
        fprintf(mfcsLogFid, '%s\n', datestr(now));
        fprintf(mfcsLogFid, '%s\n', mfcsLogFile);
        doMFCSLog = true;
    else
        doMFCSLog = false;
    end
    
    % Generating matrix of flow rates
    % Each column of flows is one set of flow rates for one code
    % flows(:, 1) = Samarium-Eu flow
    % flows(:, 2) = Dysprosium-Eu flow
    % flows(:, 3) = Thulium-Eu flow
    % flows(:, 4) = Ballast (Eu only) flow
    % flows(:, 5) = Total flow = 1
    numCodes = 0;
    for ii = 1:length(Sm)
        for jj = 1:length(Dy)
            for kk = 1:length(Tm)
                if (Sm(ii) + Dy(jj) + Tm(kk)) <= 1
                    numCodes = numCodes + 1;
                    flows(:, numCodes) = [Sm(ii); Dy(jj); Tm(kk); 1 - (Sm(ii) + Dy(jj) + Tm(kk)); 1];
                end
            end
        end
    end
    
    
    disp(' ');
    disp(' ');
    disp(' ');
    disp('START CODE MAKING:');
    disp(' ');
    disp(['numCodes = ' num2str(numCodes)]);
    disp(' ');
    disp('Flows = ');
    disp(flows);
    mixData.M1.A = zeros(numColors+1,numColors+1);
    mixData.M2.A = zeros(numColors+1,numColors+1);
    for ii = 1:numColors
        mixData.M1.A(ii,1) = -1/mixData.M1.Resistors{ii};
        mixData.M1.A(ii,ii+1) = 1/mixData.M1.Resistors{ii};
        
        mixData.M2.A(ii,1) = -1/mixData.M2.Resistors{ii};
        mixData.M2.A(ii,ii+1) = 1/mixData.M2.Resistors{ii};
    end
    mixData.M1.A(numColors+1,1) = 1/mixData.M1.Resistors{end};
    mixData.M2.A(numColors+1,1) = 1/mixData.M2.Resistors{end};
    
    % Generating matrix of pressures
    % inputPressures(1, n) = P_mix
    % inputPressures(2, n) = P_Sm
    % inputPressures(3, n) = P_Dy
    % inputPressures(4, n) = P_Tm
    % inputPressures(5, n) = P_Eu
    mixData.M1.inputPressures = zeros(numColors+1, numCodes);
    mixData.M2.inputPressures = zeros(numColors+1, numCodes);
    for ii = 1:numCodes
        mixData.M1.inputPressures(:, ii) = mldivide(mixData.M1.A, flows(:, ii));
        mixData.M2.inputPressures(:, ii) = mldivide(mixData.M2.A, flows(:, ii));
    end
    
    for ii = 1:numCodes
        for jj = 2:numColors+1
            if mixData.M1.inputPressures(jj, ii) > maxMfcsPressure
                fprintf(logFid,'%s\t%i\t%s\t%i\t%s\n', 'In code #', ii, [colors{jj-1} ' pressure was set from'], mixData.M1.inputPressures(jj, ii),'to maximum MFCS pressure');
                mixData.M1.inputPressures(jj, ii) = maxMfcsPressure;
            end
        end
    end
    
    for ii = 1:numCodes
        for jj = 2:numColors+1
            if mixData.M2.inputPressures(jj, ii) > maxMfcsPressure
                fprintf(logFid,'%s\t%i\t%s\t%i\t%s\n', 'In code #', ii, [colors{jj-1} ' pressure was set from'], mixData.M2.inputPressures(jj, ii),'to maximum MFCS pressure');
                mixData.M2.inputPressures(jj, ii) = maxMfcsPressure;
            end
        end
    end
    
    disp(' ');
    disp('inputPressures Mixer 1= ');
    disp(mixData.M1.inputPressures);
    
    disp(' ');
    disp('inputPressures Mixer 2= ');
    disp(mixData.M2.inputPressures);
    
    if doLog
        for ii = 1:numCodes
            fprintf(logFid, '%i\t%s\t%s\n', ii, num2str(flows(1:numColors, ii)', '%4.2f\t'), num2str(mixData.M1.inputPressures(2:numColors+1, ii)', '%4.2f\t'));
        end
        fprintf(logFid, 'Mixer 2\n');
        fprintf(logFid, 'Code#\tFlow_Sm\tFlow_Dy\tFlow_Tm\tFlow_Eu\tP_Sm\tP_Dy\tP_Tm\tP_Eu\n');
        for ii = 1:numCodes
            fprintf(logFid, '%i\t%s\t%s\n', ii, num2str(flows(1:numColors, ii)', '%4.2f\t'), num2str(mixData.M2.inputPressures(2:numColors+1, ii)', '%4.2f\t'));
        end
    end
    
    opt = YesNoQuestion('Title', 'Bead Synthesis', 'String', ...
        ['Are you ready to start the bead synthesis?' 10 13 ...
        'The field of view must be placed where you want to polymerize']);
    
    mixerInUse = 0;
    switch lower(opt)
        case 'no'
            str = 'ABORTED!';
        case 'yes'
            
            mfcs.setChannelsPressure([pushWaterMfcsCh, oilMfcsCh, flushMfcsCh], [pushWaterPressure, oilPressure, flushPressure]);
%             uiwait(msgbox(['Set push pressure to ' num2str(pushWaterPressure) ', oil pressure to ' num2str(oilPressure) ' and flush pressure to ' num2str(flushPressure)]));
            scope.mmc.setConfig('Channel', 'BF');
            scope.gui.updateGUI(1);
            chip.closeAll();
            chip.openValve('Sieve');
            chip.openValve('Ro2');
            
            for ii = 1:numCodes
                scriptCheck4Stop;
                codeStr.M1 = ['Code # ' num2str(ii) ' = [' num2str(flows(1:4, ii)', '%4.2f  ') ']'];
                
                mfcs.setChannelsPressure(lanthanideMfcsCh, mixData.M1.inputPressures(2:5, ii));
                if doMFCSLog
                    fprintf(mfcsLogFid, '%% Making %s\n', codeStr.M1);
                end

%                 uiwait(msgbox(['Set mfcs channels [' num2str(lanthanideMfcsCh) '] to ' num2str(inputPressures(2:5, ii)'.*68.94) 'mBar']));
                
                % Flushing mixer 1 with water before making a code
                chip.openValves({'Mx1Out', 'Mx1In'})
                pause(0.3)
                chip.openValve('Water');
                pause(0.3)
                chip.openValve('MxWaste');
                pause(0.3)
                scr.wait(0, mixerCleanTime, [codeStr.M1 10 13 'Cleaning mixer 1'], true); 
                chip.closeValve('Water');
                pause(0.3)
                
                % Opening only the valves with flow rate > 0
                % Input pressure > pressure at mixer 1 entrance
                if mixData.M1.inputPressures(1,ii) < (mixData.M1.inputPressures(2, ii) - 0.05) %Sm
                    chip.openValve(lanthanideValves{1});
                end
                pause(0.1)
                if mixData.M1.inputPressures(1,ii) < (mixData.M1.inputPressures(3, ii) - 0.05) %Dy
                    chip.openValve(lanthanideValves{2});
                end
                pause(0.1)
                if mixData.M1.inputPressures(1,ii) < (mixData.M1.inputPressures(4, ii) - 0.05) %Tm
                    chip.openValve(lanthanideValves{3});
                end
                pause(0.1)
                if mixData.M1.inputPressures(1,ii) < (mixData.M1.inputPressures(5,ii) - 0.05) %Eu
                    chip.openValve(lanthanideValves{4});
                end
%                 if ii>1
                scr.waitAndLogPressures(mixingTime(1), mixingTime(2), [codeStr.M1 10 13 'Mixing lanthanides Mixer 1'], true, mfcsLogFid);
                chip.closeValves(lanthanideValves);
                pause(0.3)
%                 chip.closeValve('MxWaste');
                chip.closeValves({'Mx1Out', 'Mx1In'});
                pause(0.3)
                chip.openValve(pushWaterResistor);
                pause(0.3)
                chip.openValve('Push1');
                pause(0.3)
                
                
                    
                scr.wait(0, dropPushStabilizationTime, [codeStr.M1 10 13 'Stabilizing Mixer 1 drop push pressure'], true);
                chip.openValve('Drops1');
                scr.wait(0, dropStabilizationTime, [codeStr.M1 10 13 'Waiting for drop stabilization Mixer 1'], true);
                if ~scr.stopSignal()
                    scope.gui.enableLiveMode(0);
                    scope.mmc.setConfig('Channel', polymerChannel);
                    scope.gui.updateGUI(1);
                    scope.mmc.setShutterOpen(1);
                    scope.gui.enableLiveMode(1);
                end
                disp(['Making ' codeStr.M1]);
                if doLog
                    fprintf(logFid, '%% Making %s\n', codeStr.M1);
                end
                scr.wait(polymerTime(1), polymerTime(2), [codeStr.M1 10 13 'Making Beads Mixer 1'], true);
                scope.gui.enableLiveMode(0);
                scope.mmc.setShutterOpen(0);
                scope.mmc.setConfig('Channel', 'BF');
                scope.gui.updateGUI(1);
                scope.gui.enableLiveMode(1);
                pause(0.3)
                chip.closeValve('Drops1');
                pause(0.3)
                chip.closeValve('Drops1');
                pause(0.3)
                chip.closeValve('Push1');
                pause(0.3)

                
                    % Open t-junction for mixer 2
%                     chip.openValve('Drops2');
%                     scr.wait(0, dropStabilizationTime, [codeStr.M2 10 13 'Waiting for drop stabilization Mixer 2'], true);
                
%                     if ~scr.stopSignal()
%                         scope.gui.enableLiveMode(0);
%                         scope.mmc.setConfig('Excitation', polymerChannel);
%                         scope.gui.updateGUI(1);
%                         scope.mmc.setShutterOpen(1);
%                         scope.gui.enableLiveMode(1);
%                     end

%                     disp(['Making ' codeStr.M2]);
%                     if doLog
%                         fprintf(logFid, '%% Making %s\n', codeStr.M2);
%                     end
                
                
%                     scr.wait(polymerTime(1), polymerTime(2), [codeStr.M2 10 13 'Making Beads Mixer 2 and Mixing lanthanides Mixer 1'], true);
%                     scope.gui.enableLiveMode(0);
%                     scope.mmc.setShutterOpen(0);
%                     scope.mmc.setConfig('Channel', 'BF');
%                     scope.gui.updateGUI(1);
%                     scope.gui.enableLiveMode(1);
%                     chip.closeValve('Drops2');
%                     chip.closeValve('Push2');
%                 else
%                     scr.wait(mixingTime(1), mixingTime(2), [codeStr.M1 10 13 'Mixing lanthanides Mixer 1'], true);
%                 end
                

%                 chip.closeValves(lanthanideValves);
%                 chip.closeValve('MxWaste');
%                 chip.closeValves({'Mix1Out', 'Mix1In'});
%                 chip.openValve(pushWaterResistor);
%                 chip.openValve('Push1');
               
                
                
                % Flushing mixer 2 with water before making a code
%                 codeStr.M2 = ['Code # ' num2str(ii+1) ' = [' num2str(flows(1:4, ii+1)', '%4.2f  ') ']'];
                
%                 chip.openValves({'Mix2Out', 'Mix2In'})
%                 chip.openValve('Water');
%                 chip.openValve('MxWaste');
%                 scr.wait(0, mixerCleanTime, [codeStr.M2 10 13 'Cleaning mixer 2'], true);
%                 chip.closeValve('Water');
                
%                 mfcs.setChannelsPressure(lanthanideMfcsCh, mixData.M2.inputPressures(2:5, ii+1));
                % Opening only the valves with flow rate > 0
                % Input pressure > pressure at mixer 2 entrance
                
                
%                 if mixData.M2.inputPressures(1,ii+1) < (mixData.M2.inputPressures(2, ii+1) - 0.05) %Sm
%                     chip.openValve(lanthanideValves{1});
%                 end
%                 if mixData.M2.inputPressures(1,ii+1) < (mixData.M2.inputPressures(3, ii+1) - 0.05) %Dy
%                     chip.openValve(lanthanideValves{2});
%                 end
%                 if mixData.M2.inputPressures(1,ii+1) < (mixData.M2.inputPressures(4, ii+1) - 0.05) %Tm
%                     chip.openValve(lanthanideValves{3});
%                 end
%                 if mixData.M2.inputPressures(1,ii+1) < (mixData.M2.inputPressures(5,ii+1) - 0.05) %Eu
%                     chip.openValve(lanthanideValves{4});
%                 end
%                 scr.wait(0, dropPushStabilizationTime, [codeStr.M1 10 13 'Stabilizing Mixer 1 drop push pressure'], true);                   
%                 % Open t-junction for mixer 1
%                 chip.openValve('Drops1');
%                 scr.wait(0, dropStabilizationTime, [codeStr.M1 10 13 'Waiting for drop stabilization Mixer 1'], true);
%                 if ~scr.stopSignal()
%                     scope.gui.enableLiveMode(0);
%                     scope.mmc.setConfig('Excitation', polymerChannel);
%                     scope.gui.updateGUI(1);
%                     scope.mmc.setShutterOpen(1);
%                     scope.gui.enableLiveMode(1);
%                 end
                    
%                 disp(['Making ' codeStr.M1]);
%                 if doLog
%                     fprintf(logFid, '%% Making %s\n', codeStr.M1);
%                 end
%                 scr.wait(polymerTime(1), polymerTime(2), [codeStr.M1 10 13 'Making Beads Mixer 1 and Mixing lanthanides Mixer 2'], true);
%                 scope.gui.enableLiveMode(0);
%                 scope.mmc.setShutterOpen(0);
%                 scope.mmc.setConfig('Channel', 'BF');
%                 scope.gui.updateGUI(1);
%                 scope.gui.enableLiveMode(1);
%                 chip.closeValve('Drops1');
%                 chip.closeValve('Push1');
%                 
%                 chip.closeValves(lanthanideValves);
%                 chip.closeValve('MxWaste');
%                 chip.closeValves({'Mix2Out', 'Mix2In'});
%                 chip.openValve(pushWaterResistor);
%                 chip.openValve('Push2');
                
                
         
                if scr.safeStopSignal()
                    break;
                end
            end %for ii
            if ~scr.safeStopSignal() && ~scr.stopSignal()
                mfcs.setChannelsPressure(oilMfcsCh, 15);
%                 chip.openValve('Water');
%                 chip.openValve('MxWaste');
                chip.openValve('Ro0');
%                 scr.wait(0, 45, 'Final water flushing', true);
%                 chip.closeValve('MxWaste');
%                 chip.closeValve('Ro0');
%                 chip.closeValve('Ro2');
%                 chip.openValve('Drops');
%                 scr.wait(0, 2, 'Final water flush polymerization channel', true);
%                 chip.closeValve('Drops');
%                 chip.closeValve('Water');
%                 chip.openValve('Ro0');
                scr.wait(8, 0, 'Final Oil Flushing', true);
                chip.closeValve('Ro0');
%                 chip.closeValve('Ro2');
%                 mfcs.setChannelsPressure(lanthanideMfcsCh, [0 0 0])
%                 chip.openValve('Water');
%                 chip.openValves(lanthanideValves);
%                 scr.wait(6, 0, 'Clearing polymer inputs', true);
                mfcs.setChannelsPressure(1:8, zeros(1, 8));
            end
            chip.closeAll();
            if scr.safeStopSignal() || scr.stopSignal()
                str = 'STOPPED!';
            else
                str = 'DONE!';
            end
    end
    chip.message(str);
    disp(' ');
    disp(str);
    if doLog
        fprintf(logFid, '%% %s\n', str);
        fclose(logFid);
    end
    
    if doMFCSLog
        fclose(mfcsLogFid);
    end
    
end