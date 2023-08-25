function figdata = FIG_SUP_avTRAJ(plt, sub, x1D)
    %% fit
    games = W.cellfun(@(x)x.games, x1D);
    plt.figure(3,2, 'matrix_title', [1 1; 0 0; 0 0]);
    mks = unique(sub.animal);
    leg_mks = W.str2cell(W.file_prefix(mks, 'Monkey', ' '));
    plt.setfig(1:2, 'title', leg_mks);
    pa = [];
    for i = 1:length(mks)
        pa(i,:) = mean(sub.avCHOICE_byCONDITION(sub.animal == mks(i),:));
    end
    time_at = x1D{1}.time_at;
    cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});
    colors = plt.custom_vars.color_monkeys;
    trajs = W.arrayfun(@(x)W.analysis_av_bygroup(x1D{x}.x1D, games{x}.condition, 1:9), 1:size(sub,1), false);
    for si = 1:2
%         [~,od] = sort(pa(si,:));
        condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), pa(si,:));
        tid = sub.animal == mks(si);
        [avtraj, setraj] = W.cell_avse(trajs(tid));
        plt.ax(si);
        plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'mean trajectory by cue');
        plt.plot(time_at, avtraj, setraj, 'shade','color', condcolors);
        figdata.panelAB{si}.x = time_at;
        figdata.panelAB{si}.y = avtraj;
        figdata.panelAB{si}.se = setraj;
        figdata.panelAB{si}.legend = pa(si,:);
        xs = [];
        ys = reshape(sub.ENTROPY_byCONDITION(tid,:)',[],1);
        for i = W.horz(find(tid))
            time_median = sub.avRT_REJECT(i) * 1000;
            idxt = dsearchn(time_at', time_median);
            tx = [abs(mean(trajs{i}(:,idxt + [-1:1]), 2))];
            xs = [xs;tx];
        end
        plt.ax(2+si);
        plt.setfig_ax('xlabel', 'abs(traj)', 'ylabel', 'entropy');
        stats{si} = plt.scatter(xs, ys, 'corr', 'color', colors{si});

        figdata.panelCD{si}.x = xs;
        figdata.panelCD{si}.y = ys;
        figdata.panelCD{si}.legend = mks;
        figdata.panelCD{si}.stats = stats{si};
            
        W.print(stats{si})
        corAE = W.arrayfun(@(x)corr(abs(trajs{x}), sub.ENTROPY_byCONDITION(x,:)')', find(tid), false);
        corAE = vertcat(corAE{:});
        [av, se] = W.avse(corAE);
        [ppval, ~, ~, allstats] = W.stat_ttest(corAE);
        plt.ax(4+si);
        plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'abs(traj) vs entropy', ...
            'ylim', [-1 0.5], 'xticklabel',{'-1000','cue on', '1000', '2000'});
        plt.plot(time_at, av, se, 'line', 'color', colors{si});
        plt.dashY(0, [-1 1]);
        plt.sigstar(time_at, repmat(-1, 1, length(time_at)), ppval);
        figdata.panelEF{si}.x = time_at;
        figdata.panelEF{si}.y = av;
        figdata.panelEF{si}.se = se;
        figdata.panelEF{si}.legend = mks(si);
        figdata.panelEF{si}.stats = allstats;
    end
    
    plt.update();
end