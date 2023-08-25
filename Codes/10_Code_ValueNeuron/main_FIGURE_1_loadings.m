function figdata = main_FIGURE_1_loadings(plt, sub, meanFR, LDS)
    %% FIGURE
    LDS = W.cell_vertcat_cellfun(@(x)x.av_ld, LDS);
    %%
    [tav, tse] = W.analysis_av_bygroup(LDS, sub.animal);
    plt.figure(1,3, 'is_title', 1);
    plt.ax(1,3);
    plt.plot(W.bin_middle([0:.1:1]), tav, tse, 'line', 'color', plt.custom_vars.color_monkeys);
    figdata.panelC.x = W.bin_middle([0:.1:1]);
    figdata.panelC.y = tav;
    figdata.panelC.se = tse;
    plt.setfig_ax('xlabel', 'value coding of neurons', ...
        'ylabel', 'weight on the choice dimension', ...
        'legend', plt.custom_vars.name_monkeys, 'legloc', 'NW', 'ylim', [-0.1,0.1], 'ytick', [-0.1:0.05:0.1]);
    % plt.update('valuecoding_vs_weight');
    % %% FIGURE
    % plt.figure(1,2, 'is_title',1);
    plt.setfig(1:2,'title', plt.custom_vars.name_monkeys)
    cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});
    mks = unique(sub.animal);
    plt.setfig_all(1:2,'xlabel', 'value coding of neurons', 'ylabel', 'mean firing rates')
    avFR = W.cellfun(@(x)x.avFR_byPosNeg, meanFR);
    [tav, tse] = W.analysis_av_bygroup(avFR, sub.animal);
    for i = 1:2
        pa = mean(sub.avCHOICE_byCONDITION(sub.animal == mks(i),:));
        [~,od] = sort(pa);
        condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), pa);
        plt.ax(1,i);
        plt.plot(W.bin_middle(0:.1:1), tav{i}(od,:), tse{i}(od,:), 'line', 'color', condcolors(od));
        figdata.panelAB{i}.x = W.bin_middle(0:.1:1);
        figdata.panelAB{i}.y = tav{i}(od,:);
        figdata.panelAB{i}.se = tse{i}(od,:);
    end
    plt.update;
