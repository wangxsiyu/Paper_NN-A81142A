function FIG_SUP_decodeDelayDrop(plt, sub, wv_pca, wv_decode)
    animal = sub.animal;
    time_at = wv_pca{1}.time_at;
    plt.figure(1,3);
    mks = unique(animal);
    ylm = [0.2 1];
    plt.setfig([2 3], 'ylim', {ylm, ylm});
    pca_r2 = W.cellfun(@(x)x.info_pc.r2, wv_pca, false);
    av = []; se = [];
    for i = 1:length(mks)
        [av(i,:), se(i,:)] = W.cell_avse(W.cellfun(@(x)cumsum(x(1:50)),pca_r2(animal == mks(i)),false));
    end
    plt.setfig_ax('xlabel', 'PCA components', 'ylabel', 'cumulative variance', ...
        'legend',  W.file_prefix(mks, 'Monkey',' '), 'legloc', 'SE');
    plt.plot([], av, se, 'line', 'color', plt.custom_vars.color_monkeys);
    %
    ac_svm = W.cellfun(@(x)x.ac_decode_delay, wv_decode);
    ac_svm = vertcat(ac_svm{:});
    plt.new
    [av, se] = W.analysis_av_bygroup(ac_svm, animal, mks);
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
        'legloc', 'NE', 'legend', W.file_prefix(mks, 'Monkey',' '), ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_at, av, se, 'line', 'color', plt.custom_vars.color_monkeys);
    plt.dashY(0, ylm);
    %
    ac_svm = W.cellfun(@(x)x.ac_decode_drop, wv_decode);
    ac_svm = vertcat(ac_svm{:});
    plt.new;
    [av, se] = W.analysis_av_bygroup(ac_svm, animal, mks);
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
        'legloc', 'NE', 'legend', W.file_prefix(mks, 'Monkey',' '), ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_at, av, se, 'line', 'color', plt.custom_vars.color_monkeys);
    plt.dashY(0, ylm);
    plt.update();
end