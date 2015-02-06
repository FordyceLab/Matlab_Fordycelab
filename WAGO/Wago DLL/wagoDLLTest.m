%% Test of Wago DLL
% R. Gomez-Sjoberg, 04/11/2011

%% Load library
if ~libisloaded('MBT')
%     loadlibrary('MBT', 'MBT.h', 'includepath', 'c:\WINDOWS\system32\', 'mfilename', 'MBT.m');
    loadlibrary('MBT', @MBT);
end;

%% Init
err = calllib('MBT', 'MBTInit');
disp(['MTBInit - err = ' dec2hex(2^31 + err)]);

%% Connect
hWagoP = libpointer('longPtr', 0);
ipAdd = '192.168.1.2';
ipPort = 502;
err = calllib('MBT', 'MBTConnect', ipAdd, ipPort, true, uint16(1000), hWagoP);
hWago = hWagoP.value;
disp(['MTBConnect - err = ' dec2hex(2^31 + err)]);

%% Write coils
bits = uint8(255*ones(1, 40));
bitsP = libpointer('voidPtr', bits);
err = calllib('MBT', 'MBTWriteCoils', hWago, 0, 40, bitsP, 0, 0);
disp(['MTBWriteCoils - err = ' dec2hex(2^31 + err)]);

%% All coils on
bits = uint16(65535*ones(1, 3));
bitsP = libpointer('voidPtr', bits);
err = calllib('MBT', 'MBTWriteCoils', hWago, 0, 40, bitsP, 0, 0);
disp(['MTBCoilsOff - err = ' dec2hex(2^31 + err)]);

%% All coils off
bits = uint8(zeros(1, 40));
bitsP = libpointer('voidPtr', bits);
err = calllib('MBT', 'MBTWriteCoils', hWago, 0, 40, bitsP, 0, 0);
disp(['MTBCoilsOff - err = ' dec2hex(2^31 + err)]);

%% Sequence coils
bits = uint8(255*ones(1, 40));
bitsP = libpointer('voidPtr', bits);
z = uint8(0);
zP = libpointer('voidPtr', z);
o = uint8(1);
oP = libpointer('voidPtr', o);
for ii = 1:40
    err = calllib('MBT', 'MBTWriteCoils', hWago, ii-1, 1, oP, 0, 0);
    pause(0.2);
    err = calllib('MBT', 'MBTWriteCoils', hWago, ii-1, 1, zP, 0, 0);
end
disp(['MTBWriteCoils - err = ' dec2hex(2^31 + err)]);


%% Read coils
bitsP = libpointer('voidPtr', uint16(zeros(1, 40+1)));
err = calllib('MBT', 'MBTReadCoils', hWago, 0, 0, 40, bitsP, 0, 0);
disp(['MTBReadCoils - err = ' dec2hex(2^31 + err)]);
bitsP.value

%% Read registers
wordsP = libpointer('voidPtr', uint16(zeros(1, 4)));
err = calllib('MBT', 'MBTReadRegisters', hWago, 0, 512, 3, wordsP, 0, 0);
disp(['MTBReadResgisters - err = ' dec2hex(2^31 + err)]);
words = uint16(wordsP.value)
dec2bin(words)

%% Read valves
% Read registers for all valves, starting with address 512 (coil #0)
wordsP = libpointer('voidPtr', uint16(zeros(1, 3)));
err = calllib('MBT', 'MBTReadRegisters', hWago, 0, 512, 3, wordsP, 0, 0);
words = wordsP.value;
if ~err
    % Convert all bytes to bits
    allValvesBin = char('0'*ones(1, 48));
    for ii = 1:3
        % Swap lower and upper byte of each word
        sWord = calllib('MBT', 'MBTSwapWord', words(ii));
        bb = dec2bin(sWord, 16);
        idx1 = 16*(ii - 1) + 1;
        allValvesBin(idx1:(idx1 + 15)) = bb(end:-1:1);
    end
    values = allValvesBin - 48
end
disp(['ReadValves - err = ' dec2hex(2^31 + err)]);


%% Disconnect & Exit
err = calllib('MBT', 'MBTDisconnect', hWago);
disp(['MTBDisconnect - err = ' dec2hex(2^31 + err)]);
err = calllib('MBT', 'MBTExit');
disp(['MTBExit - err = ' dec2hex(2^31 + err)]);

%% Unload lib
unloadlibrary('MBT');

