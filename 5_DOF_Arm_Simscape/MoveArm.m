% MoveArm.m - Move the robotic arm to target coordinates
% 
% HOW TO USE:
%   1. Change the X, Y, Z values below (in mm)
%   2. Run this script: >> MoveArm
%   3. Press Run in Simulink to see the arm move
%
% Coordinate System:
%   X = forward (positive = away from base)
%   Y = left    (positive = to the left)
%   Z = up      (positive = upward)
%   Origin = center of base on table surface

%% ============== SET YOUR TARGET HERE ==============
target_X = 0;   % mm - forward distance
target_Y = 0;     % mm - left/right
target_Z = 400;   % mm - height above table
%% ==================================================

fprintf('\n==========================\n');
fprintf('  MoveArm - Target Input\n');
fprintf('==========================\n');
fprintf('Target: [%.1f, %.1f, %.1f] mm\n\n', target_X, target_Y, target_Z);

% Calculate joint angles using Inverse Kinematics
[q1, q2, q3, q4] = robotIK(target_X, target_Y, target_Z);

% Apply angles to the Simulink model
modelName = 'Assem1';
if ~bdIsLoaded(modelName)
    open_system(modelName);
end

fprintf('Applying angles to model...\n');
try
    set_param([modelName '/q1_Base'],     'Value', num2str(q1));
    set_param([modelName '/q2_Shoulder'], 'Value', num2str(q2));
    set_param([modelName '/q3_Elbow'],    'Value', num2str(q3));
    set_param([modelName '/q4_Wrist'],    'Value', num2str(q4));
    
    fprintf('  q1_Base     = %.2f deg\n', q1);
    fprintf('  q2_Shoulder = %.2f deg\n', q2);
    fprintf('  q3_Elbow    = %.2f deg\n', q3);
    fprintf('  q4_Wrist    = %.2f deg\n', q4);
    fprintf('\n[OK] Angles set! Now press RUN in Simulink.\n');
catch ME
    fprintf('  Error: %s\n', ME.message);
    fprintf('  Make sure you ran SetupIK.m first!\n');
end

fprintf('==========================\n\n');
