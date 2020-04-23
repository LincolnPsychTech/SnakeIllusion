clear all
close all

%% Specifications
snakeMode = listdlg('ListString', {'Expand', 'Contract', 'Rotate Clockwise', 'Rotate Counter Clockwise'});

resp = inputdlg({... % Create dialog to get specifications
        "Number of spokes" ...
        "Number of rings" ...
        "Resolution (how many circumference points per segment)" ...
        "Perspective (differ ring sizes by an exponential to give the illusion of depth)" ...
        "Size (relative to window)" ...
    }, ...
    "Specifications", ...
    1, ...
    {... % Default values
        '24' ...
        '8' ...
        '10' ...
        '2.5' ...
        '0.8' ...
    });
try % Extract values from dialog input
    noSpokes = str2double(resp{1});
    ringSpec = str2double(resp{2});
    resSpec = str2double(resp{3});
    pct = str2double(resp{4});
    sz = str2double(resp{5});
catch
    error("All inputs must be numeric")
end

%% Create figure
fig = figure(... % Create figure
    'Position', [100, 100, 800, 800]... % Figure size (x, y, width, height)
    );
ax = axes(fig, ... % Create axis within figure
    'Position', [0 0 1 1], ... % Occupy full figure
    'Color', [0 0 0], ... % Black background
    'XLim', [-1 1], ... % Coordinates from -1-1
    'YLim', [-1 1] ... % Coordinates from -1-1
    );
hold on

%% Draw snake
snake = snakeillusion(ax, snakeMode, noSpokes, ringSpec, resSpec, pct, sz);