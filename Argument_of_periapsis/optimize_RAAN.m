function [optimized_RAANs, target_angles, achieved_angles, min_error_config] = optimize_RAAN(theta1, theta2, initial_RAAN1, num_sats, yaw1, yaw2)
    % Initialize the optimized RAANs array
    optimized_RAANs = zeros(1, num_sats);
    optimized_RAANs(1) = initial_RAAN1;

    % Define the target angles for an evenly spaced configuration
    target_angles = (1:num_sats) * (360 / num_sats);

    % Initialize achieved angles array and minimum error configuration
    achieved_angles = zeros(1, num_sats);
    min_error_config = cell(1, num_sats);

    % Create a waitbar to track progress
    h = waitbar(0, 'Optimizing RAAN for satellites...');
    total_iterations = 0;

    % Optimization options
    options = optimset('Display', 'off', 'TolX', 1e-8, 'MaxIter', 5000);

    % Iterate over each satellite starting from the second
    converged = false(num_sats, 1);
    min_errors = inf(1, num_sats);  % Initialize minimum errors

    while ~all(converged)
        for i = 2:num_sats
            if converged(i)
                continue;
            end

            % Desired angle for the current satellite
            desired_angle = target_angles(i);

            % Improved initial RAAN guess
            if i == 2
                initial_RAAN = optimized_RAANs(1) + 180;
            else
                initial_RAAN = optimized_RAANs(i-1) + 360 / num_sats;
            end
            initial_RAAN = mod(initial_RAAN, 360);

            % Optimize RAAN to minimize the error using fminsearch
            [optimized_RAAN, fval, exitflag, output] = fminsearch(@(RAAN) objective_function(RAAN, theta1, theta2, initial_RAAN1, desired_angle, yaw1, yaw2), initial_RAAN, options);

            % Store optimized RAAN and achieved angle
            optimized_RAANs(i) = mod(optimized_RAAN, 360); % Ensure RAAN stays within 0 to 360

            % Recalculate the achieved angle
            intersection = calculate_intersections(theta1, theta2, initial_RAAN1, optimized_RAANs(i), yaw1, yaw2);
            if optimized_RAANs(i) <= 180
                pos_half = intersection(:, intersection(3,:) >= 0);
            else
                pos_half = intersection(:, intersection(3,:) < 0);
            end
            
            earth_normal = [0; 0; 1];
            R1 = rotation_matrix(theta1, initial_RAAN1, yaw1);
            earth_normal_transformed = R1 * earth_normal;
            x_proj = [1; 0; 0] - dot([1; 0; 0], earth_normal_transformed) * earth_normal_transformed;
            x_proj = x_proj / norm(x_proj);
            perpendicular_axis = earth_normal_transformed;
            pos_seg_proj = [pos_half(1,:); pos_half(2,:); zeros(1, length(pos_half(1,:)))];
            angle = atan2d(norm(cross(x_proj, pos_seg_proj(:,1))), dot(x_proj, pos_seg_proj(:,1)));
            if dot(cross(x_proj, pos_seg_proj(:,1)), perpendicular_axis) < 0
                angle = 360 - angle;
            end
            achieved_angles(i) = angle;

            % Calculate error
            error = abs(angle - desired_angle);

            % Check convergence and update minimum error configuration
            if error < min_errors(i)
                min_errors(i) = error;
                min_error_config{i} = struct('RAAN', optimized_RAANs(i), 'AchievedAngle', angle, 'Iterations', total_iterations);
            end

            if error <= 0.5
                fprintf('Convergence for satellite %d: Yes\n', i);
                converged(i) = true;
            else
                fprintf('Convergence for satellite %d: No\n', i);
            end

            % Update waitbar
            total_iterations = total_iterations + output.iterations;
            waitbar(sum(converged) / num_sats, h, sprintf('Total iterations: %d', total_iterations));
        end
    end

    % Close the waitbar
    close(h);

    % Display target and achieved angles for all satellites
    fprintf('Target angles (degrees):\n');
    disp(target_angles);
    fprintf('Achieved angles (degrees):\n');
    disp(achieved_angles);
    fprintf('Optimized RAANs (degrees):\n');
    disp(optimized_RAANs);

    % Display total iterations
    fprintf('Total iterations: %d\n', total_iterations);
end

function error = objective_function(RAAN, theta1, theta2, initial_RAAN1, desired_angle, yaw1, yaw2)
    intersection = calculate_intersections(theta1, theta2, initial_RAAN1, RAAN, yaw1, yaw2);

    % Determine the positive half of the intersection
    if RAAN <= 180
        pos_half = intersection(:, intersection(3,:) >= 0);
    else
        pos_half = intersection(:, intersection(3,:) < 0);
    end

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

function R = rotation_matrix(theta, RAAN, yaw)
    % Rotation matrix for given angles
    Rx = [1 0 0; 0 cosd(theta) -sind(theta); 0 sind(theta) cosd(theta)];
    Rz = [cosd(RAAN) -sind(RAAN) 0; sind(RAAN) cosd(RAAN) 0; 0 0 1];
    Ry = [cosd(yaw) 0 sind(yaw); 0 1 0; -sind(yaw) 0 cosd(yaw)];
    R = Rz * Rx * Ry;
end
