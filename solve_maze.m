function [x, y] = solve_maze(height, width, maze)
  while true
    flag = 1;
    for j = 1:height
      for i = 1:width
        if (not(j==2&&i==2)&&not(j==height-1&&i==width-1))
          if maze(j, i) == 1
            cnt = 0;
            if maze(j, i-1) == 0
              cnt = cnt + 1;
            end
            if maze(j, i+1) == 0
              cnt = cnt + 1;
            end
            if maze(j-1, i) == 0
              cnt = cnt + 1;
            end
            if maze(j+1, i) == 0
              cnt = cnt + 1;
            end
            if cnt == 3
              maze(j, i) = 0;
              flag = 0;
            end
          end
        end
      end
    end
    if flag
      break;
    end
  end
  x = [];
  y = [];
  for j = 1:height
    for i = 1:width
      if maze(j, i)
        x = [x i];
        y = [y j];
      end
    end
  end
end

