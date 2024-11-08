# Orbital Intersection Plotter

This project optimizes the Right Ascension of the Ascending Node (RAAN) for a constellation of satellites, ensuring ideal angular separation while maintaining alignment with the Earth's orbital plane. The tool includes 3D visualizations of orbital planes, their intersections, and the regions within a unit sphere to highlight spatial relationships.

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
  - [Console Output](#console-output)
  - [3D Plot](#3d-plot)
- [License](#license)

## Overview

The **Orbital Intersection Plotter** is a MATLAB-based tool designed to optimize the RAAN for a satellite constellation. It visualizes the orbital geometry by plotting the celestial sphere, Earth's orbital plane, satellite orbital planes, and their intersections. This ensures even angular spacing of satellite orbits around Earth's plane, providing clear visualization and optimized configurations for satellite constellations.

## Features

- **RAAN Optimization**: Adjusts RAAN values to achieve even angular separation for a user-defined number of satellites.
- **3D Visualization**: Renders the celestial sphere, Earth's orbital plane, satellite orbital planes, and their intersections within a unit sphere.
- **Intersection Highlighting**: Clearly marks the intersected regions within the sphere for enhanced spatial understanding.
- **Console Reporting**: Displays optimized RAANs, achieved angles, and convergence information in the MATLAB command window.

## Requirements

- MATLAB (with support for 3D plotting and optimization)

## Usage

1. **Clone the Repository**: Download or clone the repository to your local machine.
2. **Open MATLAB**: Ensure MATLAB is installed and open on your system.
3. **Navigate to the Directory**: Use MATLAB's `cd` command to navigate to the project directory.
4. **Run the Main Script**: Execute the main script by typing `Intersection_plotter_main` in the MATLAB command window.
5. **View Results**: Observe the optimized RAANs in the console and the generated 3D plot for visualization.

## Code Structure

### Main Script

#### `Intersection_plotter_main.m`

The main entry point of the project. This script performs the following:

- **Initial Setup**: Defines the number of satellites and their target RAAN angles, ensuring even spacing around Earth's orbital plane.
- **Optimization Call**: Invokes the `extract_and_plot_3D_shape` function to perform RAAN optimization.
- **Result Display**: Outputs the optimized RAANs, achieved angles, and total iterations to the MATLAB command window.

### Core Functions

#### `extract_and_plot_3D_shape.m`

Handles the core functionality of RAAN optimization and visualization:

- **3D Plot Setup**: Initializes a 3D plot displaying the celestial sphere, Earth's plane, satellite planes, and the horizontal plane.
- **Intersection Calculations**: Computes intersection lines between the various planes and the celestial sphere.
- **Visualization Enhancements**: Highlights intersected regions within the sphere for better clarity.

### Helper Functions

#### `rotation_matrix.m`

Generates a rotation matrix based on the specified inclination, RAAN, and yaw angles for each orbital plane.

#### `create_plane.m`

Creates and meshes a 3D plane using a rotation matrix, facilitating its visualization within the 3D plot.

#### `calculate_intersections.m`

Computes the intersection line between two planes given their orientation, providing a point on the line and its direction vector.

#### `clip_to_sphere.m`

Clips intersection points to those within a unit sphere, ensuring that only relevant intersections are visualized.

## RAAN Optimization Process

The RAAN optimization ensures even angular spacing for each satellite's orbital plane around Earth's orbital plane. The algorithm minimizes the difference between the achieved and target angles by:

- **Initial Approach**: Starts with a large step size to quickly approach the target angle.
- **Step Refinement**: Reduces the step size as the optimization nears the target for increased accuracy.
- **Convergence Criteria**: Stops the optimization once the achieved angle is within a 0.5-degree tolerance of the target.

Each satellite's RAAN is optimized separately, and the final configuration, along with convergence information, is displayed in the console.

## Visualization

Upon successful RAAN optimization, a comprehensive 3D plot is generated to visualize the orbital configuration:

- **Celestial Sphere**: Represented as a unit sphere centered at the origin.
- **Earth's Orbital Plane**: Displayed in cyan.
- **Satellite Orbital Planes**: Shown in magenta.
- **Horizontal Plane**: Illustrated in yellow.
- **Intersection Lines**: Highlighted in red to show where satellite planes intersect Earth's plane.

This visualization provides a clear view of the intersection geometry of each orbital plane relative to Earth's orbital plane.

## Example Output

### Console Output

After executing `Intersection_plotter_main.m`, the MATLAB command window will display the optimized RAANs and achieved angles. An example of the console output is as follows:

```matlab
% Console output example
Target angles (degrees):
    90.00  180.00  270.00  360.00
Achieved angles (degrees):
    90.12  179.98  270.15  360.02
Optimized RAANs (degrees):
    60.00  150.00  240.00  330.00
Total iterations: 150
