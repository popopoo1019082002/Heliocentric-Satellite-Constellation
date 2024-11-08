function angles = create_graph(theta1, theta2, RAAN1, num_sats, yaw1, yaw2, show_negative_half, show_satellite_planes, show_intersections, optimized_RAANs)
    cla; % Clear current axes
    hold on;
    axis equal;
    axis off;

    % Define the celestial sphere
    [x, y, z] = sphere(100);
    surf(x, y, z, 'FaceAlpha', 0.1, 'EdgeColor', 'none'); % Transparent sphere

    % Plot the x, y, z axes
    quiver3(0, 0, 0, 1.5, 0, 0, 'r', 'LineWidth', 2); % x-axis (First Point of Aries)
    quiver3(0, 0, 0, 0, 1.5, 0, 'g', 'LineWidth', 2); % y-axis
    quiver3(0, 0, 0, 0, 0, 1.5, 'b', 'LineWidth', 2); % z-axis

    % Plot the faint grid for the xy-plane
    [X, Y] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
    Z = zeros(size(X));
    mesh(X, Y, Z, 'EdgeColor', [0.5 0.5 0.5], 'FaceAlpha', 0.2);

    % Labels for the axes, placed further outside the sphere
    text(2, 0, 0, 'X (First Point of Aries)', 'FontSize', 10, 'Color', 'r', 'HorizontalAlignment', 'center');
    text(0, 2, 0, 'Y', 'FontSize', 10, 'Color', 'g', 'HorizontalAlignment', 'center');
    text(0, 0, 2, 'Z', 'FontSize', 10, 'Color', 'b', 'HorizontalAlignment', 'center');

    % Earth's orbital plane (fixed parameters)
    R1 = rotation_matrix(theta1, RAAN1, yaw1);
    [x1, y1, z1] = create_plane(R1);
    surf(x1, y1, z1, 'FaceAlpha', 0.3, 'FaceColor', 'cyan', 'EdgeColor', 'none'); % More transparent

    % Calculate and plot the positive intersection segments for each satellite plane
    angles = zeros(1, num_sats);
    colors = lines(num_sats); % Get distinct colors for each satellite

    % Define the target angles for an evenly spaced configuration
    target_angles = (1:num_sats) * (360 / num_sats);

    % Plot desired intersection lines on the Earth's plane
    for i = 1:num_sats
        angle_rad = deg2rad(target_angles(i));
        x_end = 1.5 * cos(angle_rad);
        y_end = 1.5 * sin(angle_rad);
        plot3([0 x_end], [0 y_end], [0 0], '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
        text(x_end, y_end, 0, sprintf('%.1f°', target_angles(i)), 'FontSize', 8, 'Color', [0.5 0.5 0.5], 'HorizontalAlignment', 'center');
    end

    for i = 1:num_sats
        RAAN2 = optimized_RAANs(i);
        R2 = rotation_matrix(theta2, RAAN2, yaw2);

        % Intersection calculation for the current satellite plane
        intersection = calculate_intersections(theta1, theta2, RAAN1, RAAN2, yaw1, yaw2);

        % Determine which part of the intersection to show based on RAAN
        if RAAN2 < 180
            pos_half = intersection(:, intersection(3,:) >= 0);
        else
            pos_half = intersection(:, intersection(3,:) <= 0);
        end

        % Plot the intersection line segment inside the sphere if enabled
        if show_intersections
            plot3(pos_half(1,:), pos_half(2,:), pos_half(3,:), 'LineWidth', 2, 'Color', colors(i,:));
        end

        % Optionally plot the satellite plane
        if show_satellite_planes
            [xs, ys, zs] = create_plane(R2);
            surf(xs, ys, zs, 'FaceAlpha', 0.3, 'FaceColor', colors(i,:), 'EdgeColor', 'none');
        end

        % Calculate the angle between the projection of the x-axis and the positive intersection segment
        earth_normal = [0; 0; 1];
        earth_normal_transformed = R1 * earth_normal;
        x_proj = [1; 0; 0] - dot([1; 0; 0], earth_normal_transformed) * earth_normal_transformed;
        x_proj = x_proj / norm(x_proj);

        perpendicular_axis = earth_normal_transformed;
        pos_seg_proj = [pos_half(1,:); pos_half(2,:); zeros(1, length(pos_half(1,:)))];
        angle = atan2d(norm(cross(x_proj, pos_seg_proj(:,1))), dot(x_proj, pos_seg_proj(:,1)));
        if dot(cross(x_proj, pos_seg_proj(:,1)), perpendicular_axis) < 0
            angle = 360 - angle;
        end
        angles(i) = angle;
    end

    % Display the calculated angles
    disp('Angles between the projection of the x-axis and the positive intersection segments:');
    disp(angles);

    % Set the view angle
    view(3);

    % Adjust lighting
    camlight;
    lighting gouraud;

    hold off;
end

function R = rotation_matrix(theta, RAAN, yaw)
    % Rotation matrix for given angles
    Rx = [1 0 0; 0 cosd(theta) -sind(theta); 0 sind(theta) cosd(theta)];
    Rz = [cosd(RAAN) -sind(RAAN) 0; sind(RAAN) cosd(RAAN) 0; 0 0 1];
    Ry = [cosd(yaw) 0 sind(yaw); 0 1 0; -sind(yaw) 0 cosd(yaw)];
    R = Rz * Rx * Ry;
end

function [x, y, z] = create_plane(R)
    % Create a plane meshgrid
    [x, y] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
    z = zeros(size(x));
    % Apply rotation
    for i = 1:numel(x)
        point = R * [x(i); y(i); z(i)];
        x(i) = point(1);
        y(i) = point(2);
        z(i) = point(3);
    end
end
