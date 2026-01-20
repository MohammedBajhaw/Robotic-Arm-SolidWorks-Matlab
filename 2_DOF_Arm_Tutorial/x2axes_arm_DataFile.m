% Simscape(TM) Multibody(TM) version: 7.7

% This is a model data file derived from a Simscape Multibody Import XML file using the smimport function.
% The data in this file sets the block parameter values in an imported Simscape Multibody model.
% For more information on this file, see the smimport function help page in the Simscape Multibody documentation.
% You can modify numerical values, but avoid any other changes to this file.
% Do not add code to this file. Do not edit the physical units shown in comments.

%%%VariableName:smiData


%============= RigidTransform =============%

%Initialize the RigidTransform structure array by filling in null values.
smiData.RigidTransform(5).translation = [0.0 0.0 0.0];
smiData.RigidTransform(5).angle = 0.0;
smiData.RigidTransform(5).axis = [0.0 0.0 0.0];
smiData.RigidTransform(5).ID = "";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(1).translation = [-150 160 0];  % mm
smiData.RigidTransform(1).angle = 3.1415926535897931;  % rad
smiData.RigidTransform(1).axis = [1 0 0];
smiData.RigidTransform(1).ID = "B[arm1-1:-:arm2-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(2).translation = [-1.7763568394002505e-15 32.000000000000014 -2.1316282072803006e-14];  % mm
smiData.RigidTransform(2).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(2).axis = [0.57735026918962573 -0.57735026918962584 0.57735026918962573];
smiData.RigidTransform(2).ID = "F[arm1-1:-:arm2-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(3).translation = [-300.00000000000017 31.999999999999972 0];  % mm
smiData.RigidTransform(3).angle = 2.0943951023931953;  % rad
smiData.RigidTransform(3).axis = [0.57735026918962584 -0.57735026918962584 0.57735026918962584];
smiData.RigidTransform(3).ID = "B[arm2-1:-:Part2-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(4).translation = [-30.880962103093907 50.000000000000014 44.999999999999901];  % mm
smiData.RigidTransform(4).angle = 2.0943951023931957;  % rad
smiData.RigidTransform(4).axis = [-0.57735026918962584 -0.57735026918962584 0.57735026918962562];
smiData.RigidTransform(4).ID = "F[arm2-1:-:Part2-1]";

%Translation Method - Cartesian
%Rotation Method - Arbitrary Axis
smiData.RigidTransform(5).translation = [134.01713617117795 -3.6114439993718825 294.96020552711616];  % mm
smiData.RigidTransform(5).angle = 0;  % rad
smiData.RigidTransform(5).axis = [0 0 0];
smiData.RigidTransform(5).ID = "RootGround[arm1-1]";


%============= Solid =============%
%Center of Mass (CoM) %Moments of Inertia (MoI) %Product of Inertia (PoI)

%Initialize the Solid structure array by filling in null values.
smiData.Solid(3).mass = 0.0;
smiData.Solid(3).CoM = [0.0 0.0 0.0];
smiData.Solid(3).MoI = [0.0 0.0 0.0];
smiData.Solid(3).PoI = [0.0 0.0 0.0];
smiData.Solid(3).color = [0.0 0.0 0.0];
smiData.Solid(3).opacity = 0.0;
smiData.Solid(3).ID = "";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(1).mass = 2.3019403261110942;  % kg
smiData.Solid(1).CoM = [-56.931558978052294 82.790030578841964 2.7291632250069879];  % mm
smiData.Solid(1).MoI = [11894.141559382571 16166.020723474381 23675.309749271892];  % kg*mm^2
smiData.Solid(1).PoI = [-406.84811922885302 464.23272786732542 9036.4401141725903];  % kg*mm^2
smiData.Solid(1).color = [0.7803921568627451 0.76078431372549016 0.74117647058823533];
smiData.Solid(1).opacity = 1;
smiData.Solid(1).ID = "arm1*:*Default";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(2).mass = 1.3479317840294023;  % kg
smiData.Solid(2).CoM = [-3.3684644173798701 85.161792805939385 7.9992301040207607];  % mm
smiData.Solid(2).MoI = [7246.0209040449718 1966.840307631757 6786.1543708261352];  % kg*mm^2
smiData.Solid(2).PoI = [379.12956204467082 215.47055933611782 -159.94590293512252];  % kg*mm^2
smiData.Solid(2).color = [0.792156862745098 0.81960784313725488 0.93333333333333335];
smiData.Solid(2).opacity = 1;
smiData.Solid(2).ID = "Part2*:*Default";

%Inertia Type - Custom
%Visual Properties - Simple
smiData.Solid(3).mass = 0.79272298383422535;  % kg
smiData.Solid(3).CoM = [-117.91777535978331 -4.2930439112664924 -0.69285907581394746];  % mm
smiData.Solid(3).MoI = [449.63177248495458 12451.996450569031 12273.433089559587];  % kg*mm^2
smiData.Solid(3).PoI = [2.8049772512386633 -11.807484765544983 71.831639939250152];  % kg*mm^2
smiData.Solid(3).color = [0.68627450980392157 0.60784313725490191 0.52941176470588236];
smiData.Solid(3).opacity = 1;
smiData.Solid(3).ID = "arm2*:*Default";


%============= Joint =============%
%X Revolute Primitive (Rx) %Y Revolute Primitive (Ry) %Z Revolute Primitive (Rz)
%X Prismatic Primitive (Px) %Y Prismatic Primitive (Py) %Z Prismatic Primitive (Pz) %Spherical Primitive (S)
%Constant Velocity Primitive (CV) %Lead Screw Primitive (LS)
%Position Target (Pos)

%Initialize the RevoluteJoint structure array by filling in null values.
smiData.RevoluteJoint(2).Rz.Pos = 0.0;
smiData.RevoluteJoint(2).ID = "";

smiData.RevoluteJoint(1).Rz.Pos = 148.93344962856699;  % deg
smiData.RevoluteJoint(1).ID = "[arm1-1:-:arm2-1]";

smiData.RevoluteJoint(2).Rz.Pos = 14.357515980276988;  % deg
smiData.RevoluteJoint(2).ID = "[arm2-1:-:Part2-1]";

