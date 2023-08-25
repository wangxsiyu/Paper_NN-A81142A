function out = function_model_2population(x1D, pc, data, anv, sub, savename)
    npc = length(x1D.w_svm);
    ld = pc.coeff(:, 1:npc) * x1D.w_svm';
    spks = W.convert_NcellMK2KcellMN(data.spikes);
    ld_pos = anv.id_positive .* W.horz(ld);
    ld_neg = anv.id_negative .* W.horz(ld);
    xp = W.cellfun(@(x)x * [ld_pos', ld_neg'], spks, false);

    games = data.games;
    nstep = data.time_window/unique(diff(data.time_at));
    W.print('time window = %d, nstep = %d', data.time_window, nstep);
    cond = games.condition;
    c = games.choice;
    nstep = data.time_window/unique(diff(data.time_at));
    npool = 1;
%     ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
    [mdfits, time_md] = W.fit_nDdynamics('dynamics_linear', ...
        xp, x1D.time_at, npool, nstep, cond, c+1);
    W.save(savename, 'mdfits', mdfits, 'time_md', time_md);
end