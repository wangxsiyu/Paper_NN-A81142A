run('../setup_plot.m');
%%
EL = W_lp.load({'EL_t0t1000_svm_npool1_soft'},[],'cell');
time_EL = EL{1}.time_EL;
%%
FIG_Gradient_by_cue(plt, EL, sub, 'median')
%%
FIG_Energy_landscape_by_cue(plt, EL, sub, 'median')