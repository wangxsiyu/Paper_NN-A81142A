function [plt, figdata] = FIG_behavior_vs_cue(plt, gp, strx, ylab)
    leg = W.file_prefix({'V','W'}, 'Monkey', ' ');
    av = gp.(['av' strx]);
    se = gp.(['se' strx]);
    [~,od] = sort(mean(av));
    od =  [3     2     6     9     5     8     1     7     4];
    delays = mean(gp.avAVDELAY_BYCONDITION_byANIMAL);
    drops = mean(gp.avAVDROP_BYCONDITION_byANIMAL);
    xtklb = [compose('%ds', delays(od)); compose('%d', drops(od))];
    plt.setfig_ax('xlabel', '', 'ylabel', ylab, ...
        'xlim', [0.5 9.5], ...
        'legend', leg, 'legloc', 'NW',...
        'xtick', 1:9,'xticklabel', xtklb, 'xtickangle', 0);
    plt.plot([], av(:,od), se(:,od), 'line', ...
        'color', plt.custom_vars.color_monkeys);
    figdata.x = av(:, od);
    figdata.y = se(:, od);
    figdata.monkey = leg;
end