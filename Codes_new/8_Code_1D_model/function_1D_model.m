function out = function_1D_model(x1D, pos1D, sub, ver_1Dmodel, npool, nwin)
    games = x1D.games;
    %% fit
    nstep = nwin/unique(diff(x1D.time_at));
    W.print('time window = %d, nstep = %d', nwin, nstep);
    cond = games.condition;
    c = games.choice;
    switch ver_1Dmodel
        case 'scaledEV'
            ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D, x1D.time_at, npool, nstep, ev, cond, c+1);
        case 'control'
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
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_residue', ...
                x1D.x1D(tid,:), x1D.time_at, npool, nstep, cond(tid), cond(tid), c(tid)+1);
            mdfits.cond = ["uncertain", "certain"];
        case '1basin'
            ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D, x1D.time_at, npool, nstep, ev, cond, cond);
        case 'scaledEVloc'
            ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D, x1D.time_at, npool, nstep, ev, cond, [], 'loc');
        case 'scaledEVsoft'
            ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D, x1D.time_at, npool, nstep, ev, cond, pos1D.pos1D, 'soft');
        case 'scaledEVsoftfixwin'
            ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
            tpos = pos1D.pos1D_bywin;
            tpos = repmat(tpos, 1, size(pos1D.pos1D, 2));
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D, x1D.time_at, npool, nstep, ev, cond, tpos, 'soft');
        case 'scaledEVrejectonly'
            ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
            pa = W.nan_selects(sub.avCHOICE_byCONDITION, cond);
            tid = pa < 0.5;
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D(tid,:), x1D.time_at, npool, nstep, ev(tid), W.num2rank(cond(tid)), c(tid)+1);
            ta = NaN(length(time_md), 9);
            ta(:, unique(cond(tid))) = mdfits.a;
            mdfits.a = ta;
        case 'scaledEVpyDDM'
            if ~isfield(sub, 'pyDDM_vanilla')
                out = [];
                return
            end
            ev = W.nan_selects(sub.pyDDM_vanilla, cond);
            tid = ~isnan(ev);
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D(tid,:), x1D.time_at, npool, nstep, ev(tid), W.num2rank(cond(tid)), c(tid)+1);
            ta = NaN(length(time_md), 9);
            ta(:, unique(cond(tid))) = mdfits.a;
            mdfits.a = ta;
        case 'scaledEVpyDDMCB'
            if ~isfield(sub, 'pyDDM_collapsingbound')
                out = [];
                return
            end
            ev = W.nan_selects(sub.pyDDM_collapsingbound, cond);
            tid = ~isnan(ev);
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_scaledinput', ...
                x1D.x1D(tid,:), x1D.time_at, npool, nstep, ev(tid), W.num2rank(cond(tid)), c(tid)+1);
            ta = NaN(length(time_md), 9);
            ta(:, unique(cond(tid))) = mdfits.a;
            mdfits.a = ta;
        case 'residue'
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_residue', ...
                x1D.x1D, x1D.time_at, npool, nstep, cond, cond, c+1);
        case 'residueloc'
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_residue', ...
                x1D.x1D, x1D.time_at, npool, nstep, cond, cond, [], 'loc');
        case 'residuesoft'
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_residue', ...
                x1D.x1D, x1D.time_at, npool, nstep, cond, cond, pos1D.pos1D, 'soft');
        case 'residuesoftfixwin'
            tpos = pos1D.pos1D_bywin;
            tpos = repmat(tpos, 1, size(pos1D.pos1D, 2));
            [mdfits, time_md] = W.fit_1Ddynamics('1Ddynamics_residue', ...
                x1D.x1D, x1D.time_at, npool, nstep, cond, cond, tpos, 'soft');
    end
    out = struct('mdfit', mdfits, 'time_md', time_md, ...
            'ver_1Dmodel', ver_1Dmodel, 'nstep', nstep, 'npool', npool);
end