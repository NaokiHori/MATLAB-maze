function show_maze(ny, nx, maze)
  ptrx = [2 nx-1];
  ptry = [2 ny-1];
  x = linspace(1, nx, nx);
  y = linspace(1, ny, ny);
  fig = figure('keypressfcn', @keyhandler);
  fig.Position = [200 200 1000 600];
  hold on;
  imagesc(x, y, maze, [0 1]);
  fig.Colormap = gray;
  scatter(ptrx, ptry, 60, 'filled', 'MarkerFaceColor', '#FF0000');
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
  setappdata(0, 'ptrx', ptrx);
  setappdata(0, 'ptry', ptry);
  setappdata(0, 'cleared', false);
end

function keyhandler(h, e)
  x = getappdata(0, 'x');
  y = getappdata(0, 'y');
  cleared = getappdata(0, 'cleared');
  xmin = 1;
  xmax = length(x);
  ymin = 1;
  ymax = length(y);
  maze = getappdata(0, 'maze');
  ptrx = getappdata(0, 'ptrx');
  ptry = getappdata(0, 'ptry');
  switch e.Key
    case 'rightarrow'
      if maze(ptry(1), ptrx(1)+1) == 1 && not(cleared)
        ptrx(1) = min([ptrx(1)+1, xmax]);
      end
    case 'leftarrow'
      if maze(ptry(1), ptrx(1)-1) == 1 && not(cleared)
        ptrx(1) = max([ptrx(1)-1, xmin]);
      end
    case 'downarrow'
      if maze(ptry(1)-1, ptrx(1)) == 1 && not(cleared)
        ptry(1) = min([ptry(1)-1, ymax]);
      end
    case 'uparrow'
      if maze(ptry(1)+1, ptrx(1)) == 1 && not(cleared)
        ptry(1) = max([ptry(1)+1, ymin]);
      end
    case 's'
      [ptrx, ptry] = solve_maze(ymax, xmax, maze);
      cleared = true;
    case 'q'
      close(h);
      return;
  end
  if (ptrx(1) == ptrx(2)) && (ptry(1) == ptry(2))
    setappdata(0, 'cleared', true);
  end
  setappdata(0, 'maze', maze);
  setappdata(0, 'ptrx', ptrx);
  setappdata(0, 'ptry', ptry);
  fig = figure(h);
  hold on;
  if cleared
    fig.Name = 'clear';
  end
  imagesc(x, y, maze, [0 1]);
  scatter(ptrx, ptry, 60, 'filled', 'MarkerFaceColor', '#FF0000');
  hold off;
  fig.Children.DataAspectRatio = [1 1 1];
end

