% no noise, too perfect...
function out = simulate_and_fit(x1D, games, sub, md, savename)
    ntime = size(md.mdfit.a, 1);
    games = games.games;
    x1D = x1D.x1D;
    cond = games.condition;
    c = games.choice + 1;
    a_cond = cond;
    x0_cond = c;
    ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
    params_sim = [];
    params_fit = [];
    for ti = 1:ntime
        %% simulate
        x = x1D(:, ti);
        a = md.mdfit.a(ti,:);
        x0 = md.mdfit.x0(ti,:);
        coef_ev = md.mdfit.coef_ev(ti,:);
        y = W.model_dynamics_scaled_evidence(a, x0, coef_ev, x, ev, a_cond, x0_cond);
        %% fit
        params = W.fit_dynamics_scaled_evidence(x, y, ev, a_cond, x0_cond);
        %% 
        param_sim = [a, x0, coef_ev];
        param_fit = [params.a, params.x0, params.coef_ev];
        params_sim = [params_sim; param_sim];
        params_fit = [params_fit; param_fit];
    end
    out = diag(corr(params_sim, params_fit));
end