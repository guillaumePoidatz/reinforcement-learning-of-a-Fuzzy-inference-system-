[n_points,n_connections,n_simu,fis_file_name,folder,simulink_file,simulink_fis,costFunction,criterias] = HMI_FL_Optimization();
markers_colors = init_all_markers_colors();

mkdir(folder);
preconfig_fis_file_id = readfis(fis_file_name);

PSO_Fuzzy_Partition(n_simu,n_points,preconfig_fis_file_id,folder,simulink_file,simulink_fis,costFunction,markers_colors,criterias);


function PSO_Fuzzy_Partition(n_simu,n_points,preconfig_fis_file_id,folder,simulink_file,simulink_fis,costFunction,markers_colors,criterias)

numberOfInputs = length(preconfig_fis_file_id.Inputs());
[Xn,Pg,P_results,Pg_result,Pg_criterias] = init_Research_Space(n_points,preconfig_fis_file_id,folder,simulink_file,simulink_fis,costFunction,markers_colors,criterias,numberOfInputs);

P = Xn;

% init particles speed
for k_point = 1:n_points
    Vn(k_point) = initFuzzyStructure(preconfig_fis_file_id);

    for i_input = 1:numberOfInputs
        numberOfPartition = length(preconfig_fis_file_id.Inputs(i_input).mf);
        for i_Partition = 1:length(Pg.input(i_input).fuzzy_set)
            fisInputI = preconfig_fis_file_id.Inputs(i_input);
            Vn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(1) = (rand()*(fisInputI.Range(2)-fisInputI.Range(1)) + fisInputI.Range(1))*0.1;
            Vn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(2) = (rand()*(fisInputI.Range(2)-fisInputI.Range(1)) + fisInputI.Range(1))*0.1;
        end
    end
end

k_simu = 2;
r1 = rand(1,n_points);

nbOfBestFis = 1;
currentFis = preconfig_fis_file_id;
bestFis = preconfig_fis_file_id;

for k_simu = 2:n_simu
    for k_point = 1:n_points
        
        [w, p1, p2] = setPSOParameters(k_simu,n_simu,r1,k_point);

        for i_input = 1:numberOfInputs
            numberOfPartition = length(preconfig_fis_file_id.Inputs(i_input).mf);
            for i_Partition = 1:length(Pg.input(i_input).fuzzy_set)
                vn = Vn(k_point).input(i_input).fuzzy_set(i_Partition);
                xn = Xn(k_point).input(i_input).fuzzy_set(i_Partition);
                Pki = P(k_point).input(i_input).fuzzy_set(i_Partition);
                Pg_res = Xn(Xn(k_point).index_best_nearest_points).input(i_input).fuzzy_set(i_Partition);
    
                Vn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(1) = w*vn.kernel(1) + p1*(Pki.kernel(1)-xn.kernel(1)) + p2*(Pg_res.kernel(1)-xn.kernel(1));
                Vn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(2) = w*vn.kernel(2) + p1*(Pki.kernel(2)-xn.kernel(2)) + p2*(Pg_res.kernel(2)-xn.kernel(2));
                vn = Vn(k_point).input(i_input).fuzzy_set(i_Partition);

    
                if i_Partition==1 
                    Xn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(2) = min(max(xn.support(1),xn.kernel(2) + vn.kernel(2)),xn.support(2)-0.1);
                    xn = Xn(k_point).input(i_input).fuzzy_set(i_Partition);

                    Xn(k_point).input(i_input).fuzzy_set(i_Partition+1).support(1) = xn.kernel(2);

                elseif i_Partition==numberOfPartition
                    Xn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(1) = min(max(xn.support(1)+0.1,xn.kernel(1) + vn.kernel(1)),xn.support(2));
                    xn = Xn(k_point).input(i_input).fuzzy_set(i_Partition);

                    Xn(k_point).input(i_input).fuzzy_set(i_Partition-1).support(2) = xn.kernel(1);

                else
                    Xn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(1) = min(max(xn.support(1)+0.1,xn.kernel(1) + vn.kernel(1)),xn.support(2)-0.1);
                    xn = Xn(k_point).input(i_input).fuzzy_set(i_Partition);

                    Xn(k_point).input(i_input).fuzzy_set(i_Partition).kernel(2) = min(max(xn.kernel(1),xn.kernel(2) + vn.kernel(2)),xn.support(2)-0.1);
                    xn = Xn(k_point).input(i_input).fuzzy_set(i_Partition);
                    
                    % constraint of strong fuzzy partition
                    Xn(k_point).input(i_input).fuzzy_set(i_Partition-1).support(2) = xn.kernel(1);
                    Xn(k_point).input(i_input).fuzzy_set(i_Partition+1).support(1) = xn.kernel(2);
                end
            end
        end

        % compute the new performances
        for i_input = 1:numberOfInputs
            for i_Partition = 1:numberOfPartition
                xn = Xn(k_point).input(i_input).fuzzy_set(i_Partition);
                currentFis.Inputs(i_input).mf(i_Partition).params = [xn.support(1),xn.kernel(1),xn.kernel(2),xn.support(2)];
            end
        end
        writeFIS(currentFis,simulink_fis);
        sim(simulink_file);

        % compute of the evolution of criterias
        for i_criterias = 1:length(criterias)
            performance_bis(i_criterias,k_point) = eval([criterias{i_criterias}]);
        end
        printEvolutionCriterias(k_simu,performance_bis(:,k_point),k_point,criterias,markers_colors,0);

        performance = eval(costFunction);
        Xn(k_point).performance = performance;
        
        % Compute the individual best
        if performance > P_results(k_point)
            P_results(k_point) = performance;
            P(k_point) = Xn(k_point);

            % to change
            performanceSave = ...;
            % Compute the global best
             if performanceSave > Pg_result
                Pg_result = performanceSave;
                Pg = Xn(k_point);
                Pg_criterias = performance_bis(:,k_point);

                % save the best one
                for i_input = 1:numberOfInputs
                    for i_Partition = 1:numberOfPartition
                        xn = Xn(k_point).input(i_input).fuzzy_set(i_Partition);
                        bestFis.Inputs(i_input).mf(i_Partition).params = [xn.support(1), xn.kernel(1), xn.kernel(2), xn.support(2)];
                    end
                end
                
                nbOfBestFis = nbOfBestFis+1;
                writeFIS(bestFis,[folder '/best_global_' num2str(nbOfBestFis)]);
             end
        end
        
        initial_nearest_points_limit = initNetworkParameters(preconfig_fis_file_id);
        distance = computeEuclidDistance(Xn,k_point);
        Xn(k_point).nearest_points_limit = initial_nearest_points_limit;
        Xn = computeNetwork(Xn,k_point,distance);

    end

    % visualisation of the convergence
    printEvolutionCriterias(k_simu,Pg_criterias,k_point,criterias,markers_colors,1);

end
end