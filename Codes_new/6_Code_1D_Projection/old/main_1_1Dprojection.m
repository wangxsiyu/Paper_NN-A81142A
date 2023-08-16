run('../setup_analysis.m')
W_lp.set_loopsfx('t0t1000', {'svm','mean', 'svm1000', 'svm2000'});
W_lp.overwrite_on;
W_lp.set_auto_parclose(0);
W_lp.parloopsfx('function_1D_projection', {'pca_autosfx1', 'data_cleaned'}, 'x1D', 'variable2');
W_lp.overwrite_off;
W_lp.set_auto_parclose(1);
W.parclose;
%% align x1D across session 
% not finished
W_lp.add_sfx('t0t1000_svm');
x1D = W_lp.load_all('x1D_autosfx2');
x1D = x1D.x1D_t0t1000_svm;
%%
% arrayfun(@(x)std(x.x1D(:)), x1D)


% ver_pca = 't0t1000';
% ver_1Dproj = {'svm','mean'};
% ses = W.dir(datadir, 'folder');
% nses = size(ses,1);
% for si = 1:nses
%     sdir = ses.fullpath(si);
%     data = W.load(fullfile(sdir, 'data_cleaned.mat'));
%     wv_pc = W.load(fullfile(sdir, sprintf('pca_%s.mat', ver_pca)));
%     wv_pc.pc = W.cellfun(@(x)x(:,1:20), wv_pc.pc, false);
%     %% projection 1D
%     for proji = 1:length(ver_1Dproj)
%         savename = fullfile(sdir, sprintf('x1D%s_%s.mat', ver_1Dproj{proji}, ver_pca));
%         x1D = main_1D_projection(wv_pc, data.games, ver_1Dproj{proji}, savename);
%     end
% end