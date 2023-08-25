function main_Figure_2_PC20vs50(plt, dc1, dc2, sub, time_at, option)
if option == 1
    %% figures
    time_at = [-1000:50:2000];
    plt.figure(1,2, 'is_title',1);
    plt.setfig('title', {'20 PCs', '50 PCs'});
    plt = FIG_decoding(plt, dc1, time_at, sub.animal);
    plt.new;
    plt = FIG_decoding(plt, dc2, time_at, sub.animal);
    plt.update();
else
    if plt.set_savename('decode_20_vs_50_v2')
        return;
    end
    %% the other way
    plt.figure(1,2, 'is_title',1);
    plt.setfig_all('legend', {'20 PCs', '50 PCs'});
    mks = unique(sub.animal);
    ac_svm = W.cellfun(@(x)x.ac_decode_choice, dc1, false);
    ac_svm = vertcat(ac_svm{:});
    [av1, se1] = W.analysis_av_bygroup(ac_svm, sub.animal, mks);
    ac_svm = W.cellfun(@(x)x.ac_decode_choice, dc2, false);
    ac_svm = vertcat(ac_svm{:});
    [av2, se2] = W.analysis_av_bygroup(ac_svm, sub.animal, mks);
    for i = 1:2
        plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
            'legloc', 'SE', 'title', W.file_prefix(mks(i), 'Monkey',' '), ...
            'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
        plt.plot(time_at, [av1(i,:);av2(i,:)], [se1(i,:);se2(i,:)], 'line', ...
            'color', [plt.custom_vars.color_monkeys(i), strcat(plt.custom_vars.color_monkeys(i), '50')]);
        plt.dashY(0, [0.4,1]);
        plt.new;
    end
    plt.update;
end
