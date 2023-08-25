function fig_ax_EL_cue(plt, EL, sub, timeslice)
    time_EL = EL{1}.time_EL;
    x_EL = EL{1}.x_EL;
    %% compile curves by cue
    EL_cue = cell(1, length(EL));
    for si = 1:length(EL)
        if W.is_stringorchar(timeslice)
            ttmslice = sub.midRT_REJECT(si) * 1000;
        else
            ttmslice = timeslice;
        end
        idxt = dsearchn(time_EL', ttmslice);
        tEL = W.cellfun(@(t)t(idxt,:), EL{si}.EL_cue, false);
        EL_cue{si} = vertcat(tEL{:});
    end
    %% average between monkeys
    mks = unique(sub.animal);
    avEL = {};
    seEL = {};
    pa = [];
    for i = 1:length(mks)
        [avEL{i}, seEL{i}] = W.cell_avse(EL_cue(sub.animal == mks(i)));
        % compute pa
        pa(i,:) = mean(sub.avCHOICE_byCONDITION(sub.animal == mks(i),:));
    end
    %% development
    plt.setfig('title', W.str2cell(W.file_prefix(mks, 'Monkey',' ')));
    cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});
    for i = 1:2
        [~,od] = sort(pa(i,:));
        condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), pa(i,:));
        leg = arrayfun(@(x)sprintf("p = %.2f", x), pa(i,od));
        plt.setfig_ax('xlabel', 'position', 'ylabel', 'V', ...
            'legloc','eastoutside',...
            'legend', leg, 'xlim', [-3, 3]);
        plt.plot(x_EL, avEL{i}(od,:),seEL{i}(od,:),'shade', 'color', condcolors(od));
        plt.new;
    end
end