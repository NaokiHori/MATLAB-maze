function show_maze(ny, nx, maze)
  %SHOW_MAZE Visualize a maze, and allow user to solve it
  %  show_maze(ny, nx, maze) displays a figure of a given maze, whose size is "ny" by "nx".
  %  This function assumes the start is left bottom, while the goal right top.
  %  USER INPUT
  %  This function allows some user inputs as follows
  %    Arrow keys: move the cursor (red color) to the desired direction
  %    "g"       : give up and show the answer
  %    "q"       : quit the game

  % intial cursor position
  cursor = [2 2];
  % start and goal
  st_gl  = [[2 nx-1]; [2 ny-1]];
  x = linspace(1, nx, nx);
  y = linspace(1, ny, ny);
  fig = figure('keypressfcn', @keyhandler);
  fig.Position = [200 200 1000 600];
  hold on;
  imagesc(x, y, maze, [0 1]);
  fig.Colormap = gray;
  scatter(cursor(1), cursor(2), 60, 'filled', 'MarkerFaceColor', '#FF0000');
  scatter(st_gl(1, :), st_gl(2, :), 60, 'filled', 'MarkerFaceColor', '#0000FF');
  hold off;
  fig.Children.DataAspectRatio = [1 1 1];
  axes = fig.Children;
  axes.XLim = [1-0.5 nx+0.5];
  axes.YLim = [1-0.5 ny+0.5];
  axes.XTick = [];
  axes.YTick = [];
  setappdata(0, 'x', x);
  setappdata(0, 'y', y);
  setappdata(0, 'maze', maze);
  setappdata(0, 'cursor', cursor);
  setappdata(0, 'st_gl', st_gl);
  setappdata(0, 'cleared', false);
  setappdata(0, 'giveup', false);
end

function keyhandler(h, e)
  x = getappdata(0, 'x');
  y = getappdata(0, 'y');
  cleared = getappdata(0, 'cleared');
  giveup = getappdata(0, 'giveup');
  xmin = 1;
  xmax = length(x);
  ymin = 1;
  ymax = length(y);
  maze = getappdata(0, 'maze');
  cursor = getappdata(0, 'cursor');
  st_gl = getappdata(0, 'st_gl');
  switch e.Key
    case 'rightarrow'
      if maze(cursor(2), cursor(1)+1) == 1 && not(cleared) && not(giveup)
        cursor(1) = min([cursor(1)+1, xmax]);
      end
    case 'leftarrow'
      if maze(cursor(2), cursor(1)-1) == 1 && not(cleared) && not(giveup)
        cursor(1) = max([cursor(1)-1, xmin]);
      end
    case 'downarrow'
      if maze(cursor(2)-1, cursor(1)) == 1 && not(cleared) && not(giveup)
        cursor(2) = min([cursor(2)-1, ymax]);
      end
    case 'uparrow'
      if maze(cursor(2)+1, cursor(1)) == 1 && not(cleared) && not(giveup)
        cursor(2) = max([cursor(2)+1, ymin]);
      end
    case 'g'
      giveup = true;
    case 'q'
      close(h);
      return;
  end
  if (cursor(1) == st_gl(1, 2)) && (cursor(2) == st_gl(2, 2))
    cleared = true;
  end
  setappdata(0, 'maze', maze);
  setappdata(0, 'cursor', cursor);
  fig = figure(h);
  hold on;
  imagesc(x, y, maze, [0 1]);
  if giveup
    [ansx ansy] = solve_maze(ymax, xmax, maze);
    scatter(ansx, ansy, 60, 'filled', 'MarkerFaceColor', '#33AA00');
  else
    scatter(cursor(1), cursor(2), 60, 'filled', 'MarkerFaceColor', '#FF0000');
    scatter(st_gl(1, :), st_gl(2, :), 60, 'filled', 'MarkerFaceColor', '#0000FF');
  end
  hold off;
  fig.Children.DataAspectRatio = [1 1 1];
  if cleared
    fig.Name = 'clear';
  end
  if giveup
    fig.Name = 'answer';
  end
  setappdata(0, 'cleared', cleared);
  setappdata(0, 'giveup', giveup);
end

