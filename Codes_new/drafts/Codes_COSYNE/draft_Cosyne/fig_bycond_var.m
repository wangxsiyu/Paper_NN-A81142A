function plt = fig_bycond_var(plt, mdX, sub, time_md)
    cols = plt.custom_vars.color_monkeys;
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
%     time_md = mdX{1}.time_md;

    corAE = W.arrayfun(@(x)corr(mdX{x}.error_bycond,W.vert(sub.ENTROPY_byCONDITION(x,:))), ...
        1:size(sub,1), false);
    corAE = horzcat(corAE{:})'; 
    [~,pp] = ttest(corAE);
    [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
        'ylabel', 'retraction coef vs entropy', ...
        'ylim', [-0.9 0.6], ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    plt.dashY(0, [-0.9 0.6]);
    plt.sigstar(time_md, pp*0 -0.9, pp);
end