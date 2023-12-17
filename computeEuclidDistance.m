
function distance = computeEuclidDistance(point,k_point)

n_points = length(point);
n_inputs = length(point(k_point));

for k_other_point = 1:n_points

    distance(k_point,k_other_point) = 0;
    for i_input = 1:n_inputs
        n_fuzzy_sets = length(point(k_point).input(i_input));
        for i_Partition = 1:n_fuzzy_sets
            PkIFsK1 = point(k_point).input(i_input).fuzzy_set(i_Partition).kernel(1);
            PkoIFsK1 = point(k_other_point).input(i_input).fuzzy_set(i_Partition).kernel(1);

            PkIFsK2 = point(k_point).input(i_input).fuzzy_set(i_Partition).kernel(2);
            PkoIFsK2 = point(k_other_point).input(i_input).fuzzy_set(i_Partition).kernel(2);

            distance(k_point,k_other_point) = distance(k_point,k_other_point) + (PkIFsK1-PkoIFsK1)^2 + (PkIFsK2-PkoIFsK2)^2;
        end
    end
    distance(k_point,k_other_point) = sqrt(distance(k_point,k_other_point));
    if k_point == k_other_point
        distance(k_point,k_other_point) = inf;
    end
end
end