function show_maze(maze)
  %SHOW_MAZE Visualize a maze, and allow user to solve it
  %  show_maze(maze) displays a figure of a given maze, which is a 2D array "height" by "width".
  %  This function assumes the start is left bottom, while the goal right top.
  %
  %  USER INPUT
  %  This function allows some user inputs as follows
  %    Arrow keys: move the cursor (red color) to the desired direction
  %    "g"       : give up and show the answer
  %    "q"       : quit the game
  %    otherwise ignored

  % get size of the maze
  [height, width] = size(maze);
  % intial cursor position
  cursor = [2 2];
  % start and goal
  st_gl  = [[2 width-1]; [2 height-1]];
  fig = figure('keypressfcn', @keyhandler);
  fig.Position = [200 200 1000 600];
  % show maze, cursor, and start-goal
  hold on;
  show_maze_field(maze);
  show_cursor(cursor);
  show_st_gl(st_gl);
  hold off;
  fig.Colormap = gray;
  % title (direction to user)
  fig.Children.Title.String = 'Move (Arrowkeys), show answer (g), quit (q)';
  fig.Children.Title.FontSize = 30;
  % set unity aspect ratio
  fig.Children.DataAspectRatio = [1 1 1];
  % remove axes labels, margin
  axes = fig.Children;
  axes.XLim = [1-0.5 width+0.5];
  axes.YLim = [1-0.5 height+0.5];
  axes.XTick = [];
  axes.YTick = [];
  % it is impossible to give params to / get params from the key-handling function
  % so use set/getappdata to achieve that
  % see e.g. https://jp.mathworks.com/help/matlab/creating_guis/share-data-among-callbacks.html#bt9p4t0
  setappdata(0, 'maze', maze);
  setappdata(0, 'cursor', cursor);
  setappdata(0, 'st_gl', st_gl);
  setappdata(0, 'cleared', false); % game clear flag
  setappdata(0, 'giveup', false);  % give-up flag
  return;
end

function keyhandler(handle, event)
  % get data set in the main displaying function "show_maze"
  maze    = getappdata(0, 'maze');
  cursor  = getappdata(0, 'cursor');
  st_gl   = getappdata(0, 'st_gl');
  cleared = getappdata(0, 'cleared');
  giveup  = getappdata(0, 'giveup');
  [height, width] = size(maze);
  % check user input from keyboard
  switch event.Key
    % for arrow keys, the cursor motion should be prohibited
    % if the neighbour point to the direction is wall
    % "if maze(cursor...)" statements are for this purpose
    % Also when the maze is cleared or the user gives up solving,
    % the motion should be banned, achived by "&& not(cleared) ..."
    case 'rightarrow'
      if maze(cursor(2), cursor(1)+1) == 1 && not(cleared) && not(giveup)
        cursor(1) = min([cursor(1)+1 width]);
      end
    case 'leftarrow'
      if maze(cursor(2), cursor(1)-1) == 1 && not(cleared) && not(giveup)
        cursor(1) = max([cursor(1)-1 1]);
      end
    case 'downarrow'
      if maze(cursor(2)-1, cursor(1)) == 1 && not(cleared) && not(giveup)
        cursor(2) = min([cursor(2)-1 height]);
      end
    case 'uparrow'
      if maze(cursor(2)+1, cursor(1)) == 1 && not(cleared) && not(giveup)
        cursor(2) = max([cursor(2)+1 1]);
      end
    % g: giveup
    case 'g'
      giveup = true;
    % q: quit
    case 'q'
      close(handle);
      return;
  end
  % When the cursor is at the goal position, clear
  if (cursor(1) == st_gl(1, 2)) && (cursor(2) == st_gl(2, 2))
    cleared = true;
  end
  % updte displayed contents
  fig = figure(handle);
  hold on;
  show_maze_field(maze);
  if giveup
    % if give-uped, show the answer instead of the cursor position and start/goal
    [ansx, ansy] = solve_maze(maze);
    scatter(ansx, ansy, 60, 'filled', 'MarkerFaceColor', '#33AA00');
  else
    % show cursor and start/goal
    show_cursor(cursor);
    show_st_gl(st_gl);
  end
  hold off;
  fig.Children.DataAspectRatio = [1 1 1];
  % change name based on the flags
  if cleared
    fig.Children.Title.String = 'clear (press q to close)';
  elseif giveup
    fig.Children.Title.String = 'answer (press q to close)';
  end
  % reset updated data in this handler
  setappdata(0, 'cursor', cursor);
  setappdata(0, 'cleared', cleared);
  setappdata(0, 'giveup', giveup);
  return;
end

function show_maze_field(maze)
  [height, width] = size(maze);
  imagesc(linspace(1, width, width), linspace(1, height, height), maze, [0 1]);
  return;
end

function show_cursor(cursor)
  scatter(cursor(1), cursor(2), 120, 'filled', 'MarkerFaceColor', '#FF0000');
  return;
end

function show_st_gl(st_gl)
  scatter(st_gl(1, :), st_gl(2, :), 60, 'filled', 'MarkerFaceColor', '#0000FF');
  return;
end

