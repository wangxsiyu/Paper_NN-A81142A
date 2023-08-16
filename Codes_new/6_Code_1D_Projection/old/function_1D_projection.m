function x1D = function_1D_projection(pc, games, ver_proj, savename)
    games = games.games;
%     ver_proj = W.strs_selectbetween2patterns(savename, '_', [], -1);
    if exist('savename', 'var') && exist(savename, 'file')
        x1D = W.load(savename);
        return;
    end
    x1D = struct;
    x1D.midRT = W.avse(games.rt_reject, 1) * 1000;
    x1D.midRT_idx = dsearchn(W.vert(pc.time_at), x1D.midRT) + [-1:1];
    switch ver_proj
        case 'svm1000'
            idx_time = find(pc.time_at >= 0 & pc.time_at <= 1000);
        case 'svm2000'
            idx_time = find(pc.time_at >= 1000 & pc.time_at <= 2000);
        otherwise
            idx_time = x1D.midRT_idx;
    end
    cc = games.choice;
    tpc = pc.pc;
    tpc = W.cellfun(@(x)x(:, 1:20), tpc, false);
    ntrial = size(games,1);
    ntime = length(pc.pc);
    %% projection to 1D space
    xx = NaN(ntrial, ntime);
    tx = vertcat(tpc{idx_time});
    ty = repmat(cc, length(idx_time), 1);
    switch ver_proj
        case {'svm', 'svm1000', 'svm2000'}
            tmodel = fitcsvm(tx, ty);
            tw = (tmodel.SupportVectorLabels.*tmodel.Alpha)' * tmodel.SupportVectors;
            tb = tmodel.Bias;
            x1D.w_svm = tw;
            x1D.b_svm = tb;
            for ti = 1:ntime % loop over time
                xx(:, ti) = (tpc{ti} * tw'+ tb); %./sqrt(tw*tw'); % needs to double check
            end
        case 'mean' % needs to be centered
            avpos = W.analysis_av_bygroup(tx, ty, [0 1]);
            tdir = diff(avpos);
            for ti = 1:ntime % loop over time
                xx(:, ti) = tpc{ti} * tdir'/(tdir * tdir');
            end
    end
    x1D.x1D = xx; % needs to standardize
    x1D.time_at = pc.time_at;
    %%
    if exist('savename', 'var')
        W.save(savename,'x1D', x1D);
    end
end