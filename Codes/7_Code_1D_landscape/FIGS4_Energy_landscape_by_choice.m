function figdata = FIGS4_Energy_landscape_by_choice(plt, EL, sub, timeslice, option)
    time_EL = EL{1}.EL_cue.time_at;
    x_EL = EL{1}.EL_cue.x_at;
    %% compile curves by cue
    EL_choiceXcue = cell(1, length(EL));
    grad_choiceXcue = cell(1, length(EL));
    for si = 1:length(EL)
        if W.is_stringorchar(timeslice) && strcmp(timeslice, 'medianRT')
            ttmslice = sub.midRT_REJECT(si) * 1000;
        else
            ttmslice = str2double(timeslice);
        end
        idxt = dsearchn(time_EL', ttmslice);
        EL_choiceXcue{si} = W.cell_vertcat_cellfun(@(t)t(idxt,:), EL{si}.EL_choiceXcue.EL, false);
        grad_choiceXcue{si} = W.cell_vertcat_cellfun(@(t)t(idxt,:), EL{si}.EL_choiceXcue.grad, false);
    end
    %% average between monkeys
    mks = unique(sub.animal);
    avEL = {};
    seEL = {};
    pa = [];
    for i = 1:length(mks)
        switch option
            case 'avEL'
                [avEL{i}, seEL{i}] = W.cell_avse(EL_choiceXcue(sub.idx_animal == i));
            case 'avGrad'
                [~, seEL{i}] = W.cell_avse(EL_choiceXcue(sub.idx_animal == i));
                [tavgrad, ~] = W.cell_avse(grad_choiceXcue(sub.idx_animal == i));
                [avEL{i}, ~] = W.calc_EL_integral_1D(tavgrad, x_EL, 0); % this seEL is wrong, is gradient and not uncertainty
        end
        % compute pa
        pa(i,:) = mean(sub.avCHOICE_byCONDITION(sub.idx_animal == i,:));
    end
    %% by choice
    plt.figure(1,2,'is_title', 1, 'gapW_custom', [0 1 1] * 4);
    plt.setfig('title', W.str2cell(W.file_prefix(mks, 'Monkey',' ')));
    cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});
    figdata.monkeys = mks;
    for i = 1:2
        od = find(pa(i,:) > 0.3 & pa(i,:) < 0.75);
        condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), pa(i,:));
        leg = arrayfun(@(x)sprintf("p = %.2f", x), pa(i,od));
        plt.setfig_ax('xlabel', 'position', 'ylabel', 'potential', ...
            'legloc','eastoutside',...
            'legend', leg, 'xlim', [-3, 3]);
        plt.plot(x_EL, avEL{i}(od*2-1,:),seEL{i}(od*2-1,:),'shade', 'color', condcolors(od), 'linestyle', '--', 'addtolegend', 0);
        plt.plot(x_EL, avEL{i}(od*2,:),seEL{i}(od*2,:),'shade', 'color', condcolors(od));
        plt.new;
        figdata.panel{i}.x = x_EL;
        figdata.panel{i}.y = avEL{i}([od*2-1, od*2],:);
        figdata.panel{i}.se = seEL{i}([od*2-1, od*2],:);
    end
    plt.update;
    plt.save(sprintf('FigureS4 - energy landscape by cue at %sms', W.string(timeslice)));
end