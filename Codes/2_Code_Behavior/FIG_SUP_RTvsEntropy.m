function FIG_SUP_RTvsEntropy(plt, sub, games)
    %%
    games = W.cellfun(@(x)x.games, games, false);
    gp = W.analysis_tab_av_bygroup(sub, 'animal', {'V','W'}, ...
        {'avCHOICE_byCONDITION','ENTROPY_byCONDITION', ...
        'avDELAY_byCONDITION', 'avDROP_byCONDITION'});
    %% figures
    plt.figure(2,2, 'matrix_title',[1 1;0 0], 'gapW_custom', [0 0 0.5]);
    mks = unique(sub.animal);
    tlt = W.file_prefix(mks, 'Monkey', ' ');
    for fi = 1:2
        plt.ax(fi);
        plt.setfig_ax('ylabel', 'density', 'xlabel', 'Reaction time (s)', ...
            'legend', {'reject', 'accept'}, 'xlim',[0 1], 'title', tlt{fi});
        tx = [];ty = [];
        rtname = {'rt_reject','rt_accept'};
        for si = 1:2
            tid = find(sub.animal == mks(fi));
            tt = vertcat(games{tid});
            [ty(si,:), tx(si,:)] = hist(tt.(rtname{si}), [0:0.004:2]);
        end
        ty = ty./sum(ty,2)/0.003;
        plt.plot(tx,ty,[],'line', 'color', plt.custom_vars.color_rejectaccept);
    end
    %%
    plt.ax(3);
    [plt] = FIG_entropy_vs_RT(plt, sub, 'accept');
    %%
    plt.ax(4);
    plt.setfig_ax('xlabel', 'Time between cue on and purple dot (s)', ...
        'ylabel', 'entropy vs RT', ...
        'ylim', [],'ytick',0:.1:2, 'legend', tlt, 'legloc', "NW", 'xlim', [1 4]);
    cols =  plt.custom_vars.color_monkeys;
    for si = 1:2
        tt = sub(sub.animal == mks(si),:);
        cc = tt.avCHOICE_byCONDITION;
        cid = cc >=0.5;
        tx = tt.ENTROPY_byCONDITION(cid);
        tr = []; tp = [];
        trg = 1.25:0.5:3.75;
        for i = 1:5
            te = W.cellfun(@(x)W.analysis_av_bygroup(x.rt_accept(x.rt_cueon2purple >= trg(i) & x.rt_cueon2purple < trg(i+1)), ...
                x.condition(x.rt_cueon2purple >= trg(i) & x.rt_cueon2purple < trg(i+1)), 1:9), ...
                games(sub.animal == mks(si)), false);
            te = vertcat(te{:});
            ty = te(cid);
            [tr(i), tp(i)] = corr(tx,ty, 'rows','complete');
        end
        plt.plot(1.5:0.5:3.5, tr, [], 'line', 'color', cols(si));
    end
    %%
    plt.update([], 'A BC');
end