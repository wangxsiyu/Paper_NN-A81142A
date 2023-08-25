run('../setup_analysis.m')
%%
W_lp.set_loopsfx('t0t1000', {'svm'}, {'npool1', 'npool3'}, {'choice'});
% W_lp.add_loopsfx('t0t1000', {'svm'}, {'npool1', 'npool3'}, {'soft', 'softwin', 'position', 'choice'});
%% fit all versions
W_lp.overwrite_on;
W_lp.set_auto_parclose(0);
W_lp.parloopsfx('function_energy_landscape', {'data_cleaned', 'x1D_autosfx2', 'Pos1D_autosfx2'}, ...
    'EL', 'variable3_num', 'variable4')
W_lp.overwrite_off;

%% pool data across sessions
% x1D = W_lp.load_all('x1D_autosfx2')


% for veri = 1:size(versions,1)
%     vers = versions(veri,:);
%     npool = vers.ver_npool;
%     str_x1D = sprintf('x1D%s_%s.mat', vers.ver_1Dproj, vers.ver_pca);
%     savename = sprintf('EL_%s_npool%d.mat', vers.ver_pca, npool);
%     W_lp.loop('main_energy_landscape', {'data_cleaned', str_x1D}, savename, npool, 'position');
% end
% %%
% ses = W.dir(datadir, 'folder');

% nses = size(ses,1);
% for si = 1:nses
%     sub = subs(strcmp(subs.filename, ses.filename(si)),:);
%     sdir = ses.fullpath(si);
%     data = W.load(fullfile(sdir, 'data_cleaned.mat'));
%     W.print('time window = %d, nstep = %d', data.time_window, nstep);
%     %% projection 1D
%     for proji = 1:length(ver_1Dproj)
%         x1D = W.load(fullfile(sdir, sprintf('x1D%s_%s.mat', ver_1Dproj{proji}, ver_pca)));    
%         savename = fullfile(sdir, sprintf('EL_x1D%s_%s.mat', ver_1Dproj{proji}, ver_pca));
%         (x1D.x1D, x1D.time_at,  data.games, npool, nstep, savename);
%     end
% end