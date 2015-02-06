function [w] = wagoNModbus(ipAddress, polarity, virtual)
% wago
% Creates object to handle solenoid control through a Wago controller
% and initializes communication with the controller.
% The opbject should be created only once (i.e. the wago function should
% be called just once).
% NOTE:  This version uses the API Modbus/TCP DLL (759-312).
%        The file MBT.dll must be in the \WINDOWS\system32 folder.
%        And the custom file MBT.m must be in the same folder as this function.
%
% w = wago(ipAddress, polarity, [virtual])
%
% ipAddress = String with IP address of controller
% polarity = Vector with the polarity for each valve
%            polarity(j) = 0 --> (j-1)th valve is normally open
%            polarity(j) = 1 --> (j-1)th valve is normally closed
%            Valve numbers start at 0.
% virtual = Optional boolean parameter that when true makes the valve
%           controller not connect to the Wago, but it still accepts all
%           commands.  Defaults to false when absent.
%
% w = Wago object
%
% Methods:
% --------
% w.setValves(numbers, values)
%   Set the valves specified by numbers to the states specified in
%   values (0 = open or 1 = closed).  Valve numbers start at 0.
%
% values = w.getValves(numbers)
%   Get the valve values specified by numbers (0 = open or 1 = closed).
%   Valve numbers start at 0.
%
% w.setMemory(addressOffset, values)
% Write vector values to non-volatile memory, with an address offset.
% addressOffset must be >=0 and <= 12288
%
% values = w.getMemory(addressOffset, totalWords)
% Read vector of values from non-volatile memory, with an address offset.
% addressOffset must be >=0 and <= 12288
%
% w.close([unload])
%   Close communication with the Wago controller.
%   If the object won't be used again, must clear w after closing.
%   unload = Optional boolean parameter.
%            true = Unload DLL library used to communicate with controller
%            If omitted, defaults to true.
%
% [error, description] = w.error()
%   Returns the error code and description produced by the last method called.
%   
%
% R. Gomez-Sjoberg  4/14/11
% C. Díaz-Botía     2/21/12
% C. Díaz-Botía     1/9/15

myTag = 'wagoNModbus';

if ~exist('virtual', 'var')
    virtual = false;
end

handle = int32(0);
wagoError = 0;
totalValves = length(polarity);
totalBytes = ceil(totalValves/8);
totalWords = ceil(totalBytes/2);
wordPadLength = totalWords*16 - totalValves;
wagoMaster = [];

currValues = zeros(1, totalValves);

w.close = @wagoClose;
w.error = @wagoGetError;

if ~virtual
    w.setValves = @wagoSetValves;
    w.getValves = @wagoGetValves;
    w.setMemory = @wagoSetMemory;
    w.getMemory = @wagoGetMemory;
    w.setRegisters = @wagoSetRegisters;
    w.getRegisters = @wagoGetRegisters;
    w.getError = @wagoGetError;
    wagoOpen;
    % Read current state of all valves
    wagoGetValves([0:(totalValves-1)]);
else
    ipAddress = 'Virtual';
    w.setValves = @wagoSetValvesVirtual;
    w.getValves = @wagoGetValvesVirtual;
    w.setMemory = @wagoSetMemoryVirtual;
    w.getMemory = @wagoGetMemoryVirtual;
    wagoVirtualMemory = zeros(1, 12288);
end

% Error structure
wagoErrorDescription = {'Error Code', 'Error Description'};
for ii=2:22
    wagoErrorDescription(ii, 1) = {ii-2};
end
wagoErrorDescription{23,1} = 999;
wagoErrorDescription{2,2} = 'No error'; %0
wagoErrorDescription{3,2} = 'Number of valves and number of values do not match in setValves'; %1
wagoErrorDescription{4,2} = 'An element in the Valves vector is out of bounds in set/getValves'; %2
wagoErrorDescription{5,2} = 'Input parameters not matching appropiate classes in set/getRegisters'; %3
wagoErrorDescription{6,2} = 'Number of registers to write is different from number values to write in setRegisters'; %4
wagoErrorDescription{7,2} = 'Value to write in registers should be between 0x0000 and 0xffff'; %5
wagoErrorDescription{8,2} = ''; %6
wagoErrorDescription{9,2} = ''; %7
wagoErrorDescription{10,2} = ''; %8
wagoErrorDescription{11,2} = ''; %9
wagoErrorDescription{12,2} = 'Invalid non-volatile memory offset value in set/getMemory'; %10
wagoErrorDescription{13,2} = 'Vector to write/read to/from non-volatile memory is out of bounds in set/getMemory'; %11
wagoErrorDescription{14,2} = ''; %12
wagoErrorDescription{15,2} = ''; %13
wagoErrorDescription{16,2} = ''; %14
wagoErrorDescription{17,2} = ''; %15
wagoErrorDescription{18,2} = ''; %16
wagoErrorDescription{19,2} = ''; %17
wagoErrorDescription{20,2} = ''; %18
wagoErrorDescription{21,2} = ''; %19
wagoErrorDescription{22,2} = ''; %20
wagoErrorDescription{23,2} = 'Unknown error'; %999


% Open communication
    function wagoOpen

        modbusObj = NET.addAssembly([fileparts(which('wagoNModbus.m')) '\Wago DLL\NModbus\Modbus.dll']);
%         modbusObj = NET.addAssembly(['C:\Microfluidics\Matlab_ChipControl\Wago\Wago DLL\NModbus\Modbus.dll']);
        systemObj = NET.addAssembly('System');

        if isempty(wagoMaster)
            try
                tcpClient = System.Net.Sockets.TcpClient(ipAddress, 502);
                wagoMaster = Modbus.Device.ModbusIpMaster.CreateIp(tcpClient);
            catch
                wagoError = 999;
            end
        end

    end %wagoOpen


% Close communication
    function wagoClose(unload)
        if ~nargin
            unload = true;
        end
        if ~virtual
            try
                wagoMaster.Dispose()
                clear wagoMaster
            catch
                wagoError = 999;
            end
        end
   end %wagoClose

% Return error code
    function [err, descr] = wagoGetError(clearError)
        if wagoError < 0
            err = 2^31 + wagoError;
            if err == hex2dec('80000000')
                err = 0;
            end
        end
        
        descr = wagoErrorDescription{wagoError + 2, 2};
        err = wagoError;
        {wagoErrorDescription{wagoError + 2,:}}
        
        if exist('clearError','var') && clearError
            wagoError = 0;
        end
    end %wagoGetError

% Convert a vector with valve values for all valves to a vector of words,
% where each valve is a bit in one of the words
    function words = wagoValues2Words(values)
        values = [values zeros(1, wordPadLength)];
        words = uint16(zeros(1, totalWords));
        for ii = 1:totalWords
            idx = 16*(ii - 1) + 1;
            % Extract block of 16 valves and converto to binary string
            sWord = char(values((idx + 15):-1:idx) + 48);
            words(ii) = bin2dec(sWord);
        end
    end

% Set state of one or more valves
    function wagoSetValves(numbers, values)
        % Set the valves secified in vector numbers to the states
        % specified in vector values (0 = open or 1 = closed).
        % Valve numbers start at 0.
        % R. Gomez-Sjoberg, 4/14/11
        % C. Díaz-Botía,    2/21/12
        if wagoError
            display('Error, use wago.getError(1) to clear error')
            wagoErrorDescription{wagoError + 2,:}
        else
            if length(numbers) ~= length(values)
                wagoError = 1;
            elseif max(numbers) > totalValves - 1;
                wagoError = 2;
            else
                % Make sure values are 0 or 1
                values = (values > 0);
                % Update valves that must be changed
                newValues = currValues;
                newValues(numbers+1) = values;
                writeValues = ~xor(newValues, polarity);
                % Write new values to the Wago
                try
                    wagoMaster.WriteMultipleCoils(0, logical(writeValues));
                    wagoError = 0;
                catch
                end
                if ~wagoError
                    currValues = newValues;
                end
            end
            pause(0.01);
        end
    end %wagoSetValves

% Get state of one or more valves
    function values = wagoGetValves(numbers)
        % Get the states of the valves specified in vector numbers
        % (0 = open or 1 = closed).
        % Valve numbers start at 0.
        % R. Gomez-Sjoberg, 4/14/11
        % C. Díaz-Botía,    2/21/12
        if wagoError
            display('Error, use wago.getError(1) to clear error')
            wagoErrorDescription{wagoError + 2,:}
        else
            values = [];
            if max(numbers) > totalValves - 1;
                wagoError = 2;
            else
                % Read registers for all valves, starting with address 512 (coil #0)
                % For some reason, reading the coils always gives zeros, so we must
                % read the registers
                try
                    % Coil's start address is 512 for Fordyce system at
                    % Stanford. Modify accordingly to your system.
                    registers = wagoMaster.ReadHoldingRegisters(512, totalWords);
                    wagoError = 0;
                catch
                    display('error')
                end
                words = [];
                for ii=1:totalWords
                    words(ii) = registers.GetValue(ii-1);
                end
                if ~wagoError
                    % Convert all bytes to bits
                    allValvesBin = char('0'*ones(1, totalWords*16));
                    for ii = 1:totalWords
                        % Swap lower and upper byte of each word
                        word = words(ii);
                        bb = dec2bin(word,16);
                        idx = 16*(ii - 1) + 1;
                        allValvesBin(idx:(idx + 15)) = bb(end:-1:1);
                    end
                    values = allValvesBin(1:totalValves) - 48;
                    currValues = ~xor(values, polarity);
                    values = currValues(numbers+1);
                end
            end
        end
    end %wagoGetValves

% Set virtual state of one or more valves
    function wagoSetValvesVirtual(numbers, values)
        % Set the virtual valves secified in vector numbers to the states
        % specified in vector values (0 = open or 1 = closed).
        % Valve numbers start at 0.
        % R. Gomez-Sjoberg, 11/3/11
        % C. Díaz-Botía,    2/21/12

        if length(numbers) ~= length(values)
            wagoError = 1;
        elseif max(numbers) > totalValves - 1;
            wagoError = 2;
        else
            % Make sure values are 0 or 1
            values = (values > 0);
            % Update valves that must be changed
            newValues = currValues;
            newValues(numbers + 1) = values;
            wagoError = 0;
            currValues = newValues;
        end
    end %wagoSetValvesVirtual

% Get state of one or more virtual valves
    function values = wagoGetValvesVirtual(numbers)
        % Get the states of the virtual valves specified in vector numbers
        % (0 = open or 1 = closed).
        % Valve numbers start at 0.
        % R. Gomez-Sjoberg, 11/3/11
        % C. Díaz-Botía,    2/21/12
        
        values = [];
        if max(numbers) > totalValves - 1;
            wagoError = 2;
        else
            values = currValues(numbers + 1);
            wagoError = 0;
        end
    end %wagoGetValvesVirtual


% Get Non-volatile Memory Values
    function allWords = wagoGetMemory(addressOffset, totalWords)
        if wagoError
            display('Error, use wago.getError(1) to clear error')
            wagoErrorDescription{wagoError + 2,:}
        else
            % Read registers for non-volatile memory, starting addressOffset words beyond address 12288.
            % Non-volatile memory space is 12288.. 24575(0x3000... 0x5FFF)(%MW0... %MW12287)
            allWords = [];
            if (addressOffset >= 0) && (addressOffset <= 12288)
                endAddress = 12288 + addressOffset + totalWords;
                if (endAddress <= 24575)
                    try
                        registers = wagoMaster.ReadHoldingRegisters(12288 + addressOffset, totalWords);
                        wagoError = 0;
                    catch
                    end
                    for ii=1:totalWords
                        wordsP(ii) = registers.GetValue(ii-1);
                    end
                    words = wordsP;
                else
                    wagoError = 11;
                end
            else
                wagoError = 10;
            end
            if ~wagoError
                % Convert all bytes to bits
                allWords = zeros(1, totalWords);
                for ii = 1:totalWords
                    % Swap lower and upper byte of each word
                    word = words(ii);
                    allWords(ii) = word;
                end
            end
        end
    end%wagoGetMemory

% Set non-volatile Memory Values
    function wagoSetMemory(addressOffset, values)
        if wagoError
            display('Error, use wago.getError(1) to clear error')
            wagoErrorDescription{wagoError + 2,:}
        else
            % Write values to non-volatile memory registers, starting addressOffset words beyond address 12288.
            % Non-volatile memory space is 12288.. 24575(0x3000... 0x5FFF)(%MW0... %MW12287)
            totalWords = length(values);
            if (addressOffset >= 0) && (addressOffset <= 12288)
                endAddress = 12288 + addressOffset + totalWords;
                if (endAddress <= 24575)
                    % Write new words to the Wago
                    allWords = zeros(1, totalWords);
                    for ii = 1:totalWords
                        % Swap lower and upper byte of each word
                        word = values(ii);
                        allWords(ii) = word;
                    end
                    words = uint16(allWords);
                    try
                        wagoMaster.WriteMultipleRegisters(12288 + addressOffset, words);
                        wagoError = 0;
                    catch
                    end
                else
                    wagoError = 11;
                end
            else
                wagoError = 10;
            end
        end
    end %wagoSetMemory


% Get virtual non-volatile Memory Values
    function allWords = wagoGetMemoryVirtual(addressOffset, totalWords)
        
        % Read registers from virtual non-volatile memory, starting addressOffset words beyond address 12288.
        % Virtual non-volatile memory space is 1:12288
        allWords = [];
        addressOffset = addressOffset + 1;
        if (addressOffset >= 1) && (addressOffset <= 12288)
            endAddress = addressOffset + totalWords - 1;
            if (endAddress <= 12288)
                allWords = wagoVirtualMemory(addressOffset:endAddress);
            else
                wagoError = 11;
            end
        else
            wagoError = 10;
        end
    end%wagoGetMemoryVirtual

% Set virtual non-volatile Memory Values
    function wagoSetMemoryVirtual(addressOffset, values)
        
        % Write values to virtual non-volatile memory registers, starting at addressOffset
        % Virtual non-volatile memory space is 1:12288
        addressOffset = addressOffset + 1;
        totalWords = length(values);
        if (addressOffset >= 0) && (addressOffset <= 12288)
            endAddress = addressOffset + totalWords - 1;
            if (endAddress <= 12288)
                % Write new words to the Wago
                wagoVirtualMemory(addressOffset:endAddress) = values;
            else
                wagoError = 11;
            end
        else
            wagoError = 10;
        end
    end %wagoSetMemoryVirtual

% Set a single or multiple registers
    function wagoSetRegisters(registers, values)
        if wagoError
            display('Error, use wago.getError(1) to clear error')
            wagoErrorDescription{wagoError + 2,:}
        else
            if ~isa(registers,'double') && ~isa(resgisters, 'uint16')
                wagoError = 3;
            end
            if ~isa(values,'char')
                wagoError = 3;
            end            

            if numel(registers) ~= numel(hex2dec(values))
                wagoError = 4;
            end
            if ~wagoError
                if numel(registers) == 1
                    if hex2dec(values) < 0 || hex2dec(values) > 65535
                        wagoError = 5;
                    else
                        wagoMaster.WriteSingleRegister(registers, uint16(hex2dec(values)));
                    end
                else
                    for ii = 1:numel(registers)
                        if hex2dec(values(ii)) < 0 || hex2dec(values(ii)) > 65535
                            wagoError = 5;
                        end
                    end
                    
                    if ~wagoError
                        wagoMaster.WriteMultipleRegisters(registers(1), uint16(hex2dec(values))');
                    else
                        display('Error, use wago.getError(1) to clear error')
                        wagoErrorDescription{wagoError + 2,:}
                    end
                            
                end
            else
                display('Error, use wago.getError(1) to clear error')
                wagoErrorDescription{wagoError + 2,:}
            end
        end
    end

% Read registers
    function registers = wagoGetRegisters(startAddress, totalRegisters)
        if wagoError
            display('Error, use wago.getError(1) to clear error')
            wagoErrorDescription{wagoError + 2,:}
        else
            if ~isa(startAddress,'double') && ~isa(totalRegisters,'double')
                wagoError = 3;
            end
            if ~wagoError
                registers = num2cell(zeros(totalRegisters, 1));
                registers = {registers, registers};

                registersTemp = wagoMaster.ReadHoldingRegisters(startAddress,totalRegisters);
                for ii = 1:totalRegisters
                    registers{ii,2} = dec2hex(registersTemp.GetValue(ii-1));
                    registers{ii,1} = startAddress + ii - 1;
                end
            else
                display('Error, use wago.getError(1) to clear error')
                wagoErrorDescription{wagoError + 2,:}
            end
        end
    end

% Custom function for word swaping
% C. Díaz-Botía,    2/21/12
    function outputWord = swapWord(inputWord)
       wordBin = dec2bin(inputWord, 16);
       outputWord = '';
       outputWord(1:8) = wordBin(9:16);
       outputWord(9:16) = wordBin(1:8);
       outputWord = bin2dec(outputWord);
    end


end %wago
