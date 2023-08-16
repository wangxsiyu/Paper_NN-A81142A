function plt = FIGURE_param_recover(plt, sim, fit)
    p1 = table2array(struct2table(sim.mdfit));
    p2 = table2array(struct2table(fit.mdfit));


    varnames = [arrayfun(@(x)sprintf("A_{%d}", x), 1:9), "x0_{1}", "x0_{2}", "\beta"];
    for i = 1:size(p1,2)
        tnm = varnames(i);
        plt.setfig_ax('xlabel', sprintf('simulated %s', tnm), 'ylabel', sprintf('fitted %s', tnm))
        str = plt.scatter(p1(:,i), p2(:,i), 'diag');
        plt.setfig_ax('legend', str, 'legloc', 'NW');
        plt.new;
    end
end