function out = function_simulate_games(x1D0, md, sub)
    rng(0);
    out = [];
    ntime = size(md.mdfit.a, 1);
    games = x1D0.games;
    x1D = x1D0.x1D;
    cond = games.condition;
    c = games.choice + 1;
    a_cond = cond;
    x0_cond = c;
    ev = W.nan_selects(sub.avDRIFTRATE_byCONDITION, cond);
    ers = [];
    %% simulate - get shuffled residuals
    for ti = 1:ntime
        x = x1D(:, ti);
        a = md.mdfit.a(ti,:);
        x0 = md.mdfit.x0(ti,:);
        coef_ev = md.mdfit.b_input(ti,:);
        y = W.model_1Ddynamics_scaledinput(a, x0, coef_ev, x, ev, a_cond, x0_cond);
        er = x1D(:, ti+1) - y;
        ers(:, ti) = W.shuffle(er);
    end
    %% simulate with residuals;
    for ti = 1:ntime
        x = x1D(:, ti);
        a = md.mdfit.a(ti,:);
        x0 = md.mdfit.x0(ti,:);
        coef_ev = md.mdfit.b_input(ti,:);
        er = ers(:, ti);
        x1D(:, ti + 1) = W.model_1Ddynamics_scaledinput(a, x0, coef_ev, x, ev, a_cond, x0_cond) + er;
    end
    x1D0.x1D = x1D;
    out = x1D0;
end