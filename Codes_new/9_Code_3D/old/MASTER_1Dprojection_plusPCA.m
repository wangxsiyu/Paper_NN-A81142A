run('../setup_analysis.m')
subs = W.load(fullfile(datadir, 'behavior_sub.mat'));
ver_pca = 't0t1000';
ses = W.dir(datadir, 'folder');
nses = size(ses,1);
for si = 1:nses
    sub = subs(strcmp(subs.filename, ses.filename(si)),:);
    sdir = ses.fullpath(si);
    data = W.load(fullfile(sdir, 'data_cleaned.mat'));
    wv_pc = W.load(fullfile(sdir, sprintf('pca_%s.mat', ver_pca)));
    wv_pc.pc = W.cellfun(@(x)x(:,1:20), wv_pc.pc, false);
    %% projection 1D
    savename = fullfile(sdir, sprintf('x3D_%s.mat', ver_pca));
    x3D = main_1D_projection_plusPCA(wv_pc, data.games, savename);
end