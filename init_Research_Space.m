function [point,Pg,P_results,Pg_result,Pg_criterias] = init_Research_Space(n_points,preconfig_fis_file_id,folder,simulink_file,simulink_fis,costFunction,markers_colors,criterias,numberOfInputs)

P_results_bis = zeros(length(criterias),n_points);

for k_point = 1:n_points
    point(k_point) = initFuzzyStructure(preconfig_fis_file_id);

    for i_input = 1:numberOfInputs
        numberOfPartition = length(preconfig_fis_file_id.Inputs(i_input).mf);
        
        for i_Partition=1:numberOfPartition
            preconfig_fis_Partition = preconfig_fis_file_id.Inputs(i_input).mf(i_Partition);
            

            % coompute of supports
            if i_Partition==1
                point(k_point).input(i_input).fuzzy_set(i_Partition).support = [preconfig_fis_Partition.params(1) preconfig_fis_Partition.params(4)];
            else 
                point(k_point).input(i_input).fuzzy_set(i_Partition).support(2) = preconfig_fis_Partition.params(4);
            end

            poInFs = point(k_point).input(i_input).fuzzy_set(i_Partition);
            l_support = poInFs.support(2)-poInFs.support(1)-0.1;
            offset_support = poInFs.support(1);

            % compute of kernels under strong fuzzy partition constraint
            if i_Partition==1 
                % first limit universe case
                point(k_point).input(i_input).fuzzy_set(i_Partition).kernel = [poInFs.support(1) rand()*l_support+offset_support];
                poInFs = point(k_point).input(i_input).fuzzy_set(i_Partition);

                point(k_point).input(i_input).fuzzy_set(i_Partition+1).support(1) = poInFs.kernel(2);
    
            elseif i_Partition==numberOfPartition
                % second limit universe case
                point(k_point).input(i_input).fuzzy_set(i_Partition).kernel = [rand()*l_support+offset_support poInFs.support(2)];
                poInFs = point(k_point).input(i_input).fuzzy_set(i_Partition);

                point(k_point).input(i_input).fuzzy_set(i_Partition-1).support(2) = poInFs.kernel(1);

            else
                % normal case
                % create random kernel under the constraint of their support
                point(k_point).input(i_input).fuzzy_set(i_Partition).kernel = [rand()*l_support+offset_support 0];
                poInFs = point(k_point).input(i_input).fuzzy_set(i_Partition);

                offset_kernel = poInFs.kernel(1);
                l_max_kernel = poInFs.support(2)-poInFs.kernel(1)-0.1;
                point(k_point).input(i_input).fuzzy_set(i_Partition).kernel(2) = rand()*l_max_kernel+offset_kernel;
                poInFs = point(k_point).input(i_input).fuzzy_set(i_Partition);

                % constraint of strong fuzzy partition
                point(k_point).input(i_input).fuzzy_set(i_Partition-1).support(2) = poInFs.kernel(1);
                point(k_point).input(i_input).fuzzy_set(i_Partition+1).support(1) = poInFs.kernel(2);

            end
        end
    end
end

P_results = zeros(1,n_points);
currentFis = preconfig_fis_file_id;

for k_point = 1:n_points
    for i_input = 1:numberOfInputs
        for i_Partition = 1:length(currentFis.Inputs(i_input).mf)
            % simulation with the new partitions
            poInFs = point(k_point).input(i_input).fuzzy_set(i_Partition);
            currentFis.Inputs(i_input).mf(i_Partition).params = [poInFs.support(1) poInFs.kernel(1) poInFs.kernel(2) poInFs.support(2)];
        end
    end
    writeFIS(currentFis,simulink_fis);
    sim(simulink_file);
    
    % visualisation of the convergence
    for i_criterias = 1:length(criterias)
        P_results_bis(i_criterias,k_point) = eval(criterias{i_criterias});
    end
    printEvolutionCriterias(1,P_results_bis(:,k_point),k_point,criterias,markers_colors,0)  
    
    P_results(k_point) = eval(costFunction);
    point(k_point).performance = P_results(k_point);
 
end

[Pg_result,Pg_index] = max(P_results);
bestFis = preconfig_fis_file_id;

for i_input = 1:numberOfInputs
    for i_Partition = 1:length(currentFis.Inputs(i_input).mf)
        PgInFs = point(Pg_index).input(i_input).fuzzy_set(i_Partition);
        bestFis.Inputs(i_input).mf(i_Partition).params = [PgInFs.support(1) PgInFs.kernel(1) PgInFs.kernel(2) PgInFs.support(2)];
    end
end

writeFIS(bestFis,[folder '/best_global_1'])
Pg = point(Pg_index);

Pg_criterias = P_results_bis(:,Pg_index);
printEvolutionCriterias(1,Pg_criterias,10,criterias,markers_colors,1);

initial_nearest_points_limit = initNetworkParameters(preconfig_fis_file_id);
for k_point = 1:n_points
    point(k_point).nearest_points_limit = initial_nearest_points_limit;
    distance = computeEuclidDistance(point,k_point);
    point = computeNetwork(point,k_point,distance);
end

end