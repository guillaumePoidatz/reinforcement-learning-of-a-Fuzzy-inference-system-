function point = computeNetwork(point,k_point,distance)

nearest_points_index = find(distance(k_point,:) < point(k_point).nearest_points_limit);
while length(nearest_points_index)<2
    point(k_point).nearest_points_limit = point(k_point).nearest_points_limit*1.1;
    nearest_points_index = find(distance(k_point,:) < point(k_point).nearest_points_limit);
end

while length(nearest_points_index)>5
    point(k_point).nearest_points_limit = point(k_point).nearest_points_limit*0.9;
    nearest_points_index = find(distance(k_point,:) < point(k_point).nearest_points_limit);
end

for k = 1:length(nearest_points_index)
    nearest_points_performance(k) = point(nearest_points_index(k)).performance;
end


nearest_points_performance(k+1) = point(k_point).performance;
[~,index] = min(nearest_points_performance);

if index==k+1
    point(k_point).index_best_nearest_points = k_point;
else
    point(k_point).index_best_nearest_points = nearest_points_index(index);
end
clear('index','nearest_points_performance')

end