function [cir_grid] = circular_grid(randomness)

first_circle_degrees = [0 45 90 135 180 225 270 315];
second_circle_degrees = [0 30 60 90 120 150 180 210 240 270 300 330];

for n = 1:size(randomness,1)
    for i = 1:8
        %if first_circle_degrees(i) == 0 || first_circle_degrees(i) == 180
            %cir_grid(i,1,n) = randomness(n,1) + 49*cosd(first_circle_degrees(i));
            %cir_grid(i,2,n) = randomness(n,2) - 49*sind(first_circle_degrees(i));
        %else
            cir_grid(i,1,n) = randomness(n,1) + 50*cosd(first_circle_degrees(i));
            cir_grid(i,2,n) = randomness(n,2) - 50*sind(first_circle_degrees(i));
        %end
    end

    for j = 1:12
        %if second_circle_degrees(j) == 0 || second_circle_degrees(j) == 180
         %   cir_grid(j+8,1,n) = randomness(n,1) + 100*cosd(second_circle_degrees(j));
          %  cir_grid(j+8,2,n) = randomness(n,2) - 100*sind(second_circle_degrees(j));
        %else
            cir_grid(j+8,1,n) = randomness(n,1) + 100*cosd(second_circle_degrees(j));
            cir_grid(j+8,2,n) = randomness(n,2) - 100*sind(second_circle_degrees(j));
        %end
    end
end