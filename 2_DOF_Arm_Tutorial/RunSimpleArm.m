% RunSimpleArm.m - Control the 2-Axis PID Arm
X_target = 500;   % X Coordinate
Y_target = 500;   % Y Coordinate

modelName = 'x2axes_arm_NoPID';
if ~bdIsLoaded(modelName), open_system(modelName); end

% Update target blocks
set_param([modelName '/TargetX'], 'Value', num2str(X_target));
set_param([modelName '/TargetY'], 'Value', num2str(Y_target));

fprintf('\n🎯 Target set to: X=%.2f, Y=%.2f\n', X_target, Y_target);
