masterdir = './TempData';
%%
addpath(genpath('./'));
%% loopers
W_lp_folder = W_looper_folder(masterdir);
W_lp_sfx = W_looper_sfx();
%% create jobs
jobs = W_job_looper;
%% setup pipeline for the main analysis
pip = W_pipeline_neuro({'folder','sfx'}, W_lp_folder, W_lp_sfx);
idxlist = [];
%% behavior
pip.pip_addstep_folder({'all','all'}, 'main_1_behaviors', {}, {'dataset'}, ...
    'outputnames', 'behavior_sub', ...
    'jobname', 'behavior');
tfiles = {'behavior_sub', 'behavior_sub_ddm'};
pip.pip_addstep_folder('all', 'main_2_calculate_evidence', {}, tfiles, ...
    'outputnames', 'sub', ...
    'jobname', 'behavior_evidence');
% stats - regression p(accept) vs entropy
pip.pip_addstep_folder({'all', 'all'}, 'main_3_regression_paccept_vs_entropy', {}, {'sub'}, ...
    'outputnames', 'stat_regression_paccept_vs_entropy', ...
    'jobname', 'stat_paccept_vs_entropy');
%% ANOVA
pip.add_template('spikes_cleaning');
pip.add_template('ANOVA')
%% PCA
pip.add_template('denoised_trajectories');
W_lp_sfx.next_sfx_ID;
W_lp_sfx.set_sfx('t0t1000')
pip.add_template_with_sfx(W_lp_sfx.sfxid, 'PCA');
%% decoding
W_lp_sfx.next_sfx_ID;
W_lp_sfx.set_sfx('t0t1000',{'first20', 'first50'});
pip.add_template_with_sfx(W_lp_sfx.sfxid, 'decoding');
%% projection to 1-D
idxlist.id_1D = W_lp_sfx.next_sfx_ID;
W_lp_sfx.add_sfx('t0t1000', {'mean', 'svmp'}, {'midRT'}, {'nstd'});
W_lp_sfx.add_sfx('t0t1000', {'svmp'}, {'midRT', 't0t1000'}, {'nstd'});
pip.add_template_with_sfx(idxlist.id_1D, 'project1D_custom');
%% calculate posterior
pip.add_template_with_sfx(idxlist.id_1D, 'posterior1D');
% %% decoding 1D
% pip.add_template('decoding1D', idxlist.id_1Danalysis);
%% energy landscape
idxlist.id_EL = W_lp_sfx.next_sfx_ID;
W_lp_sfx.add_sfx('t0t1000', {'svmp_midRT'}, {'nstd'}, {'npool1'}, {'choice'});
nwin = 50;
pip.pip_addstep_folder_sfx(idxlist.id_EL, 'function_energy_landscape', ...
    {'variable5', nwin, 'variable6'}, {'x1D_autosfx4', 'posterior1D_autosfx4'}, [4,5, 1,2,3],...
    'outputnames', 'EL_autosfx', 'jobname', 'EL');
%% 1D dynamics model
idxlist.id_1Dmodel = W_lp_sfx.next_sfx_ID;
% fit svm vs mean
W_lp_sfx.add_sfx("t0t1000", {'mean', 'svmp'}, {'midRT'}, {'nstd'}, "scaledEV", 'npool1');
% fit EV vs residue
W_lp_sfx.add_sfx("t0t1000", {'svmp'}, {'midRT'}, {'nstd'}, {'scaledEV', 'residue'}, 'npool1');
% fit based on location alone/soft
W_lp_sfx.add_sfx("t0t1000", {'svmp'}, {'midRT'}, {'nstd'}, {'scaledEVsoft'}, 'npool1');
% fit 1 basin
W_lp_sfx.add_sfx("t0t1000", {'svmp'}, {'midRT'}, {'nstd'}, "1basin", "npool1");
% fit reject only
W_lp_sfx.add_sfx("t0t1000", {'svmp'}, {'midRT'}, {'nstd'}, {'scaledEVrejectonly','scaledEVpyDDM', 'scaledEVpyDDMCB'}, "npool1");
% fit control
W_lp_sfx.add_sfx('t0t1000', {'svmp'}, {'midRT'}, 'nstd', 'control', 'npool1');
pip.pip_addstep_folder_sfx(idxlist.id_1Dmodel, 'function_1D_model', {'variable5', 'variable6_num', nwin}, ...
    {'x1D_autosfx4', 'posterior1D_autosfx4', 'sub'}, [4,5,6,1,2,3], 'outputnames', 'model1D_autosfx', ...
    'jobname', '1D model');
%% parameter recovery
% simulate data
W_lp_sfx.next_sfx_ID;
W_lp_sfx.set_sfx('t0t1000', {'svmp'}, {'midRT'}, {'nstd'}, 'scaledEV', {'npool1'});
pip.pip_addstep_folder_sfx(W_lp_sfx.sfxid,'function_simulate_games', {}, ...
    {'x1D_autosfx4', 'model1D_autosfx', 'sub'}, [], ...
    'simudata_autosfx');
% fit simulated data
pip.pip_addstep_folder_sfx(W_lp_sfx.sfxid, 'function_1D_model', {'variable5', 'variable6_num', nwin}, ...
    {'simudata_autosfx', 'posterior1D_autosfx4', 'sub'}, ...
    [4 5 6 1 2 3], 'outputnames', 'model1Dsimu_autosfx');
%% posterior predictive checks
W_lp_sfx.next_sfx_ID;
W_lp_sfx.set_sfx('t0t1000', {'svmp'}, {'midRT'}, {'nstd'}, {'npool1'}, 'choice');
pip.pip_addstep_folder_sfx(W_lp_sfx.sfxid, 'function_energy_landscape', ...
    {'variable5', nwin, 'variable6'}, {'simudata_t0t1000_svmp_midRT_nstd_scaledEV_npool1', 'simudata_t0t1000_svmp_midRT_nstd_scaledEV_npool1'}, [4,5, 1,2,3],...
    'outputnames', 'ELsimu_autosfx', 'jobname', 'EL');
%% model-3D
W_lp_sfx.next_sfx_ID;
W_lp_sfx.add_sfx('t0t1000', {'svmp'}, {'t0t1000'}, {'nstd'});
pip.pip_addstep_folder_sfx(W_lp_sfx.sfxid, 'function_3D_projection', {'variable2'}, ...
    {'pca_autosfx1', 'x1D_autosfx'}, 'outputnames', 'x3D_autosfx', 'jobname', 'project3D');
%% fit-3D
idxlist.id_3Dmodel = W_lp_sfx.next_sfx_ID;
W_lp_sfx.add_sfx('t0t1000', {'svmp'}, {'t0t1000'}, {'nstd'}, {'attractor'}, {'npool3'});
pip.pip_addstep_folder_sfx(idxlist.id_3Dmodel, 'function_3D_model', {'variable5', 'variable6_num', nwin}, ...
    {'x3D_autosfx4'}, [4,1,2,3], 'outputnames', 'model3D_autosfx', 'jobname', 'fit 3D');
%% positive vs negative neurons
pip.pip_addstep_folder([], 'function_ANOVA_posneg', {'movingwindow'}, {'dataset_final', 'sub'}, ...
    'outputnames', 'anova_posneg.mat', 'jobname', 'anova_posneg');
%% posneg: repeat model fitting for three groups of neurons
pip.pip_addstep_folder([], 'function_model_posneg', {nwin}, {'anova_posneg', 'dataset_final','sub'},[2,3,4,1], ...
    'outputnames', 'model1D_posneg.mat', 'jobname', 'pos neg model1D');
%% posneg: loadings on the choice dimension
pip.pip_addstep_folder([], 'function_loadings1D_posneg', {}, {'anova_posneg', 'pca_t0t1000', 'x1D_t0t1000_svmp_midRT_nstd'}, ...
    'outputnames', 'loadings_pos_neg');
%% mean firing rate
pip.pip_addstep_folder([], 'function_meanFR_posneg', {}, {'anova_posneg', 'dataset_final'}, ...
    'outputnames', 'meanFR_posneg');
%% generate jobs
jobs.add_jobs_from_pip(pip);
%% analysis for all versions
jobs.overwrite_off;
jobs.parfor_on;
jobs.run();
%% save for plotting
W.save(fullfile(masterdir, 'setting_jobs.mat'), 'W_lp_sfx', W_lp_sfx, 'idxlist', idxlist);
