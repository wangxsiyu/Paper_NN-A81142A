function main_FIGURE_1_1Dvs20D(plt, savename, dc1, dcsvm, sub, time_at)
    if plt.set_savename(savename)
        return;
    end
    %%
    dc{1} = W.cell_vertcat_cellfun(@(x)x.ac_decode_choice, dc1, false);
    dc{2} = W.cell_vertcat_cellfun(@(x)x.ac_decode_choice, dcsvm, false);
    mks = unique(sub.animal);
    av = {}; se = {};
    for i = 1:length(dc)
        [tav, tse] = W.analysis_av_bygroup(dc{i}, sub.animal, mks);
        for j = 1:2
            av{j}(i,:) = tav(j,:);
            se{j}(i,:) = tse(j,:);
        end
    end
    %%
    plt.figure(1,2, 'is_title',1);
    plt.setfig_all('legend', {'1-D', '20-D'});
    for i = 1:2
        plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
            'legloc', 'SE', 'title', W.file_prefix(mks(i), 'Monkey',' '), ...
            'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
        plt.plot(time_at, av{i}(:,:), se{i}(:,:), 'line', ...
            'color', [strcat(plt.custom_vars.color_monkeys(i), '50'), ...
             plt.custom_vars.color_monkeys(i)]);
        plt.dashY(0, [0.4,1]);
        plt.new;
    end
    plt.update;
end