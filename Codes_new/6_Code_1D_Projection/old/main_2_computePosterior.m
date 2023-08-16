run('../setup_analysis.m')
%%
W_lp.set_loopsfx('t0t1000', {'svm', 'svm1000'});
W_lp.parloopsfx('function_1D_calcpos', {'x1D_autosfx2', 'data_cleaned'}, 'Pos1D', 'variable1');
