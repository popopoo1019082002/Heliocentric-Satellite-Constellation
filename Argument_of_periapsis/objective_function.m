function error = objective_function(RAAN, theta1, theta2, initial_RAAN1, desired_angle, yaw1, yaw2)
    intersection = calculate_intersections(theta1, theta2, initial_RAAN1, RAAN, yaw1, yaw2);
    
    % Determine the positive half of the intersection
    pos_half = intersection(:, intersection(3,:) >= 0);
    
    % Calculate the perpendicular axis to the Earth's plane
    earth_normal = [0; 0; 1];
    R1 = rotation_matrix(theta1, initial_RAAN1, yaw1);
    earth_normal_transformed = R1 * earth_normal;
    
    % Project the x-axis onto the Earth's plane
    x_proj = [1; 0; 0] - dot([1; 0; 0], earth_normal_transformed) * earth_normal_transformed;
    x_proj = x_proj / norm(x_proj);
    
    % Define the perpendicular to the Earth's plane axis
    perpendicular_axis = earth_normal_transformed;
    
    % Calculate the angle using the right-hand rule
    pos_seg_proj = [pos_half(1,:); pos_half(2,:); zeros(1, length(pos_half(1,:)))];
    angle = atan2d(norm(cross(x_proj, pos_seg_proj(:,1))), dot(x_proj, pos_seg_proj(:,1)));
    if dot(cross(x_proj, pos_seg_proj(:,1)), perpendicular_axis) < 0
        angle = 360 - angle;
    end
    
    % Calculate error
    error = abs(angle - desired_angle);
end
