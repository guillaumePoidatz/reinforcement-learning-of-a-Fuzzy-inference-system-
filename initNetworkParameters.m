function nearest_points_limit = initNetworkParameters(Fuzzy_File_Id)

nearest_points_limit = 0;
n_inputs = length(Fuzzy_File_Id.Input());
for i_input = 1:n_inputs
    n_mfs = length(Fuzzy_File_Id.Input(i_input).mf);
    add2NearestPoints = (Fuzzy_File_Id.Input(i_input).Range(2)-Fuzzy_File_Id.Input(i_input).Range(1))^2;
    nearest_points_limit = nearest_points_limit + 2*n_mfs*add2NearestPoints;
end
nearest_points_limit = sqrt(nearest_points_limit)/5;

end