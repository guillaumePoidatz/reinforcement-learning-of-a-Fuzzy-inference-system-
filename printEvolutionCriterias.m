function printEvolutionCriterias(numberOfSimu,system,numberOfPoint,criterias_Name,markers_colors,bestSystem)
numberOfCriterias = length(system);
for i_figure=1:numberOfCriterias
    add_points_to_figure(numberOfSimu,system(i_figure),i_figure,numberOfPoint,criterias_Name,markers_colors,bestSystem);
end
end

function add_points_to_figure(x,y,fig_number,number_legend,titles,markers_colors,bestSystem)

fig = findobj(figure(fig_number));

fig_title = get(gcf, 'Name');
if isempty(fig_title)
    titles_string = titles{fig_number};
    set(fig,'Name',titles_string);
    title(titles_string);
    xlim([0, Inf])
end

current_legend = ['particule',num2str(number_legend)];
markers_colors_string = markers_colors{number_legend};

hold on;

if bestSystem
    if ~any(strcmp(legend().String,'best_global'))
        plot(x,y,'rsquare', 'DisplayName','best_global');
    else
        plot(x,y,'rsquare','HandleVisibility','off');
    end

else

    if ~any(strcmp(legend().String,current_legend))
        plot(x,y,markers_colors_string, 'DisplayName', current_legend);
    else
        plot(x,y,markers_colors_string,'HandleVisibility','off');
    end

end

hold off;

end