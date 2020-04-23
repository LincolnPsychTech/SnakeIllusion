function snake = snakeillusion(ax, snakeMode, noSpokes, ringSpec, resSpec, pct, sz)
% Function to draw a rotating snake illustion to specified axis.
% Inputs: 
% ax = Handle of axis to draw snake to
% snakeMode = Kind of illustion (1 = expanding, 2 = contracting, 3 = rotating clockwise, 4 = rotating counter clockwise
% noSpokes = Number of spokes
% ringSpec = Number of rings
% resSpec = Angle interval at which points on the segment circumference are defined
% pct = Perspecive factor, differs ring sizes by an exponential to give the illusion of depth 
% sz = Size of the snake relative to the screen
% Output:
% snake = An array of object handles, each corresponding to a segment, organised such that one can be accessed by calling snake(ring, spoke)

%% Spec
% Throw errors if user supplies invalid input
if mod(noSpokes, 2) ~= 0
    error("Number of spokes must be even.")
end
if ringSpec < 1
    error("Must have at least 1 ring")
end
if resSpec < 1
    error("Resolution is too low, segments must be defined by at least 4 points (resolution of 1).")
end
if sz <= 0
    error("Size must be positive")
end

res = 360/(noSpokes*resSpec); % Use specified resolution to calculate theta interval at which points are defined
noRings = ringSpec + 1; % Add 1 to specified number of rings to account for one being removed later

%% Calculate angles and radiae
beforeSpoke = [0:360/noSpokes:360]; beforeSpoke(end) = []; % Use number of spokes to get inner angles
afterSpoke = [0:360/noSpokes:360]; afterSpoke(1) = []; % Use number of spokes to get outer angles
innerRad = [sz/noRings:sz/noRings:sz]; innerRad(end) = []; % Use number of rings to get inner radiae of rings
outerRad = [sz/noRings:sz/noRings:sz]; outerRad(1) = []; % Use number of rings to get outer radiae of rings

innerRad = innerRad.^pct ./ sz.^(pct-1); % Exponentialise inner ring radiae
outerRad = outerRad.^pct ./ sz.^(pct-1); % Exponentialise outer ring radiae

%% Draw illusion
for r = 1:noRings-1 % For each ring...
    for sp = 1:noSpokes % For each spoke...
        theta = beforeSpoke(sp):res:afterSpoke(sp); % Get every angle within spoke
        x = struct(...
            'inner', sind(theta)*innerRad(r), ... % Inner ring x coords
            'outer', sind(theta)*outerRad(r) ... % Outer ring x coords
            );
        y = struct(...
            'inner', cosd(theta)*innerRad(r), ... % Inner ring y coords
            'outer', cosd(theta)*outerRad(r) ... % Outer ring y coords
            );
        switch snakeMode % Switch how colours are mapped depending on which kind of snake illustion you want to draw
            case 1 % Expanding
                c = struct(...
                    'inner', zeros(1, length(theta)) + 0.1, ... % Inner ring colour values
                    'outer', ones(1, length(theta)) - 0.1 ... % Outer ring colour values
                    );
            case 2 % Contracting
                c = struct(...
                    'inner', ones(1, length(theta)) - 0.1, ... % Inner ring colour values
                    'outer', zeros(1, length(theta)) + 0.1 ... % Outer ring colour values
                    );
            case 3 % Rotating clockwise
                c = struct(...
                    'inner', (theta - min(theta))./max(theta - min(theta)) + 0.1, ... % Inner ring colour values
                    'outer', (theta - min(theta))./max(theta - min(theta)) + 0.1 ... % Outer ring colour values
                    );
            case 4 % Rotating counter clockwise
                c = struct(...
                    'inner', fliplr((theta - min(theta))./max(theta - min(theta)) + 0.1), ... % Inner ring colour values
                    'outer', fliplr((theta - min(theta))./max(theta - min(theta)) + 0.1) ... % Outer ring colour values
                    );
        end
        
        snake(r, sp) = patch(ax, ... % Create a shape with...
            'XData', [x.outer, fliplr(x.inner)], ... % The specified x coordinates
            'YData', [y.outer, fliplr(y.inner)], ... % The specified y coordinates
            'CData', repmat([c.outer, fliplr(c.inner)], 1, 1, 3), ... % The specified colour values for each point
            'EdgeAlpha', 0, ... % No border
            'facecol', 'interp' ... % If a point on the inner ring is a colour and a point on the outer ring is the same colour, then the line between will be that colour. If one line is a colour and another line is another colour, the face between will be a gradient from one colour to the other.
            );
        
        if mod(sp, 2) == mod(r, 2) % If on an even spoke and even ring or odd spoke and odd ring...
            snake(r, sp).CData = 1-snake(r, sp).CData.*0.5; % Transform colour data to be light & inverted
        else
            snake(r, sp).CData = snake(r, sp).CData.*0.5; % Transform colour data to be dark
        end
    end
end
