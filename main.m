clear all;

height = 11;
width  = 21;

[maze, height, width] = create_maze(height, width, 100);

show_maze(height, width, maze);

