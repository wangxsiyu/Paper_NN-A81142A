run('../setup_plot.m')
%%
W_lp.overwrite_on;
W_lp.parloop('function_ANOVA_posneg', {'data_cleaned', 'sub'}, 'anova_pos_neg');
W_lp.overwrite_off;
%% repeat analysis for three groups of neurons
W_lp.parloop('function_model_pos_neg', {'anova_pos_neg', 'data_cleaned','sub'}, 'results_pos_neg_mix')


