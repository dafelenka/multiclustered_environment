function [grid, dots] = clusters_grid(z ,distance)

global x_axis_length;
global y_axis_length;
global x_axis_points;
global y_axis_points;


x_axis_length = z(3) - z(1);
y_axis_length = z(4) - z(2);

x_axis_points = floor(x_axis_length/distance);
y_axis_points = floor(y_axis_length/distance);
c = 0;
for i = 0:x_axis_points
    for j = 0:y_axis_points
        c = c + 1;
        grid{c} = [z(1)+(i*distance) z(2)+(j*distance)];
    end
end

 grid = grid';

end