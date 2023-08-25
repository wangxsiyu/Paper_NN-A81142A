run('../setup_plot.m');
W_lp.set_loopsfx('t0t1000', {'svm', 'svm1000', 'svm2000'});
data = W_lp.loadsfx('decoding1D', [], 'cell');
data(:,4) = W_lp.load('decoding_t0t1000', [],'cell');
games = W_lp.load('data_cleaned', [], 'cell');
%%
dc = W.arrayfun(@(x) cellfun(@(t)t, data(:, x)), 1:size(data, 2));
mks = unique(sub.animal);
av = {}; se = {};
for i = 1:length(dc)
    tac_svm = vertcat(dc{i}.ac_choice);
    [tav, tse] = W.analysis_av_bygroup(tac_svm, sub.animal, mks);
    for j = 1:2
        av{j}(i,:) = tav(j,:);
        se{j}(i,:) = tse(j,:);
    end
end
%%
time_at = [-1000:50:2000];
plt.figure(1,2, 'is_title',1);
plt.setfig_all('legend', {'median', '0-1000','1000-2000', 'bin'});
for i = 1:2
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
        'legloc', 'SE', 'title', W.file_prefix(mks(i), 'Monkey',' '), ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_at, av{i}, se{i}, 'line', ...
        'color', [strcat(plt.custom_vars.color_monkeys(i), '20'), ...
        strcat(plt.custom_vars.color_monkeys(i), '50'), ...
        strcat(plt.custom_vars.color_monkeys(i), '80'), ...
        plt.custom_vars.color_monkeys(i)]);
    plt.dashY(0, [0.4,1]);
    plt.new;
end
plt.update('full comparison');
%%
time_at = [-1000:50:2000];
plt.figure(1,2, 'is_title',1);
plt.setfig_all('legend', {'1-D', '20-D'});
tid = [2 4];
for i = 1:2
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
        'legloc', 'SE', 'title', W.file_prefix(mks(i), 'Monkey',' '), ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_at, av{i}(tid,:), se{i}(tid,:), 'line', ...
        'color', [strcat(plt.custom_vars.color_monkeys(i), '50'), ...
         plt.custom_vars.color_monkeys(i)]);
    plt.dashY(0, [0.4,1]);
    plt.new;
end
plt.update('decode_full_vs_1D');