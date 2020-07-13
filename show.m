clear all;


show_maze;

function [] = show_maze()
  nx = 20;
  ny = 10;
  ptrx = 1;
  ptry = 1;
  mat = ones([ny nx]);
  mat(ptry, ptrx) = ~mat(ptry, ptrx);
  x = linspace(0.5, nx-0.5, nx);
  y = linspace(0.5, ny-0.5, ny);
  fig = figure('keypressfcn', @keyhandler);
  imagesc(x, y, mat, [0 1]);
  fig.Colormap = gray;
  setappdata(0, 'x', x);
  setappdata(0, 'y', y);
  setappdata(0, 'mat', mat);
  setappdata(0, 'ptrx', ptrx);
  setappdata(0, 'ptry', ptry);
  function [] = keyhandler(h, e)
    x = getappdata(0, 'x');
    y = getappdata(0, 'y');
    xmin = 1;
    xmax = length(x);
    ymin = 1;
    ymax = length(y);
    mat = getappdata(0, 'mat');
    ptrx = getappdata(0, 'ptrx');
    ptry = getappdata(0, 'ptry');
    switch e.Key
      case 'rightarrow'
        ptrx = min([ptrx+1, xmax]);
      case 'leftarrow'
        ptrx = max([ptrx-1, xmin]);
      case 'downarrow'
        ptry = min([ptry+1, ymax]);
      case 'uparrow'
        ptry = max([ptry-1, ymin]);
    end
    mat(ptry, ptrx) = ~mat(ptry, ptrx);
    setappdata(0, 'mat', mat);
    setappdata(0, 'ptrx', ptrx);
    setappdata(0, 'ptry', ptry);
    fig = figure(h);
    imagesc(x, y, mat, [0 1]);
    fig.Colormap = gray;
  end
end

