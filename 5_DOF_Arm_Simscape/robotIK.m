function [q1, q2, q3, q4] = robotIK(X, Y, Z)
% robotIK - Inverse Kinematics for Assem1 robotic arm
%
% Calculates the 4 joint angles needed to reach position (X, Y, Z) in mm.
%
% Usage:
%   [q1, q2, q3, q4] = robotIK(300, 0, 200)
%
% Inputs:
%   X, Y, Z - Target position in mm (relative to base center on table)
%             X = forward, Y = left, Z = up
%
% Outputs:
%   q1 - Base rotation (degrees)
%   q2 - Shoulder angle (degrees)
%   q3 - Elbow angle (degrees)
%   q4 - Wrist angle (degrees)
%
% Link lengths extracted from Assem1_DataFile.m:
%   d1  = 104 mm  (base height: table to shoulder axis)
%   a1  = 205 mm  (arm1: shoulder to elbow) 
%   a2  = 300 mm  (arm2: elbow to wrist)
%   a3  = 275 mm  (Part2: wrist to end effector)

% ====== Link Lengths (adjust these if arm doesn't reach correctly) ======
d1 = 104;   % Base height (mm)
a1 = 205;   % arm1 length (mm) - shoulder to elbow
a2 = 300;   % arm2 length (mm) - elbow to wrist  
a3 = 275;   % Part2 length (mm) - wrist to end effector
% =========================================================================

% --- q1: Base rotation (top-down view) ---
q1 = atan2d(Y, X);

% --- Project to vertical plane ---
% Horizontal distance from base axis to target
r = sqrt(X^2 + Y^2);

% Height relative to shoulder joint
z = Z - d1;

% --- Solve 2-link IK for q2, q3 (using a2 and a3) ---
% We treat a1 as a vertical offset from base to the shoulder plane
% Adjust r and z to account for arm1 geometry
% arm1 has both horizontal and vertical components
% For now, we use a simplified 2-link model with a2 and a3

% Distance from shoulder to target in the vertical plane
D = sqrt(r^2 + z^2);

% Check reachability
Dmax = a2 + a3;
Dmin = abs(a2 - a3);

if D > Dmax
    warning('Target is OUT OF REACH (too far). D=%.1f > max=%.1f', D, Dmax);
    % Clamp to maximum reach
    D = Dmax * 0.99;
    r = r * (D / sqrt(r^2 + z^2));
    z = z * (D / sqrt(r^2 + z^2));
elseif D < Dmin
    warning('Target is OUT OF REACH (too close). D=%.1f < min=%.1f', D, Dmin);
    D = Dmin * 1.01;
end

% --- q3: Elbow angle (law of cosines) ---
cos_q3 = (D^2 - a2^2 - a3^2) / (2 * a2 * a3);
cos_q3 = max(-1, min(1, cos_q3));  % Clamp for numerical safety
q3 = acosd(cos_q3);  % Elbow-up solution

% --- q2: Shoulder angle ---
alpha = atan2d(z, r);
beta = atan2d(a3 * sind(q3), a2 + a3 * cosd(q3));
q2 = alpha + beta;

% --- q4: Wrist angle (keep end effector horizontal) ---
q4 = -(q2 + q3);

% --- Apply offsets to match SolidWorks joint conventions ---
% The SolidWorks model has specific zero-angle conventions.
% These offsets map our IK angles to the model's joint coordinates.
% CALIBRATION: Adjust these values if the arm doesn't go to the right place.
q1_offset = -173.87;  % Initial base angle from DataFile
q2_offset = -140.30;  % Initial shoulder angle
q3_offset = 137.70;   % Initial elbow angle
q4_offset = -82.77;   % Initial wrist angle

% For now, output the raw IK angles. 
% The offsets will be applied after calibration.
% Uncomment these lines after determining the correct mapping:
% q1 = q1 + q1_offset;
% q2 = q2 + q2_offset;
% q3 = q3 + q3_offset;
% q4 = q4 + q4_offset;

fprintf('\n--- Inverse Kinematics Results ---\n');
fprintf('Target: X=%.1f, Y=%.1f, Z=%.1f mm\n', X, Y, Z);
fprintf('q1 (Base):     %.2f deg\n', q1);
fprintf('q2 (Shoulder): %.2f deg\n', q2);
fprintf('q3 (Elbow):    %.2f deg\n', q3);
fprintf('q4 (Wrist):    %.2f deg\n', q4);
fprintf('---------------------------------\n');

end
