function out = function_1D_control(data, sub, x1D, savename)
    games = data.games;
    npool = 1;
    nstep = data.time_window/unique(diff(data.time_at));
    ver_1Dmodel = 'svm';
    %% fit
    W.print('time window = %d, nstep = %d', data.time_window, nstep);
    cond = games.condition;
    c = games.choice;
    pa = sub.avCHOICE_byCONDITION;
    id1 = find(pa == median(pa)) == cond;
    pl1 = cond == find(pa == max(pa), 1);
    pl2 = cond == find(pa == min(pa), 1);
    pl1 = find(pl1);
    pl2 = find(pl2);
    cond = cond * 0;
    id1 = find(id1);
    cond(id1) = 1;
    id2 = [randsample(pl1, sum(c(id1) == 1)); randsample(pl2, sum(c(id1) == 0))];
    cond(id2) = 2;
    tid = cond ~= 0;
    [mdfits, time_md] = W.fit_1Ddynamics('dynamics_fit_evidence', ...
        x1D.x1D(tid,:), x1D.time_at, npool, nstep, cond(tid), c(tid)+1, cond(tid));
    mdfits.cond = ["uncertain", "certain"];
    if exist('savename', 'var')
        W.save(savename, 'mdfit', mdfits, 'time_md', time_md, ...
            'ver_1Dmodel', ver_1Dmodel, 'nstep', nstep, 'npool', npool);
    end
    out = struct('mdfit', mdfits, 'time_md', time_md, ...
            'ver_1Dmodel', ver_1Dmodel, 'nstep', nstep, 'npool', npool);
end