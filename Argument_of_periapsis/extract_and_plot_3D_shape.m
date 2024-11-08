function extract_and_plot_3D_shape(theta1, theta2, RAAN, yaw1, yaw2)
    % Create a figure
    figure;
    hold on;
    axis equal;
    axis off;

    % Define the celestial sphere
    [x, y, z] = sphere(100);
    surf(x, y, z, 'FaceAlpha', 0.1, 'EdgeColor', 'none'); % Transparent sphere

    % Earth's plane
    R1 = rotation_matrix(theta1, RAAN, yaw1);
    [x1, y1, z1] = create_plane(R1);
    surf(x1, y1, z1, 'FaceAlpha', 0.3, 'FaceColor', 'cyan', 'EdgeColor', 'none');

    % Satellite plane
    R2 = rotation_matrix(theta2, RAAN, yaw2);
    [x2, y2, z2] = create_plane(R2);
    surf(x2, y2, z2, 'FaceAlpha', 0.3, 'FaceColor', 'magenta', 'EdgeColor', 'none');

    % Horizontal plane (xy-plane)
    [X, Y] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
    Z = zeros(size(X));
    surf(X, Y, Z, 'FaceAlpha', 0.3, 'FaceColor', 'yellow', 'EdgeColor', 'none');

    % Intersection calculations
    intersection_ES = calculate_intersections(theta1, theta2, RAAN, RAAN, yaw1, yaw2);
    intersection_EH = [x1(:), y1(:), zeros(size(x1(:)))];
    intersection_SH = [x2(:), y2(:), zeros(size(x2(:)))];

    % Clip intersection points to be within the sphere
    intersection_ES = clip_to_sphere(intersection_ES);
    intersection_EH = clip_to_sphere(intersection_EH');
    intersection_SH = clip_to_sphere(intersection_SH');

    % Combine intersection points
    vertices = [intersection_ES, intersection_EH, intersection_SH];

    % Remove duplicate vertices
    vertices = unique(vertices', 'rows')';

    % Plot the intersection lines
    plot3(intersection_ES(1,:), intersection_ES(2,:), intersection_ES(3,:), 'r', 'LineWidth', 2);
    plot3(intersection_EH(1,:), intersection_EH(2,:), intersection_EH(3,:), 'g', 'LineWidth', 2);
    plot3(intersection_SH(1,:), intersection_SH(2,:), intersection_SH(3,:), 'b', 'LineWidth', 2);

    % Check if points are coplanar
    if size(vertices, 2) > 3 && rank(vertices - mean(vertices, 2)) == 3
        % Highlight the specified region
        k = convhull(vertices(1,:), vertices(2,:), vertices(3,:));
        trisurf(k, vertices(1,:), vertices(2,:), vertices(3,:), 'FaceColor', 'red', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
    else
        % Handle coplanar case
        fill3(vertices(1,:), vertices(2,:), vertices(3,:), 'r', 'FaceAlpha', 0.1);
    end

    % Labels and title
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('3D Shape Formed by Intersections');
    grid on;

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
    % Create a plane with a given rotation matrix R
    [x, y] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
    z = zeros(size(x));
    for i = 1:numel(x)
        point = R * [x(i); y(i); z(i)];
        x(i) = point(1);
        y(i) = point(2);
        z(i) = point(3);
    end
end

function intersection = calculate_intersections(theta1, theta2, RAAN1, RAAN2, yaw1, yaw2)
    % Calculate the intersection of two planes given their angles
    R1 = rotation_matrix(theta1, RAAN1, yaw1);
    R2 = rotation_matrix(theta2, RAAN2, yaw2);

    % Define the planes
    normal1 = R1(:,3);
    normal2 = R2(:,3);

    % Find the direction of the line of intersection
    direction = cross(normal1, normal2);

    % Find a point on the line of intersection
    A = [normal1'; normal2'];
    b = [0; 0];
    point = A \ b;

    % Define the line of intersection
    t = linspace(-1.5, 1.5, 100);
    intersection = [point(1) + direction(1)*t; point(2) + direction(2)*t; point(3) + direction(3)*t];
end

function clipped_points = clip_to_sphere(points)
    % Clip points to be within the unit sphere
    distances = sqrt(sum(points.^2, 1));
    clipped_points = points(:, distances <= 1);
end
