function stats = FIG_SUP_evidence(plt, savename, sub, mdev)
    if plt.set_savename(savename)
        return;
    end
    mks = unique(sub.animal);
    idanimal = W.str_getID(sub.animal, mks);
    time_md = mdev{1}.time_md;
    %% figures
    plt.figure(2,2);
    %
    plt.ax(1);
    gp = W.analysis_tab_av_bygroup(sub, 'animal', {'V','W'}, ...
        {'avCHOICE_byCONDITION','ENTROPY_byCONDITION', ...
        'avDELAY_byCONDITION', 'avDROP_byCONDITION', ...
        'avDRIFTRATE_byCONDITION'});
    plt = FIG_behavior_vs_cue(plt, gp, 'AVDRIFTRATE_BYCONDITION_byANIMAL', 'evidence');
    %% correlation between empirical evidence and actual
    corAE = [];
    xs = {[],[]};
    ys = cell(1,2);
    for i = 1:length(mks)
        ys{i} = reshape(sub.avDRIFTRATE_byCONDITION(idanimal == i,:)',[],1);
    end
    for si = 1:size(sub,1)
        corAE(si,:) = corr(mdev{si}.mdfit.b_ev', sub.avDRIFTRATE_byCONDITION(si,:)');  
        time_median = sub.avRT_REJECT(si) * 1000;
        idxt = dsearchn(time_md', time_median);
        xs{idanimal(si)} = [xs{idanimal(si)};mean((mdev{si}.mdfit.b_ev(idxt + [-1:1],:)))'];  
    end
    [~,pp] = ttest(corAE);
    [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
    %%
    cols = plt.custom_vars.color_monkeys;
    leg = W.str2cell(W.file_prefix(mks,'', ' '));
    plt.ax(2);
    % correlation between a and entropy
    plt.setfig_ax('legend', leg, 'legloc', 'NW', 'xlabel', 'time (ms)', ...
        'ylabel', 'evidence(neural) vs (behavior)', ...
        'ylim', [-1 1], ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    plt.dashY(0, [-1 1]);
    plt.sigstar(time_md, pp*0 -0.9, pp);
    % fig - scatter
    for i = 1:length(mks)
        plt.ax(i+2);
        plt.setfig_ax('xlabel', 'evidence(neural)', 'ylabel', 'evidence(choice)');
        stats{1} = plt.scatter(xs{i}, ys{i}, 'corr', 'color', cols{i});
        W.print(stats{1})
    end
    plt.update;
end