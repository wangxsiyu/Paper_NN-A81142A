function main_FIGURE_1_ANOVA_decoding(plt, wv_anova, wv_decode, sub)
    %% figures
    if plt.set_savename('ANOVA, decoding')
        return;
    end
    plt.figure(1,2);
    plt.setfig_ax('ylim', [0 0.4], 'ytick', 0:.1:.4, ...
                'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.FIG_ANOVA(wv_anova);
    plt.new;
    plt = FIG_decoding(plt, wv_decode, wv_anova{1}.time_at, sub.animal);
    plt.update();
end