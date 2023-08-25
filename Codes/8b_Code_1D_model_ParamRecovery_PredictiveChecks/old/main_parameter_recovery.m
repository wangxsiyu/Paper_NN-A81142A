run('../../setup_analysis.m');
%% fit simulated data
W_lp.parloop(8,'main_1D_model', {'data_cleaned', 'sub', 'simulated_x1D_scaledEV'}, 'fit_simulated_x1D_scaledEV', 1, ...
    'scaledEV');
%% calculate correlation
pr = W_lp.load({'model1D_scaledEV_x1Dsvm_t0t1000_npool1', 'fit_simulated_x1D_scaledEV'});
%% figure
figdir = './Figures';
run('../../setup_plot.m')
plt.figure(3,4);
plt = fig_param_recover(plt, pr{1}.model1D_scaledEV_x1Dsvm_t0t1000_npool1, pr{1}.fit_simulated_x1D_scaledEV);
plt.update('param_recover');
