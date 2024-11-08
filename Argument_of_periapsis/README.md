# MATLAB-Based Optimization and Visualization of Orbital Parameters

This project optimizes the Right Ascension of the Ascending Node (RAAN) for a satellite constellation, aiming for an ideal RAAN separation while maintaining alignment of the periapsis-apoapsis line with the ecliptic plane. The code includes 3D visualizations of orbital planes, intersections, and the region within a unit sphere to highlight spatial relationships.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Usage](#usage)
- [Code Structure](#code-structure)
  - [Main Script](#main-script)
  - [Core Functions](#core-functions)
  - [Helper Functions](#helper-functions)
- [RAAN Optimization Process](#raan-optimization-process)
- [Visualization](#visualization)
- [Example Output](#example-output)
- [License](#license)

## Overview

The code performs:
1. **Optimization** of RAAN values for a satellite constellation to achieve even angular separation on the Earth's ecliptic plane.
2. **Visualization** of 3D spatial configurations, highlighting the intersections of orbital planes with a unit sphere to illustrate the geometry of the system.

## Features

- Optimizes RAAN values for a user-defined number of satellites.
- Provides detailed 3D visualization of the orbital planes, ecliptic plane, and the intersected volume within a unit sphere.
- Displays the angular separation between each satellite's orbital plane and a reference direction on the Earth's plane.

## Requirements

- MATLAB (with support for 3D plotting and optimization)

## Usage

1. **Set Initial Parameters**: Configure the initial parameters in `Intersection_plotter_main.m`.
   ```matlab
   % Parameters for the planes
   theta1 = 30; % Earth's plane inclination angle
   theta2 = 45; % Satellite plane inclination angle
   RAAN = 60;   % Initial RAAN for optimization
   yaw1 = 0;    % Earth's plane yaw
   yaw2 = 0;    % Satellite plane yaw
