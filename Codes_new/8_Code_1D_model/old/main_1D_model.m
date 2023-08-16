function out = main_1D_model(x1D, games, sub, npool, nstep, ver_1Dmodel, savename)
    if exist('savename', 'var') && exist(savename, 'file')
        return;
    end
    %% fit
    cond = games.condition;
    c = games.choice;
    switch ver_1Dmodel
        case 'scaledEV'
            ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
            [mdfits, time_md] = W.fit_1Ddynamics('dynamics_scaled_evidence', ...
                x1D.x1D, x1D.time_at, npool, nstep, ev, cond, c+1);
        case 'residue'
            [mdfits, time_md] = W.fit_1Ddynamics('dynamics_fit_evidence', ...
                x1D.x1D, x1D.time_at, npool, nstep, cond, c+1, cond);
    end
    %%
    if exist('savename', 'var')
        W.save(savename, 'mdfit', mdfits, 'time_md', time_md, ...
            'ver_1Dmodel', ver_1Dmodel, 'nstep', nstep, 'npool', npool);
    end
    out = struct('mdfit', mdfits, 'time_md', time_md, ...
            'ver_1Dmodel', ver_1Dmodel, 'nstep', nstep, 'npool', npool);
end