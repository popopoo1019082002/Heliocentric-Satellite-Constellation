function intersections = calculate_intersections(theta1, theta2, RAAN1, RAAN2, yaw1, yaw2)
    R1 = rotation_matrix(theta1, RAAN1, yaw1);
    R2 = rotation_matrix(theta2, RAAN2, yaw2);

    % Plane normal vectors
    n1 = R1(:, 3);
    n2 = R2(:, 3);

    % Calculate the intersection line of the two planes
    direction = cross(n1, n2);
    point_on_line = [0; 0; 0]; % Since the planes pass through the origin

    % Find points of intersection with the sphere
    t = linspace(-1.5, 1.5, 100);
    intersection_points = point_on_line + direction * t;
    inside_sphere = sum(intersection_points.^2, 1) <= 1;
    
    intersections = intersection_points(:, inside_sphere);
end

