% Activate serpentine test device chip controller with scripting, microscope and
% camera
clear all;
[scr, chip, scope, camera, mfcs] = chipAutomation('serpentinetestdevicev1p1', 'wago', 'ValveNumbers.txt', false, true, false, 'Cameras_LBL.txt', true);
