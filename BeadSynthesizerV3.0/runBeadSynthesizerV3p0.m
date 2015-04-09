% Activate Bead synthesizer chip controller with scripting, microscope and
% camera
clear all;

% this is the one that we use for initial testing before making an
% automated code set bc you can use the imageJ tools by opening
% micromanager independently

%[scr, chip, scope, camera, mfcs] = chipAutomation('beadsynthesizerv3p0', 'wago', 'ValveNumbers.txt', false, false, false, 'Cameras_LBL.txt', true);

% this is the one that we use for making an automated code set because it
% automatically opens micromanager

[scr, chip, scope, camera, mfcs] = chipAutomation('beadsynthesizerv3p0', 'wago', 'ValveNumbers.txt', false, true, false, 'Cameras_LBL.txt', true);
