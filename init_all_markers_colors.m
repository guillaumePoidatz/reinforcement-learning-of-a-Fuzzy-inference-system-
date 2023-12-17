function combinations = init_all_markers_colors()

colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k'};
markers = {'*', 'o', '+', '.', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'};
combinations = {};

for i = 1:length(markers)
    for j = 1:length(colors)
        combination = [colors{j}, markers{i}];     
        combinations = [combinations, combination];
    end
end
end