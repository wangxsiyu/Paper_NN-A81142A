function FIGS4_Energy_landscape_by_choice(plt, EL, sub, timeslice, option)
    time_EL = EL{1}.time_EL;
    x_EL = EL{1}.x_EL;
    %% compile curves by cue
    EL_choiceXcue = cell(1, length(EL));
    for si = 1:length(EL)
        if W.is_stringorchar(timeslice)
            ttmslice = sub.avRT_REJECT(si) * 1000;%W.iif(si < 9, 420, 430)
        else
            ttmslice = timeslice;
        end
        idxt = dsearchn(time_EL', ttmslice);
        W.print('median time = %.2f', time_EL(idxt))
        tEL = W.cellfun(@(t)t(idxt,:), EL{si}.EL_choiceXcue, false);
        tEL = vertcat(tEL{:});
        EL_choiceXcue{si} = NaN(18,size(tEL,2));
%         EL_choiceXcue{si}(EL{si}.conds_choiceXcue,:) = tEL;
        EL_choiceXcue{si}(:,:) = tEL;% needs to change
    end
    %% average between monkeys
    mks = unique(sub.animal);
    avEL = {};
    pa = [];
    for i = 1:length(mks)
        avEL{i} = W.cell_mean(EL_choiceXcue(sub.animal == mks(i)));
        % compute pa
        pa(i,:) = mean(sub.avCHOICE_byCONDITION(sub.animal == mks(i),:));
    end
    %% development
    plt.figure(1,2,'is_title', 1, 'gapW_custom', [0 1 1] * 100);
    plt.setfig('title', W.str2cell(W.file_prefix(mks, 'Monkey',' ')));
    cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});
    for i = 1:2
        od = find(pa(i,:) > 0.3 & pa(i,:) < 0.75);
        condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), pa(i,:));
        leg = arrayfun(@(x)sprintf("p = %.2f", x), pa(i,od));
        plt.setfig_ax('xlabel', 'position', 'ylabel', 'potential', ...
            'legloc','eastoutside',...
            'legend', leg, 'xlim', [-3, 3]);
        plt.plot(x_EL, avEL{i}(od,:),[],'line', 'color', condcolors(od), 'linestyle', '--', 'addtolegend', 0);
        plt.plot(x_EL, avEL{i}(od+9,:),[],'line', 'color', condcolors(od));
        plt.new;
    end
    plt.update;
    plt.save(sprintf('FigureS4 - energy landscape by cue at %sms', W.string(timeslice)));
end