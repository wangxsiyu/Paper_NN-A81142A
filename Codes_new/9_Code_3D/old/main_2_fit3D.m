run('../setup_analysis.m')
%%
% W_lp.loopdelete('*model3D*')
W_lp.set_loopsfx('t0t1000', {'svm', 'raw'}, {'npool1', 'npool3'});
W_lp.overwrite_on;
W_lp.parloopsfx('function_fit3D', {'x3D_autosfx2', 'data_cleaned'}, 'model3D', 'variable3_num');
W_lp.overwrite_off;