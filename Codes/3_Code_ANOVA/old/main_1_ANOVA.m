run('../setup_analysis.m')
%% anova
W_lp.parloop('function_ANOVA', {'dataset'}, 'anova.mat');
%% keep only sig units
W_lp.loop('function_cleanspikes', {'dataset', 'anova'}, {'data_cleaned', 'spikes_cleaning_info'}, 'pos_data', [1, -1], 0, 0.2, 0.05);

% %%
% ses = W.dir(datadir, 'folder');
% nses = size(ses,1);
% W.parpool(8)
% parfor si = 1:nses
%     sdir = ses.fullpath(si);
%     data = W.load(fullfile(sdir, 'dataset.mat'));
%     savename = fullfile(sdir, 'anova.mat');
%     [wv_anova] = main_ANOVA(data, savename, false);
%     %% keep only sig units
%     [data, spikes_cleaning_info] = W.clean_spikes(data, 0, 0.2, 0.05, wv_anova);
%     savename = fullfile(sdir, 'spikes_cleaning_info.mat');
%     W.save(savename, 'spikes_cleaning_info', spikes_cleaning_info);
%     savename = fullfile(sdir, 'data_cleaned.mat');
%     W.save(savename, 'data', data);
% end
% W.parclose;
