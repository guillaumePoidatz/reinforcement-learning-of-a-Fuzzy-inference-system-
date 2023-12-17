function FuzzyPoint = initFuzzyStructure(fisSructure2Copy)

for i_input = 1:length(fisSructure2Copy.Inputs())
    for i_fuzzy_set = 1:length(fisSructure2Copy.Inputs(i_input).mf())
        FuzzyPoint.input(i_input).fuzzy_set(i_fuzzy_set).support = zeros(1,2);
        FuzzyPoint.input(i_input).fuzzy_set(i_fuzzy_set).kernel = zeros(1,2);
    end
end
end