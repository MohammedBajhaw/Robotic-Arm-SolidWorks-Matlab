% SetupIK.m - Complete model setup: re-import, fix joints, enable motion control
% Run this ONCE to prepare the model for IK control.
% After running, use MoveArm.m to control the arm.

fprintf('============================================\n');
fprintf('  SetupIK - Full Model Setup for IK Control\n');
fprintf('============================================\n\n');

%% Step 0: Clean re-import
fprintf('Step 0: Re-importing model from Assem1.xml...\n');
try close_system('Assem1', 0); catch; end
pause(1);

% Delete old data file duplicates
if exist('Assem1_DataFile1.m','file'), delete('Assem1_DataFile1.m'); end

smimport('Assem1.xml');
pause(2);
fprintf('  [OK] Model imported.\n\n');

modelName = 'Assem1';

%% Step 1: Fix base-table connection (Planar -> Weld)
fprintf('Step 1: Fixing base-to-table (Planar -> Weld)...\n');
try
    replace_block(modelName, 'Name', 'Planar', 'sm_lib/Joints/Weld Joint', 'noprompt');
    fprintf('  [OK] Base welded to table.\n\n');
catch ME
    fprintf('  [!] %s\n\n', ME.message);
end

%% Step 2: Lock gripper joints (high spring + damping)
fprintf('Step 2: Locking gripper joints...\n');
gripJoints = {'Cylindrical', 'Cylindrical1', 'Cylindrical2'};
for i = 1:length(gripJoints)
    jPath = [modelName '/' gripJoints{i}];
    try
        % High spring stiffness + damping = locked in place
        set_param(jPath, 'SpringStiffness', '1000');
        set_param(jPath, 'DampingCoefficient', '500');
        % Lock translation too (Cylindrical has both Rz and Pz)
        set_param(jPath, 'SpringStiffnessPz', '10000');
        set_param(jPath, 'DampingCoefficientPz', '1000');
        fprintf('  [OK] %s locked.\n', gripJoints{i});
    catch ME
        fprintf('  [!] %s: %s\n', gripJoints{i}, ME.message);
    end
end
fprintf('\n');

%% Step 3: Configure main joints for Motion Input
fprintf('Step 3: Enabling Motion Input on main joints...\n');

% Joint name -> label mapping
% From DataFile:
%   RevoluteJoint(1) = arm1-arm2  = 'Revolute'   initial: -140.30 deg
%   RevoluteJoint(2) = base-arm1  = 'Revolute1'   initial: -173.87 deg
%   RevoluteJoint(3) = arm2-Part2 = 'Revolute2'   initial:  137.70 deg
%   RevoluteJoint(4) = Part2-arm3 = 'Revolute3'   initial:  -82.77 deg

mainJoints = {'Revolute1', 'Revolute', 'Revolute2', 'Revolute3'};
jointLabels = {'q1_Base', 'q2_Shoulder', 'q3_Elbow', 'q4_Wrist'};
% Initial angles from SolidWorks assembly (degrees)
initAngles = [-173.87, -140.30, 137.70, -82.77];

for i = 1:length(mainJoints)
    jPath = [modelName '/' mainJoints{i}];
    try
        % Switch to motion input (position-controlled)
        set_param(jPath, 'MotionActuationMode', 'InputMotion');
        % Make sure no torque input is active
        set_param(jPath, 'TorqueActuationMode', 'NoTorque');
        fprintf('  [OK] %s -> InputMotion\n', mainJoints{i});
    catch ME
        fprintf('  [!] %s: %s\n', mainJoints{i}, ME.message);
    end
end
fprintf('\n');

%% Step 4: Add control blocks (Constant -> PS Converter -> Joint)
fprintf('Step 4: Adding angle control blocks...\n');

for i = 1:length(mainJoints)
    jPath = [modelName '/' mainJoints{i}];
    constName = jointLabels{i};
    convName = [jointLabels{i} '_Conv'];
    constPath = [modelName '/' constName];
    convPath = [modelName '/' convName];

    try
        pos = get_param(jPath, 'Position');

        % Add Constant block with initial angle
        add_block('simulink/Sources/Constant', constPath, ...
            'Position', [pos(1)-280, pos(2)+70, pos(1)-220, pos(2)+90], ...
            'Value', num2str(initAngles(i)));

        % Add Simulink-PS Converter (output unit = degrees)
        add_block('nesl_utility/Simulink-PS Converter', convPath, ...
            'Position', [pos(1)-170, pos(2)+70, pos(1)-110, pos(2)+90]);
        try
            set_param(convPath, 'Unit', 'deg');
        catch
            fprintf('    Note: Could not set unit on %s, assuming radians.\n', convName);
        end

        % Connect: Constant -> Converter
        add_line(modelName, [constName '/1'], [convName '/1'], 'autorouting', 'on');

        % Connect: Converter -> Joint motion input port
        ph = get_param(jPath, 'PortHandles');
        phConv = get_param(convPath, 'PortHandles');

        % Motion input is the last LConn port (after B frame port)
        add_line(modelName, phConv.RConn(1), ph.LConn(end), 'autorouting', 'on');

        fprintf('  [OK] %s = %.1f deg -> %s\n', constName, initAngles(i), mainJoints{i});
    catch ME
        fprintf('  [!] %s: %s\n', constName, ME.message);
    end
end
fprintf('\n');

%% Step 5: Save
save_system(modelName);
fprintf('============================================\n');
fprintf('  SETUP COMPLETE!\n');
fprintf('============================================\n');
fprintf('\nThe model is ready. To move the arm:\n');
fprintf('  1. Edit MoveArm.m with your target X, Y, Z\n');
fprintf('  2. Run: MoveArm\n');
fprintf('  3. Press Run in Simulink\n');
fprintf('\nOr set angles directly:\n');
fprintf('  set_param(''Assem1/q1_Base'', ''Value'', ''90'')\n');
fprintf('  set_param(''Assem1/q2_Shoulder'', ''Value'', ''-90'')\n');
fprintf('  etc.\n');
