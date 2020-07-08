clear all;


nx = 20;
ny = 10;
mat = rand([ny, nx]);
show_maze(mat);

function show_maze(mat)
  [ny, nx] = size(mat);
  x = linspace(0.5, nx-0.5, nx);
  y = linspace(0.5, ny-0.5, ny);
  fig = figure(1);
  imagesc(x, y, mat);
  fig.Colormap = gray;
  return;
  while true
    coords = ginput(1);
    i = ceil(coords(1));
    j = ceil(coords(2));
    disp(coords);
    disp(i);
    disp(j);
    mat(j, i) = ~mat(j, i);
    imagesc(x, y, mat);
  end
end
