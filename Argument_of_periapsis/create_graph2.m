function angles = create_graph2(theta1, theta2, RAAN1, n, yaw1, yaw2, intersections, image_path, show_negative_half, show_satellite_planes, show_intersections)
    cla; % Clear current axes
    hold on;
    axis equal;
    axis off;

    % % Set the background image
    % img = imread(image_path);
    % xImage = [-1.5 1.5; -1.5 1.5];
    % yImage = [-1.5 -1.5; 1.5 1.5];
    % zImage = [1 1; 1 1];
    % surf(xImage, yImage, zImage, 'CData', img, 'FaceColor', 'texturemap', 'EdgeColor', 'none');

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

    % Optimize RAANs for even separation
    desired_Earth_plane_angle = 360 / n;
    optimized_RAANs = optimize_RAAN(theta1, theta2, RAAN1, n, yaw1, yaw2, desired_Earth_plane_angle);

    % Calculate and plot the positive intersection segments for each satellite plane
    angles = zeros(1, n);
    colors = lines(n); % Get distinct colors for each satellite
    for i = 1:n
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
        x_proj = [1; 0; 0];
        pos_seg_proj = [pos_half(1,:); pos_half(2,:); zeros(1, length(pos_half(1,:)))];
        angle = atan2d(norm(cross(x_proj, pos_seg_proj(:,1))), dot(x_proj, pos_seg_proj(:,1)));
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
