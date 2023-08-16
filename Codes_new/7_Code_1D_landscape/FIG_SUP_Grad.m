function FIG_SUP_Grad(plt, savename, sub, ttmslice, EL)
    if plt.set_savename(savename)
        return;
    end
    EL = W.cellfun(@(x)x.EL_choice, EL, false);
%%
    time_EL = EL{1}.time_at;
    x_EL = EL{1}.x_at;
    pa = [];
    pa = mean(sub.avCHOICE_byCONDITION(sub.animal == 'W',:));
    plt.figure(1,1);
    cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});

    c = 1;
    if isnumeric(ttmslice)
        idxt = dsearchn(time_EL', ttmslice);
        idxt = repmat(idxt, size(sub,1), 1);
    else
        idxt = arrayfun(@(x)dsearchn(time_EL', x),sub.midRT_REJECT * 1000);
    end
%     tEL = W.cellfun(@(t)t.EL{c}(idxt,:), EL, false);
%     tEL = W.cell_mean(tEL);
    gd = W.arrayfun(@(t)EL{t}.grad{c}(idxt(t)+[-1:1],:), 1:size(sub,1), false);
    gd = vertcat(gd{:});
%     gd = gd(sub.idx_animal == 2,:);
    [gd, segd, ngd] = W.avse(gd);
    gd(ngd <= 5) = NaN;

%     si = 11
%     gd = EL{si}.grad{c}(idxt(si),:);

%     gd = nanmean(gd);
    [tEL] = W.calc_EL_integral_1D(gd, x_EL, 0);


    plt.setfig_ax('xlabel', 'position','legloc','SouthEastOutside', 'xlim', [-5, 5]);
    plt.plot(x_EL, tEL,[],'line', 'color', cols{1});
    hold on;
    quiver(x_EL, tEL, gd, gd*0,'off','color',cols{1});
    %     ylabel('$\int_x \frac{dx}{dt}$','interpreter','latex')
    %%
    plt.update([],' ')
end