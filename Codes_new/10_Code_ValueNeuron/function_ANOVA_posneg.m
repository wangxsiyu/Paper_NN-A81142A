function [wv_anova] = function_ANOVA_posneg(option, data, sub)
    %%
    pa = sub.avCHOICE_byCONDITION;
    data.games.paccept = arrayfun(@(x)pa(x), data.games.condition);
    factornames = {'choice','paccept'};
    model = [1,0;0 1;1 1];
    [wv_anova] = W.neuro_ANOVA(option, data, factornames, 'window_significance', [0 1000], ...
        'model', model, 'continuous', [2]);
    % compute positive/negative neurons
    tid = wv_anova.time_at >= 0 & wv_anova.time_at <= 1000;
    tid_pa = strcmp(wv_anova.anova_names_coef, 'paccept');
    wv_anova.perc_positive = W.cellfun(@(x)mean(x(tid_pa, tid)>0,2), wv_anova.anova_coef_factor);

    nmax = sum(tid);
    pas = abs(pascal(nmax + 1,1));
    w = repmat(1./sum(pas, 2), 1, nmax + 1);
    p = w.*pas;
    cump = cumsum(p,2);
    pval = arrayfun(@(x)1-cump(nmax+1, max(x,1)), 1:nmax);
    nchance = find(pval< 0.05, 1 );

    id_positive = wv_anova.perc_positive * nmax >= nchance - 1e-5;
    id_negative = wv_anova.perc_positive * nmax <= nmax - nchance + 1e-5;
    ncommon = min(sum(id_positive), sum(id_negative));
    wv_anova.n_sig_pos_neg_min = [sum(id_positive), sum(id_negative), ncommon];

    id_positive = wv_anova.perc_positive >= 0.5;
    id_negative = wv_anova.perc_positive <= 0.5;
    ncommon = min(sum(id_positive), sum(id_negative));
    wv_anova.n_pos_neg_min = [sum(id_positive), sum(id_negative), ncommon];
    wv_anova.id_positive = id_positive;
    wv_anova.id_negative = id_negative;  
end