%% Test of Wago "object'

%% Create object and initiate communication

clear('wago');
wObj = wagoNModbus('192.168.1.3', zeros(1, 56), true);
% wObj = wagoVcGui('WagoController.txt');

%% All valves off
wObj.setValves([0:55], zeros(1, 56));
[err, desc] = wObj.error();
disp([num2str(err) ': ' desc]);

%% All valves on
wObj.setValves([0:55], ones(1, 56));
[err, desc] = wObj.error();
disp([num2str(err) ': ' desc]);

%% Test speed
tic;
for ii = 1:100
    wObj.setValves([ 1 2 3], [0 0 0]);
    wObj.setValves([ 1 2 3], [1 1 1]);
end
toc

%% Set one or more valves
wObj.setValves(0:15, ones(1, 16));
[err, desc] = wObj.error();
disp([num2str(err) ': ' desc]);

%% Get state of valves
% wObj.setValves([0:39], (rand(1, 40) > 0.5));
vals = wObj.getValves([0:55]);
disp(char(vals + 56));
[err, desc] = wObj.error();
disp([num2str(err) ': ' desc]);

%% Set random states
inVals = (rand(1, 56) > 0.5);
wObj.setValves([0:55], inVals);
vals = wObj.getValves([0:55]);
disp(char(vals + 56));
[err, desc] = wObj.error();
disp([num2str(err) ': ' desc]);

%% Blink on/off each valve
wObj.setValves(0:55, zeros(1, 56));
pause(1);
disp(' ');
disp(' ');
for ii = 0:55
    wObj.setValves(ii, 1);
%     pause(0.01);
    vals = wObj.getValves(0:55);
%     vals = wObj.valveStates();
%     disp([num2str_pad(ii+1, 2) ': ' char(vals + 48)]);
%     pause(0.5);
    wObj.setValves(ii, 0);
%     pause(0.2);
end    

%% Set Memory values
wObj.setMemory(12283, 1:100);

%% Memory values
v = wObj.getMemory(0, 56)

%% Close connection
wObj.close();
clear wObj;
