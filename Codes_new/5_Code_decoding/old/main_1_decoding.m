run('../setup_analysis.m')
W_lp.add_sfx('t0t1000');
%% decoding
W_lp.overwrite_on;
W_lp.parloop('function_decoding', {'pca_autosfx', 'data_cleaned'}, 'decoding', -3, false);

W_lp.parloop('function_decoding', {'pca_autosfx', 'data_cleaned'}, 'decoding', 3, false);
W_lp.parloop('function_decoding', {'pca_autosfx', 'data_cleaned'}, 'decoding', 50, false);
W_lp.parloop('function_decoding', {'pca_autosfx', 'data_cleaned'}, 'decoding', 20, true);
%% decode based on 1-D
W_lp.set_loopsfx('t0t1000', {'svm', 'svm1000', 'svm2000'});
W_lp.set_auto_parclose(0);
W_lp.parloopsfx('function_decoding_1D', ...
    {'x1D_autosfx2', 'data_cleaned'}, 'decoding1D', true);

% ses = W.dir(datadir, 'folder');
% nses = size(ses,1);
% W.parpool(8);
% parfor si = 1:nses
%     sdir = ses.fullpath(si);
%     data = W.load(fullfile(sdir, 'data_cleaned.mat'));
%     wv_pc = W.load(fullfile(sdir, sprintf('pca_%s.mat', ver_pca)));
%     %%
%     wv_pc.pc = W.cellfun(@(x)x(:,1:20), wv_pc.pc, false);
%     savename = fullfile(sdir, sprintf('decode_%s.mat', ver_pca));
%     main_decoding(wv_pc, data.games, savename);
% end
% W.parclose;
% %% decoding - first 50 components
% W.parpool(8);
% parfor si = 1:nses
%     sdir = ses.fullpath(si);
%     data = W.load(fullfile(sdir, 'data_cleaned.mat'));
%     wv_pc = W.load(fullfile(sdir, sprintf('pca_%s.mat', ver_pca)));
%     %%
%     wv_pc.pc = W.cellfun(@(x)x(:,1:50), wv_pc.pc, false);
%     savename = fullfile(sdir, sprintf('decode_pc50_%s.mat', ver_pca));
%     main_decoding(wv_pc, data.games, savename, false);
% end
% W.parclose;