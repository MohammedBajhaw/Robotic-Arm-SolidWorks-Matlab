# Robotic Arm: SolidWorks Design to Simscape Control

<div align="center">
  <img src="https://img.shields.io/badge/MATLAB-R2023a-blue.svg?logo=mathworks" alt="MATLAB R2023a">
  <img src="https://img.shields.io/badge/Simscape-Multibody-brightgreen.svg" alt="Simscape Multibody">
  <img src="https://img.shields.io/badge/SolidWorks-CAD-red.svg?logo=solidworks" alt="SolidWorks">
  <img src="https://img.shields.io/badge/Control-PID%20%7C%20Inverse%20Kinematics-orange.svg" alt="PID and inverse kinematics">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="MIT License">
</div>

<br>

Designing a robotic arm is more than drawing parts: it has to move smoothly, carry its own weight and reach the point you ask for. This project follows that whole path, from a **multi-link arm designed in SolidWorks** to a **physics-based simulation in MATLAB Simscape Multibody**, controlled with **PID** and **inverse kinematics**.

📄 **Project page:** [bajhaw.com/projects/robotic-arm-cad-simulation-control](https://bajhaw.com/projects/robotic-arm-cad-simulation-control)

---

## Contents

1. [Overview](#overview)
2. [Repository structure](#repository-structure)
3. [From CAD to a physical model](#from-cad-to-a-physical-model)
4. [Control](#control)
5. [Getting started](#getting-started)
6. [Troubleshooting](#troubleshooting)
7. [Current status and next steps](#current-status-and-next-steps)
8. [License](#license)

---

## Overview

The repository contains two simulation models built from the same CAD workflow:

| Model | Joints | Control | Purpose |
|---|---|---|---|
| **2-DOF tutorial arm** | 2 revolute joints (planar) | Closed-loop PID with inverse and forward kinematics | Study PID tuning: set a target point and see how the gains affect overshoot and settling time |
| **Advanced arm** | Base turntable, shoulder, elbow and wrist, plus a two-finger gripper | Inverse kinematics driving joint angles directly | Move the end effector to a target point in 3D space |

## Repository structure

```text
Robotic-Arm-SolidWorks-Matlab/
├── 2_DOF_Arm_Tutorial/          # Planar 2-joint arm for PID study
│   ├── x2axes_arm.slx           # Simulink/Simscape model with PID, IK and FK subsystems
│   ├── x2axes_arm_DataFile.m    # Imported masses, inertias and joint frames
│   ├── 2axes_arm.xml            # Simscape Multibody import file (from SolidWorks)
│   ├── RunSimpleArm.m           # Sets the X/Y target blocks
│   ├── SetTargetCoordinates.m   # Adds a visible target marker to the model
│   └── *.STEP                   # Link geometry
├── 5_DOF_Arm_Simscape/          # Advanced arm with gripper
│   ├── Assem1.slx               # Simscape Multibody model
│   ├── Assem1_DataFile.m        # Imported masses, inertias and joint frames
│   ├── Assem1.xml               # Simscape Multibody import file (from SolidWorks)
│   ├── SetupIK.m                # One-time setup: re-import and prepare joints for IK control
│   ├── MoveArm.m                # Set a target X, Y, Z and apply the joint angles
│   ├── robotIK.m                # Geometric inverse kinematics solver
│   └── *.STEP                   # Base, table, link and gripper geometry
└── SolidWorks_Models/           # Native CAD source
    ├── Assem1.SLDASM            # Main assembly
    └── *.SLDPRT                 # Base and link parts
```

## From CAD to a physical model

The arm was modelled as separate parts in SolidWorks and assembled. The assembly carries each part's **mass, centre of mass and inertia tensor**, and is exported with the Simscape Multibody Link plug-in to an XML file, then imported with `smimport`. As a result, the simulated arm responds to gravity and joint loads like a physical one: for example, the base joint needs more torque to hold the pose when the arm is stretched out.

## Control

### 2-DOF tutorial arm: PID control

The Simulink model contains a desired-trajectory block, an inverse kinematics subsystem that converts the target (X, Y) into two joint angles, a **PID controller per joint**, and a forward kinematics subsystem that reports the actual end-effector position. XY graphs and scopes compare the desired and actual paths.

- **Proportional:** drives the joint towards the target.
- **Integral:** removes steady-state error, such as sag caused by gravity.
- **Derivative:** damps the motion to limit overshoot and oscillation.

### Advanced arm: inverse kinematics

Instead of guessing each joint angle, you give the gripper a target point (X, Y, Z in millimetres) and `robotIK.m` computes the angles geometrically:

1. **Base (q1):** rotates toward the target, `atan2(Y, X)`.
2. **Shoulder and elbow (q2, q3):** solved in the vertical plane as a two-link problem using the law of cosines (elbow-up solution).
3. **Wrist (q4):** set to `-(q2 + q3)` so the gripper stays level.

If the target is out of reach, the solver warns and clamps it to the arm's workspace. `SetupIK.m` prepares the model so these angles drive the joints directly as motion inputs.

## Getting started

### Prerequisites

- MATLAB with **Simulink**, **Simscape** and **Simscape Multibody** (the models were created with R2023a)
- *(Optional)* SolidWorks, to edit the CAD files

### 2-DOF tutorial arm

1. Open MATLAB in `2_DOF_Arm_Tutorial/`.
2. Open `x2axes_arm.slx`.
3. Set the target by editing the `TargetX` and `TargetY` constant blocks (values in mm).
4. Click **Run** and watch the arm move in Mechanics Explorer. Change the PID gains to see their effect on the response.

### Advanced arm

1. Open MATLAB in `5_DOF_Arm_Simscape/`.
2. Prepare the model (only needed once):
   ```matlab
   SetupIK
   ```
   This re-imports the model from `Assem1.xml`, welds the base to the table, locks the gripper joints and adds angle inputs to the base, shoulder, elbow and wrist joints.
3. Set the target in `MoveArm.m`:
   ```matlab
   target_X = 300;   % mm, forward
   target_Y = 0;     % mm, left
   target_Z = 200;   % mm, up
   ```
4. Run `MoveArm`, then click **Run** in Simulink.

Joint angles can also be set directly, for example:

```matlab
set_param('Assem1/q1_Base', 'Value', '90')
```

## Troubleshooting

**"Degenerate mass distribution" error.** CAD imports often trigger this error when massless frames are joined directly by joints. Adding a small intermediate solid with a tiny mass between the joints resolves it without changing the arm's dynamics.

**Arm does not reach the expected point.** The link lengths and the joint offsets between the IK convention and the CAD zero positions are defined at the top of `robotIK.m` and marked for calibration.

## Current status and next steps

The arm currently moves to each target as a step rather than along a smooth trajectory, and the IK-to-CAD joint offsets still need calibration. Planned next steps:

- Smooth trajectory planning (e.g. cubic or quintic polynomials)
- Camera-based object detection so the arm can locate targets itself
- Moving the control logic to ROS 2 for hardware-in-the-loop testing

## License

Released under the MIT License (see [LICENSE](LICENSE)).

---

*Developed by [Mohammed Bajhaw](https://bajhaw.com)*
