run('../setup_analysis.m');
%% fit simulated data
W_lp.parloop('function_1D_model', {'data_cleaned', 'sub', 'simudata_model1D_t0t1000_svm_scaledEV_npool1'}, ...
    'fit_simudata_model1D_t0t1000_svm_scaledEV_npool1', ...
     [], 'scaledEV', 1);
%% calculate correlation
pr = W_lp.load({'model1D_t0t1000_svm_scaledEV_npool1', ...
    'fit_simudata_model1D_t0t1000_svm_scaledEV_npool1'},[],'cell');
%% figure
figdir = './Figures';
run('../setup_plot.m')
plt.figure(3,4);
plt = fig_param_recover(plt, pr{10,1}, pr{10,2});
plt.update('param_recover');
