run('../setup_analysis.m')
%%
W_lp.set_loopsfx('t0t1000', {'svm', 'raw'});
W_lp.overwrite_on
W_lp.parloopsfx('function_3D_projection', {'data_cleaned', 'pca_autosfx1', 'x1D_autosfx2'}, 'x3D', 'variable2')
W_lp.overwrite_off