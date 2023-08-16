run('../setup_analysis.m')
subs = W.load(fullfile(datadir, 'behavior_sub.mat'));
ver_pca = 't0t1000';
ver_1Dproj = {'svm','mean'};
ver_1Dmodel = {'scaledEV', 'residue'};
npool = 3;
ses = W.dir(datadir, 'folder');
nses = size(ses,1);
for si = 1:nses
    sub = subs(strcmp(subs.filename, ses.filename(si)),:);
    sdir = ses.fullpath(si);
    data = W.load(fullfile(sdir, 'data_cleaned.mat'));
    nstep = data.time_window/unique(diff(data.time_at));
    W.print('time window = %d, nstep = %d', data.time_window, nstep);
    %% projection 1D
    for proji = 1:length(ver_1Dproj)
        x1D = W.load(fullfile(sdir, sprintf('x1D%s_%s.mat', ver_1Dproj{proji}, ver_pca)));    
        for mdi = 1:length(ver_1Dmodel)
            savename = fullfile(sdir, sprintf('model1D_%s_x1D%s_%s.mat', ver_1Dmodel{mdi}, ver_1Dproj{proji}, ver_pca));
            main_1D_model(x1D, data.games, sub, npool, nstep, ver_1Dmodel{mdi}, savename);
        end
    end
end