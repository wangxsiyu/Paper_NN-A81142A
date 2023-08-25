run('../setup_analysis.m')
%%
W_lp.set_loopsfx('t0t1000', 'svm', 'scaledEV', 'npool1');
%%
W_lp.loopsfx('function_energy_landscape', {'data_cleaned', 'simudata_model1D_autosfx'}, ...
     'simudata_EL', [],'variable4_num', 'choice');


% ver_pca = {'t0t1000'};
% ver_1Dproj = {'svm'};
% ver_npool = [3];
% versions = W.get_combinations(ver_npool, ver_pca, ver_1Dproj);
%% fit all versions
% addpath('../../7_Code_1D_landscape/')
% for veri = 1:size(versions,1)
%     vers = versions(veri,:);
%     npool = vers.ver_npool;
%     W_lp.loop('main_energy_landscape', {'data_cleaned', 'simulated_x1D_scaledEV'}, ...
%         'simulated_EL', npool);
% end
%%
figdir = './Figures';
run('../setup_plot.m')
%%
EL = W_lp.load('simudata_EL_t0t1000_svm_scaledEV_npool1',[], 'cell');
EL0 = W_lp.load('EL_t0t1000_svm_npool1_choice',[], 'cell');
%% Energy landscape side by side
plt.figure(1,2,'is_title', 1, 'gapW_custom', [0 1 1] * 100);
FIG_Energy_landscape_by_cue(plt, EL, sub, 'median')
plt.update('EL_ppc');