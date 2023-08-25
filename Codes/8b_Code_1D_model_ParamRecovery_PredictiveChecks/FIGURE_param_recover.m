function FIGURE_param_recover(plt, sim, fit)
    subi = 10;
    p1 = struct2table(sim{subi}.mdfit);
    p1 = removevars(p1, {'AIC', 'SSE', 'n_params'});
    p1 = table2array(p1);
    p2 = struct2table(fit{subi}.mdfit);
    p2 = removevars(p2, {'AIC', 'SSE', 'n_params'});
    p2 = table2array(p2);

    plt.figure(4,3)
    varnames = [arrayfun(@(x)sprintf("A_{%d}", x), 1:9), "\beta", "x0_{1}", "x0_{2}"];
    for i = 1:size(p1,2)
        tnm = varnames(i);
        plt.setfig_ax('xlabel', sprintf('simulated %s', tnm), 'ylabel', sprintf('fitted %s', tnm))
        str = plt.scatter(p1(:,i), p2(:,i), 'diag');
        plt.setfig_ax('legend', str, 'legloc', 'NW');
        plt.new;
    end
    plt.update;
end