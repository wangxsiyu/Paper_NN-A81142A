run('../setup_analysis.m')
subs = W.load(fullfile(datadir, 'behavior_sub.mat'));
ver_pca = 't0t1000';
npool = 3;
ses = W.dir(datadir, 'folder');
nses = size(ses,1);
for si = 1:nses
    sub = subs(strcmp(subs.filename, ses.filename(si)),:);
    sdir = ses.fullpath(si);
    data = W.load(fullfile(sdir, 'data_cleaned.mat'));
    nstep = data.time_window/unique(diff(data.time_at));
    x3D = W.load(fullfile(sdir, sprintf('x3D_%s.mat', ver_pca)));
    %% 3D model
    [mdfit_3D, time_md] = main_multiD_model(x3D.x3D, data, npool, nstep);
    savename = fullfile(sdir, sprintf('model3D_%s', ver_pca));
    W.save(savename, 'mdfit_3D', mdfit_3D, 'time_md', time_md);
end