# 🤖 Advanced Robotic Arm: SolidWorks & Simscape Multibody Simulation

<div align="center">
  <img src="https://img.shields.io/badge/MATLAB-R2023a-blue.svg?logo=mathworks" alt="MATLAB">
  <img src="https://img.shields.io/badge/Simulink-Simscape-brightgreen.svg" alt="Simulink">
  <img src="https://img.shields.io/badge/SolidWorks-CAD-red.svg?logo=solidworks" alt="SolidWorks">
  <img src="https://img.shields.io/badge/Control-PID%20%7C%20Inverse%20Kinematics-orange.svg" alt="Control">
</div>

<br>

Welcome to the **Advanced Robotic Arm Simulation** repository. This project bridges the gap between mechanical CAD design and advanced control system simulation. It showcases a complete pipeline starting from 3D modeling in SolidWorks to full physical and dynamic simulation using MATLAB's Simscape Multibody.

This repository is designed to serve both as a professional engineering portfolio piece and an educational resource for those learning **Inverse Kinematics (IK)**, **PID Control**, and **Rigid Body Dynamics**.

---

## 📑 Table of Contents
1. [Project Overview](#-project-overview)
2. [Repository Architecture](#-repository-architecture)
3. [Technical Features & Implementation](#-technical-features--implementation)
4. [Getting Started & Installation](#-getting-started--installation)
5. [Control Strategies Explained](#-control-strategies-explained)
6. [Future Improvements](#-future-improvements)
7. [License](#-license)

---

## 🎯 Project Overview

Designing a robotic arm is not just about drawing 3D parts; it requires ensuring that those parts can move fluidly, bear loads, and reach specific spatial coordinates accurately. 

The primary goal of this project was to:
1. Design a multi-link articulated robotic arm in **SolidWorks**.
2. Export the geometric and inertial properties (mass, center of gravity, moments of inertia) without losing data.
3. Import the assembly into **Simscape Multibody**.
4. Develop mathematical models for **Forward & Inverse Kinematics**.
5. Implement closed-loop **PID controllers** to achieve smooth point-to-point trajectory tracking.

---

## 📂 Repository Architecture

To maintain a clean and professional workspace, the project is divided into three distinct modules based on complexity and purpose:

### 1. `5_DOF_Arm_Simscape/` (Advanced Industrial Model)
This directory houses the flagship model of the project. It is a highly articulated 5-Degree-Of-Freedom robotic arm suitable for complex spatial manipulations.
- **`Assem1.slx`**: The core Simscape physical network representing the arm.
- **`SetupIK.m`**: Initializes Denavit-Hartenberg (DH) parameters, mass distributions, and solver settings.
- **`MoveArm.m` / `robotIK.m`**: The main scripts driving the analytical and numerical Inverse Kinematics calculations to dictate joint angles based on desired end-effector XYZ coordinates.

### 2. `2_DOF_Arm_Tutorial/` (Educational & Control Fundamentals)
A simplified, planar 2-DOF robotic arm. This module is intentionally kept simple to isolate and study the fundamentals of PID tuning and basic trigonometry-based kinematics.
- **`x2axes_arm.slx`**: The Simulink model featuring custom PID loops and Simscape-to-Simulink signal converters.
- **`RunSimpleArm.m`**: A quick-start script to test step-responses and observe how P, I, and D gains affect joint overshoot and settling time.
- *Note:* This model includes a fix for the common `Degenerate Mass Distribution` error often encountered when connecting prismatic/revolute joints directly.

### 3. `SolidWorks_Models/` (Mechanical CAD Source)
The raw 3D models. If you wish to manufacture this arm (e.g., via 3D printing or CNC machining), these files are all you need.
- Contains the main assembly (`Assem1.SLDASM`) and all individual parts (`base.SLDPRT`, `kucuk_arm_1.SLDPRT`, `orta_arm.SLDPRT`, `uzun_arm.SLDPRT`).

---

## ⚙️ Technical Features & Implementation

### 1. High-Fidelity Physics Engine
By utilizing Simscape Multibody, the simulation goes beyond simple animation. The solver calculates real-time torques, gravitational pull on the links, and Coriolis forces. When the arm extends fully, the base motor realistically demands exponentially more torque to maintain the position.

### 2. Degenerate Mass Resolution
A common issue in Simscape is the `Degenerate Mass` error caused by massless rigid connections. This project successfully resolves this by injecting micro-mass bodies (`IntermediateMass`) between concurrent joints, ensuring the algebraic loops in the physics solver compute flawlessly without destabilizing the simulation step size.

### 3. Automated Setup Scripts
No need to manually input variables. The provided MATLAB scripts automatically load all required workspace variables (like Link Lengths $L_1, L_2$, PID gains, and Target Coordinates) before initializing the Simulink model.

---

## 🚀 Getting Started & Installation

### Prerequisites
To run the simulations, you will need:
- **MATLAB** (R2022b or newer recommended)
- **Simulink**
- **Simscape** & **Simscape Multibody** toolboxes
- *(Optional)* **SolidWorks** (only if you wish to edit the `.SLDPRT` CAD files)

### How to Run the 2-DOF Tutorial Model
1. Open MATLAB and navigate to the `2_DOF_Arm_Tutorial/` directory.
2. Run the initialization script:
   ```matlab
   RunSimpleArm
   ```
3. Open `x2axes_arm.slx` and click **Run**. Watch the Mechanics Explorer window as the arm moves to the target coordinates!

### How to Run the 5-DOF Advanced Model
1. Navigate to the `5_DOF_Arm_Simscape/` directory.
2. Run the setup script to load the inverse kinematics parameters:
   ```matlab
   SetupIK
   ```
3. Open `Assem1.slx` and initiate the simulation. You can modify the target XYZ coordinates inside the script to watch the arm adapt its joint angles dynamically.

---

## 🧠 Control Strategies Explained

### Inverse Kinematics (IK)
Instead of manually guessing the required angle for each joint (Forward Kinematics), the user simply inputs a target Cartesian coordinate $(X, Y, Z)$ for the gripper. The `robotIK.m` script utilizes geometric and algebraic solutions to calculate the exact angles ($\theta_1, \theta_2, ..., \theta_5$) required to reach that point in space.

### PID Closed-Loop Feedback
Once the IK algorithm determines the target angles, those targets are sent to the PID controllers as a `Reference Signal`. 
- **Proportional (P):** Drives the arm towards the target quickly.
- **Integral (I):** Eliminates steady-state errors (e.g., sagging due to gravity).
- **Derivative (D):** Acts as a dampener to prevent the arm from oscillating or overshooting the target position.

---

## 🔮 Future Improvements
While the project is fully functional, continuous improvement is always the goal. Future updates may include:
- Implementing Trajectory Planning (e.g., cubic polynomials) for smoother motion profiles rather than step-inputs.
- Integrating Computer Vision to allow the arm to automatically detect and reach for objects.
- Migrating the control logic to ROS 2 (Robot Operating System) for hardware-in-the-loop testing.

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. You are free to use, modify, and distribute this software for personal or commercial purposes.

---
*Developed by Mohammed Bajhaw*
