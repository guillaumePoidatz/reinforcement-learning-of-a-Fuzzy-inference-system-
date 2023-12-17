function [nb_points,nb_connections,nb_iterations,fis_file_name,folder,simulink,fis_simulation,costFunction,criterias] = HMI_FL_Optimization()

prompt = {'Number of points :','Number of connections :','Number of iterations','Pre-config FIS File :',...
    'Folder for results','Simulink for simulation','Fis inside your simulink',...
    'Enter the cost function that we have to maximize','Enter the number of criterias'};
def = {'','','','','','','','',''};

% HMI name
name = 'Settings';

size = 2;

answer = inputdlg(prompt,name,size,def);

if isempty(answer)
    disp('action annulée');
    return;
end

nb_points = str2num(answer{1});
nb_connections = str2num(answer{2});
nb_iterations = str2num(answer{3});
fis_file_name = answer{4};
folder = answer{5};
simulink = answer{6};
fis_simulation = answer{7};
costFunction = answer{8};
numberCriterias = str2num(answer{9});

criterias = HMI_Criterias(numberCriterias);

end

function criteria = HMI_Criterias(numberCriterias)

for i_criteria=1:numberCriterias
    prompt = {'What criteria'};
    def = {''};
    name = 'Criteria';
    size = 1;
    answer = inputdlg(prompt,name,size,def);
    if isempty(answer)
        disp('action annulée');
        return,
    end
    criteria{i_criteria} = answer{1};
end
end
