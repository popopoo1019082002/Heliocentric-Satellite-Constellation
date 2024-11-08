clc
clear all

% Create a figure
figure;
hold on;
axis equal;

% Define the celestial sphere
[x, y, z] = sphere(100);
surf(x, y, z, 'FaceAlpha', 0.1, 'EdgeColor', 'none'); % Transparent sphere

% Plot the x, y, z axes
quiver3(0, 0, 0, 1.5, 0, 0, 'r', 'LineWidth', 2); % x-axis (First Point of Aries)
quiver3(0, 0, 0, 0, 1.5, 0, 'g', 'LineWidth', 2); % y-axis
quiver3(0, 0, 0, 0, 0, 1.5, 'b', 'LineWidth', 2); % z-axis

% Labels for the axes, placed further outside the sphere
text(2, 0, 0, 'X (First Point of Aries)', 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'center');
text(0, 2, 0, 'Y', 'FontSize', 10, 'Color', 'g', 'HorizontalAlignment', 'center');
text(0, 0, 2, 'Z', 'FontSize', 10, 'Color', 'b', 'HorizontalAlignment', 'center');

% Define the two inclined planes
theta1 = 30; % Angle of the first plane with respect to the xy-plane
theta2 = 60; % Angle of the second plane with respect to the xy-plane
rotation_angle = 45; % Rotation around the z-axis

% First plane
[x1, y1] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
z1 = x1 * tan(deg2rad(theta1));
surf(x1, y1, z1, 'FaceAlpha', 0.3, 'FaceColor', 'cyan', 'EdgeColor', 'none'); % More transparent

% Second plane (rotated around z-axis)
R = [cosd(rotation_angle) -sind(rotation_angle); sind(rotation_angle) cosd(rotation_angle)];
xy2 = R * [x1(:) y1(:)]';
x2 = reshape(xy2(1, :), size(x1));
y2 = reshape(xy2(2, :), size(y1));
z2 = x2 * tan(deg2rad(theta2));
surf(x2, y2, z2, 'FaceAlpha', 0.3, 'FaceColor', 'magenta', 'EdgeColor', 'none'); % More transparent

% Calculate the intersection line of the two planes
n1 = [0; 0; 1] * tan(deg2rad(theta1));
n2 = [cosd(rotation_angle); sind(rotation_angle); 1] * tan(deg2rad(theta2));
n = cross(n1, n2);
d = cross(n, [0; 0; 1]);
d = d / norm(d);
t = linspace(-1.5, 1.5, 100);
intersection_x = t * d(1);
intersection_y = t * d(2);
intersection_z = t * d(3);
plot3(intersection_x, intersection_y, intersection_z, 'y', 'LineWidth', 2); % Intersection line in yellow

% Mark the intersection on the sphere
plot3(intersection_x(intersection_x.^2 + intersection_y.^2 + intersection_z.^2 <= 1), ...
      intersection_y(intersection_x.^2 + intersection_y.^2 + intersection_z.^2 <= 1), ...
      intersection_z(intersection_x.^2 + intersection_y.^2 + intersection_z.^2 <= 1), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% Set the view and labels
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Celestial Sphere with Inclined Planes and Intersection Line');
grid on;

% Set the view angle
view(3);

% Adjust lighting
camlight;
lighting gouraud;

hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI implementation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create a figure for the GUI
fig = uifigure('Name', 'Adjust Angles', 'Position', [100, 100, 400, 300]);

% Create sliders for inclination angles and RAAN
slider_theta1 = uislider(fig, 'Position', [100, 250, 200, 3], 'Limits', [0, 90], 'Value', 30);
slider_theta1_label = uilabel(fig, 'Position', [310, 245, 80, 22], 'Text', 'Theta1 (deg)');

slider_theta2 = uislider(fig, 'Position', [100, 200, 200, 3], 'Limits', [0, 90], 'Value', 60);
slider_theta2_label = uilabel(fig, 'Position', [310, 195, 80, 22], 'Text', 'Theta2 (deg)');

slider_raan = uislider(fig, 'Position', [100, 150, 200, 3], 'Limits', [0, 360], 'Value', 45);
slider_raan_label = uilabel(fig, 'Position', [310, 145, 80, 22], 'Text', 'RAAN (deg)');



% Add listeners to the sliders
addlistener(slider_theta1, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_raan));
addlistener(slider_theta2, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_raan));
addlistener(slider_raan, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_raan));

% Initial plot
update_plot(slider_theta1, slider_theta2, slider_raan);


% Create a callback function to update the plot
function update_plot(slider_theta1, slider_theta2, slider_raan)
    theta1 = slider_theta1.Value;
    theta2 = slider_theta2.Value;
    rotation_angle = slider_raan.Value;
    
    % Clear the current figure
    clf;
    hold on;
    axis equal;

    % Redefine the celestial sphere
    [x, y, z] = sphere(100);
    surf(x, y, z, 'FaceAlpha', 0.1, 'EdgeColor', 'none');

    % Plot the x, y, z axes
    quiver3(0, 0, 0, 1.5, 0, 0, 'r', 'LineWidth', 2); % x-axis (First Point of Aries)
    quiver3(0, 0, 0, 0, 1.5, 0, 'g', 'LineWidth', 2); % y-axis
    quiver3(0, 0, 0, 0, 0, 1.5, 'b', 'LineWidth', 2); % z-axis

    % Labels for the axes, placed further outside the sphere
    text(2, 0, 0, 'X (First Point of Aries)', 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'center');
    text(0, 2, 0, 'Y', 'FontSize', 10, 'Color', 'g', 'HorizontalAlignment', 'center');
    text(0, 0, 2, 'Z', 'FontSize', 10, 'Color', 'b', 'HorizontalAlignment', 'center');

    % Define the two inclined planes
    [x1, y1] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
    z1 = x1 * tan(deg2rad(theta1));
    surf(x1, y1, z1, 'FaceAlpha', 0.3, 'FaceColor', 'cyan', 'EdgeColor', 'none'); % More transparent

    % Second plane (rotated around z-axis)
    R = [cosd(rotation_angle) -sind(rotation_angle); sind(rotation_angle) cosd(rotation_angle)];
    xy2 = R * [x1(:) y1(:)]';
    x2 = reshape(xy2(1, :), size(x1));
    y2 = reshape(xy2(2, :), size(y1));
    z2 = x2 * tan(deg2rad(theta2));
    surf(x2, y2, z2, 'FaceAlpha', 0.3, 'FaceColor', 'magenta', 'EdgeColor', 'none'); % More transparent

    % Calculate the intersection line of the two planes
    n1 = [0; 0; 1] * tan(deg2rad(theta1));
    n2 = [cosd(rotation_angle); sind(rotation_angle); 1] * tan(deg2rad(theta2));
    n = cross(n1, n2);
    d = cross(n, [0; 0; 1]);
    d = d / norm(d);
    t = linspace(-1.5, 1.5, 100);
    intersection_x = t * d(1);
    intersection_y = t * d(2);
    intersection_z = t * d(3);
    plot3(intersection_x, intersection_y, intersection_z, 'y', 'LineWidth', 2); % Intersection line in yellow

    % Mark the intersection on the sphere
    plot3(intersection_x(intersection_x.^2 + intersection_y.^2 + intersection_z.^2 <= 1), ...
          intersection_y(intersection_x.^2 + intersection_y.^2 + intersection_z.^2 <= 1), ...
          intersection_z(intersection_x.^2 + intersection_y.^2 + intersection_z.^2 <= 1), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

    % Set the view and labels
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Celestial Sphere with Inclined Planes and Intersection Line');
    grid on;

    % Set the view angle
    view(3);

    % Adjust lighting
    camlight;
    lighting gouraud;

    hold off;
end
