% Main script
clc;
clear all;

% Initialize the GUI
create_gui();


%%

% Main script
clc;
clear all;

% Parameters for the planes
theta1 = 30; % Earth's plane inclination angle
theta2 = 45; % Satellite plane inclination angle
RAAN = 60; % Right ascension of ascending node
yaw1 = 20; % Earth's plane yaw
yaw2 = 100; % Satellite plane yaw

% Call the function to extract and plot the 3D shape
extract_and_plot_3D_shape(theta1, theta2, RAAN, yaw1, yaw2);

