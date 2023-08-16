%% setup directory
addpath(genpath('./'));
%% create jobs
jobs = W_job_queue;
%% setup pipeline for the main analysis
pip = W_pipeline();
pip.poweroff;
pip.pip_addstep('main_analysis', {'looperdir'}, ...
    'loopers', 'epoch_version', ...
    'pipname', 'main_analysis');
pip.poweron;
% pip.poweroff;
pip.pip_addstep('main_figures', {'looperdir'}, ...
    'loopers', 'epoch_version', ...
    'pipname', 'main_figures');
%% loopers
W_lp_ver = W_looper_folder('./TempData');
%% generate jobs
jobs.create_jobs_from_pip(pip, {'epoch_version'}, W_lp_ver);
%% analysis for all versions
jobs.parfor_off;
jobs.run();

