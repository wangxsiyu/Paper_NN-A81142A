function plt = fig_ax_ANOVA(plt, wv_anova, time_at)
    leg_anova = wv_anova{1}.anova.anovafactornames;
    perc_sig = W.cellfun(@(x)x.anova.perc_sig, wv_anova);
    [av, se] = W.cell_avse(perc_sig);
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'p(significant neurons)', ...
        'legloc', 'NE', 'legend', leg_anova, 'ylim', [0 0.4], 'ytick', 0:.1:.4, ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_at, av, se, 'line', 'color', plt.custom_vars.color_anova);
    plt.dashY(0, [0, 0.5]);
end