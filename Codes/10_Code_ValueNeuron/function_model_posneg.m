function out = function_model_posneg(wv_anova, data, sub, nwin)  
    n = wv_anova.n_pos_neg_min(3);
    pop_pos = sort(randsample(find(wv_anova.id_positive), n));
    pop_neg = sort(randsample(find(wv_anova.id_negative), n));
    pop_mix = sort(randsample(1:length(wv_anova.perc_positive), n));
    idx_pops = {pop_pos, pop_neg, pop_mix};
    name_pops = {'pos','neg','mix'};
    out.mdfit = cell(1,3);
    for pi = 1:3
        d = data;
        d.spikes = d.spikes(idx_pops{pi});
        trajs = function_denoised_trajectories(d);
        
        wv_pc = W.neuro_PCA_defaultformat(d, trajs, 't0t1000');

        x1D = function_project1D(wv_pc, 'midRT', 'svmp', "nstd");
        npool = 1;
        mdfit = function_1D_model(x1D, [], sub, 'scaledEV', npool, nwin);
        out.mdfit{pi} = mdfit;
        out.x1D{pi} = x1D;
        out.pc{pi} = wv_pc;
    end
    out.name_pops = name_pops;
end