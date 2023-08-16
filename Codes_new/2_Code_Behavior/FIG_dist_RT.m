function plt = FIG_dist_RT(plt, games, animal)
    mks = unique(animal);
    leg = W.file_prefix(mks, 'Monkey', ' ');
    plt.setfig_ax('ylabel', 'density', 'xlabel', 'Reaction time (s)', ...
        'legend', leg, 'xlim',[0 1], 'ylim', [0 12]);
    tx = [];ty = [];
    for si = 1:2
        tid = find(animal == mks(si));
        tt = vertcat(games{tid});
        [ty(si,:), tx(si,:)] = hist(tt.rt_reject, [0:0.004:2]);
    end
    ty = ty./sum(ty,2)/0.003;
    plt.plot(tx,ty,[],'line', 'color', plt.custom_vars.color_monkeys);
end