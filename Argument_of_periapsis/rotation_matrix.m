function R = rotation_matrix(theta, RAAN, yaw)
    % Rotation matrix for given angles
    Rx = [1 0 0; 0 cosd(theta) -sind(theta); 0 sind(theta) cosd(theta)];
    Rz = [cosd(RAAN) -sind(RAAN) 0; sind(RAAN) cosd(RAAN) 0; 0 0 1];
    Ry = [cosd(yaw) 0 sind(yaw); 0 1 0; -sind(yaw) 0 cosd(yaw)];
    R = Rz * Rx * Ry;
end
