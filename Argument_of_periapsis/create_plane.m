function [x, y, z] = create_plane(R)
    % Create a plane rotated by matrix R
    [x, y] = meshgrid(-1.5:0.1:1.5, -1.5:0.1:1.5);
    z = zeros(size(x));
    [x, y, z] = apply_rotation(x, y, z, R);
end

function [x_rot, y_rot, z_rot] = apply_rotation(x, y, z, R)
    % Apply rotation matrix R to points (x, y, z)
    points = [x(:), y(:), z(:)] * R';
    x_rot = reshape(points(:, 1), size(x));
    y_rot = reshape(points(:, 2), size(y));
    z_rot = reshape(points(:, 3), size(z));
end
