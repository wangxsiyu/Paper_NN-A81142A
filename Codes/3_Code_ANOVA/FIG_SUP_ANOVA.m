function FIG_SUP_ANOVA(plt, sub, wv_anova)
    time_at = wv_anova{1}.time_at;
    animal = sub.animal;
    leg_anova = wv_anova{1}.anova_names_factors;
    perc_sig = W.cellfun(@(x)x.perc_sig, wv_anova);
    %% figures
    plt.figure(1,2, 'is_title', 1);
    %
    mks = unique(animal);
    plt.setfig('title', W.str2cell(W.file_prefix(mks, 'Monkey',' ')), 'legloc', 'NE');
    for i = 1:length(mks)
        plt.ax(i);
        [av, se] = W.cell_avse(perc_sig(animal == mks(i)));
        plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'p(significant neurons)', ...
            'legloc', 'NW', 'legend',leg_anova, 'ylim', [0,0.4], 'ytick', 0:.1:.4, ...
            'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
        plt.plot(time_at, av, se, 'line', 'color', plt.custom_vars.color_anova);
        plt.dashY(0, [0,0.5]);
    end
    plt.update;
end