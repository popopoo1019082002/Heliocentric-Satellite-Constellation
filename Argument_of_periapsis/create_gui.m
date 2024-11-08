function create_gui()
    % Create a figure for the GUI
    fig = uifigure('Name', 'Adjust Angles', 'Position', [100, 100, 900, 400]);

    % Create sliders for inclination angles and RAAN
    slider_theta1 = uislider(fig, 'Position', [100, 350, 200, 3], 'Limits', [0, 90], 'Value', 30);
    slider_theta1_label = uilabel(fig, 'Position', [310, 345, 80, 22], 'Text', 'Theta1 (deg)');

    slider_theta2 = uislider(fig, 'Position', [100, 300, 200, 3], 'Limits', [0, 90], 'Value', 60);
    slider_theta2_label = uilabel(fig, 'Position', [310, 295, 80, 22], 'Text', 'Theta2 (deg)');

    slider_RAAN1 = uislider(fig, 'Position', [100, 250, 200, 3], 'Limits', [0, 360], 'Value', 45);
    slider_RAAN1_label = uilabel(fig, 'Position', [310, 245, 80, 22], 'Text', 'RAAN1 (deg)');

    slider_yaw1 = uislider(fig, 'Position', [100, 200, 200, 3], 'Limits', [0, 360], 'Value', 0);
    slider_yaw1_label = uilabel(fig, 'Position', [310, 195, 80, 22], 'Text', 'Yaw1 (deg)');

    slider_yaw2 = uislider(fig, 'Position', [100, 150, 200, 3], 'Limits', [0, 360], 'Value', 0);
    slider_yaw2_label = uilabel(fig, 'Position', [310, 145, 80, 22], 'Text', 'Yaw2 (deg)');

    slider_num_sats = uislider(fig, 'Position', [100, 100, 200, 3], 'Limits', [1, 10], 'Value', 1);
    slider_num_sats_label = uilabel(fig, 'Position', [310, 95, 80, 22], 'Text', 'Number of Satellites');

    % Create checkboxes for visibility options
    check_neg_half = uicheckbox(fig, 'Text', 'Show Negative Half', 'Position', [100, 60, 150, 22]);
    check_sat_planes = uicheckbox(fig, 'Text', 'Show Satellite Planes', 'Position', [100, 30, 150, 22]);
    check_intersections = uicheckbox(fig, 'Text', 'Show Intersections', 'Position', [100, 0, 150, 22]);

    % Create a table for displaying satellite numbers, RAANs, target and achieved angles
    tbl = uitable(fig, 'Position', [450, 50, 400, 300]);
    tbl.ColumnName = {'Satellite Number', 'RAAN (deg)', 'Target Angle (deg)', 'Achieved Angle (deg)'};
    tbl.RowName = {};

    % Add listeners to the sliders and checkboxes
    addlistener(slider_theta1, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(slider_theta2, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(slider_RAAN1, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(slider_yaw1, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(slider_yaw2, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(slider_num_sats, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(check_neg_half, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(check_sat_planes, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));
    addlistener(check_intersections, 'ValueChanged', @(src, event) update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections));

    % Ensure the number of satellites is an integer
    addlistener(slider_num_sats, 'ValueChanging', @(src, event) set(slider_num_sats, 'Value', round(event.Value)));

    % Initial plot
    update_plot(slider_theta1, slider_theta2, slider_RAAN1, slider_yaw1, slider_yaw2, slider_num_sats, tbl, check_neg_half, check_sat_planes, check_intersections);

    % Create the iteration count label
    iteration_label = uilabel(fig, 'Position', [100, 50, 200, 22], 'Text', 'Total Iterations: 0');

end
