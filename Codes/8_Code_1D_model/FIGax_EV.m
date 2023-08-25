function [plt, figdata] = FIGax_EV(plt, mdX, sub, time_md)
    cols = plt.custom_vars.color_monkeys;
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
%     time_md = mdX{1}.time_md;

    evs = W.cellfun(@(x)x.b_input, mdX);
    evs = horzcat(evs{:})';
    [~,pp] = ttest(evs, [], 'tail', 'right');
    [av, se] = W.analysis_av_bygroup(evs, sub.animal, mks);
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', 'ylabel', 'beta EV', ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    figdata.x = time_md;
    figdata.y = av;
    figdata.se = se;
    figdata.p = pp;
    plt.sigstar(time_md, pp*0 -0.04, pp);
    plt.dashY(0, [-0.05, 0.3]);
end