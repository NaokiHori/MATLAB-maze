function [ansx, ansy] = solve_maze(maze)
  %SOLVE_MAZE return answer of the given input maze "maze"
  %  If three neighbours are wall (0), the point is not on the path from start to goal.
  %  (except start and goal)
  %  So assume the point is also a part of wall.
  %  Repeat this procedure.
  %  Return the answer x/y points
  [height, width] = size(maze);
  while true
    updated = false;
    % check all points
    for j = 2:height-1
      for i = 2:width-1
        % exclude start and goal
        if ( not(j==2&&i==2) && not(j==height-1&&i==width-1) )
          if maze(j, i) == 1
            % count walls around the cell
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
              % 3 around cells are wall, so this cell is also wall
              maze(j, i) = 0;
              updated = true;
            end
          end
        end
      end
    end
    if not(updated)
      % no update anymore, i.e. only the right path remains
      break;
    end
  end
  % create two vectors x/y of the right path to show as a scatter plot
  ansx = [];
  ansy = [];
  for j = 1:height
    for i = 1:width
      if maze(j, i) == 1
        % append
        ansx = [ansx i];
        ansy = [ansy j];
      end
    end
  end
  return;
end

