function Figure3_Energy_landscape_over_time(plt, x1D, time_at, EL, games, animal)
    %%
    avtraj = {[],[]};
    for ti = 1:length(x1D)
        tt = W.analysis_av_bygroup(x1D{ti}, games{ti}.choice, [0 1]);
        avtraj{1}(ti,:) = tt(1,:);
        avtraj{2}(ti,:) = tt(2,:);
    end
    %%
    time_EL = EL{1}.time_EL;
    x_EL = EL{1}.x_EL;
%     time_at = x1D{1}.time_at;
    EL_choice = W.cellfun(@(x)x.EL_choice, EL, false);
    %% compute average maps
    nx = floor(size(EL_choice{1}{1}, 2)/2);
    merge2maps = @(map)[map{1}(:,1:nx), map{2}(:,nx+1:end)];
    EL_merged = W.cellfun(@(x)merge2maps(x), EL_choice, false);
    %% 
    mks = unique(animal);
    avEL = cell(1, length(mks));
    avTJ = cell(1, length(mks));
    for i = 1:length(mks)
        % average between monkeys
        avEL{i} = W.cell_mean(EL_merged(animal == mks(i)));
        % average traj
        avTJ{i} = [W.avse(avtraj{1}(animal == mks(i),:)); W.avse(avtraj{2}(animal == mks(i),:))];
    end
    %% development
    plt.figure(1,2,'is_title', 1, 'gapW_custom', [0 1 1] * 50);
    plt.setfig('title', W.str2cell(W.file_prefix(mks, 'Monkey',' ')));
    cols = strcat(plt.custom_vars.color_rejectaccept, '50');
    for i = 1:2
        plt.setfig_ax('xlabel','time (ms)',...
            'ylabel', 'position', ...
        'xtick', -500:500:1500, 'xticklabel', {'-500','Cue On','500','1000','1500'}, ...
        'xtickangle', 0);
        imagesc(time_EL, x_EL, avEL{i}');
        ylim([-2.5 2.5])
        tpos = get(plt.fig.axes(plt.fig.axi), 'position');
        colorbar;
        caxis([-2.5 22.5]);
        set(plt.fig.axes(plt.fig.axi), 'position', tpos);
        hold on;
        plt.plot(time_at, avTJ{i}, ...
            [], 'line', 'color', cols);
        plt.new;
    end
    plt.update([], '  ');
%     plt.save('Figure3 - development','  ');
end