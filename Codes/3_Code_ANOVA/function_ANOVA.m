function [anova] = function_ANOVA(option, data)
    factornames = {'choice','drop','delay'};
    model = [1,0,0;0,1,0;0,0,1;0,1,1];
    [anova] = W.neuro_ANOVA(option, data, factornames, 'window_significance', [0 1000], ...
        'model', model);
end