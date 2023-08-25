function plt = FIG_decoding(plt, wv_decode, time_at, animal)
    ac_svm = W.cellfun(@(x)x.ac_decode_choice, wv_decode, false);
    ac_svm = vertcat(ac_svm{:});
    mks = unique(animal);
    [av, se] = W.analysis_av_bygroup(ac_svm, animal, mks);
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
        'legloc', 'SE', 'legend', W.file_prefix(mks, 'Monkey',' '), ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_at, av, se, 'line', 'color', plt.custom_vars.color_monkeys);
    plt.dashY(0);
end