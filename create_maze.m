function [maze, height, width] = create_maze(height, width, seed)
  %CREATE_MAZE Two-dimensional maze generator
  %  create(height, width) generates a maze having "height" by "width".
  %  "height" and "width" should be odd numbers larger than 5.
  %  The third parameter is optional and designate the random seed

  % decide random seed, if given, use the input
  if not(exist('seed', 'var'))
    seed = 0;
  end
  rng(seed);
  [height, width] = sanitize_input(height, width);
  % initialize the maze field "maze" with 0
  % 1 means the cell is digged
  maze = zeros([height width]);
  % start digging from this point
  i = 2;
  j = 2;
  maze(j, i) = 1;
  while true
    % walk randomly and dig as far as possible
    maze = digg_recursively(height, width, maze, i, j);
    % search for next starting point
    [next_exists, i, j] = decide_next_start(height, width, maze);
    % no more cells to be digged, finished
    if not(next_exists)
      break;
    end
  end
  return;
end

function [height, width] = sanitize_input(height, width)
  % check whether the input parameters, height/width, are
  % 1. greater than or equal to 5
  % 2. odd numbers
  if height < 5
    fprintf('The input parameter "height" is smaller than 5 (%d), set to 5\n', height);
    height = 5;
  end
  if width < 5
    fprintf('The input parameter "width" is smaller than 5 (%d), set to 5\n', width);
    width = 5;
  end
  if mod(height, 2) ~= 1
    fprintf('The input parameter "height" is not an odd number (%d), set to %d\n', height, height+1);
    height = height + 1;
  end
  if mod(width, 2) ~= 1
    fprintf('The input parameter "width" is not an odd number (%d), set to %d\n', width, width+1);
    width = width + 1;
  end
  return;
end

function maze = digg_recursively(height, width, maze, i, j)
  % dig the maze randomly
  while true
    % decide which direction to go
    directions = randperm(4);
    updated = false;
    for direction = directions
      % check whether we can move to the direction,
      % i.e. "digg"able
      if is_diggable(height, width, direction, i, j, maze)
        % If so, dig to the direction, and update the current position
        [i, j, maze] = dig(direction, maze, i, j);
        updated = true;
        break;
      end
    end
    if not(updated)
      % no more place to dig from the current position
      % go back and find next starting position
      return;
    end
  end
  return;
end

function [next_exists, next_i, next_j] = decide_next_start(height, width, maze)
  % search for the next starting point to dig
  % from points already digged
  % create a list of points already digged
  digged = [];
  for j = 2:2:height-1
    for i = 2:2:width-1
      if maze(j, i)
        digged = [digged; [i j]];
      end
    end
  end
  % walk through the already-digged list randomly
  % and find out a point which can be started to dig again
  num_of_digged = size(digged, 1);
  for n = randperm(num_of_digged)
    % check the point (i, j)
    i = digged(n, 1);
    j = digged(n, 2);
    % check four directions
    % if at least one direction is digg"able",
    % start from the point (next_i, next_j)
    next_exists = ...
         is_diggable(height, width, 1, i, j, maze) ...
      || is_diggable(height, width, 2, i, j, maze) ...
      || is_diggable(height, width, 3, i, j, maze) ...
      || is_diggable(height, width, 4, i, j, maze);
    if next_exists
      next_i = i;
      next_j = j;
      return;
    end
  end
  % no more points to digg
  % finish creating the maze
  next_i = 0;
  next_j = 0;
  return;
end

function tf = is_diggable(height, width, direction, i, j, maze)
  % check whether we can dig to the direction
  % directions are,
  % 1. left, 2. right, 3. down, 4. up
  % we cannot do so (tf=0) if
  % 1. the point (two point far from the current) is outside the domain
  % 2. the point (two point far from the current) has already been digged
  % otherwise possible (tf=1)
  switch direction
    case 1
      if i-2 < 1
        tf = 0;
        return;
      elseif maze(j, i-2) == 1
        tf = 0;
        return;
      else
        tf = 1;
        return;
      end
    case 2
      if i+2 > width
        tf = 0;
        return;
      elseif maze(j, i+2) == 1
        tf = 0;
        return;
      else
        tf = 1;
        return;
      end
    case 3
      if j-2 < 1
        tf = 0;
        return;
      elseif maze(j-2, i) == 1
        tf = 0;
        return;
      else
        tf = 1;
        return;
      end
    case 4
      if j+2 > height
        tf = 0;
        return;
      elseif maze(j+2, i) == 1
        tf = 0;
        return;
      else
        tf = 1;
        return;
      end
  end
  return;
end

function [i, j, maze] = dig(direction, maze, i, j)
  % dig to the designated direction
  % two cells to the direction are set to 1
  % the current position (i, j) is also moved
  switch direction
    case 1 % left
      maze(j, i-1) = 1;
      maze(j, i-2) = 1;
      i = i - 2;
    case 2 % right
      maze(j, i+1) = 1;
      maze(j, i+2) = 1;
      i = i + 2;
    case 3 % down
      maze(j-1, i) = 1;
      maze(j-2, i) = 1;
      j = j - 2;
    case 4 % up
      maze(j+1, i) = 1;
      maze(j+2, i) = 1;
      j = j + 2;
  end
  return;
end

