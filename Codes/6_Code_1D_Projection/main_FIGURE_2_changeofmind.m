function main_FIGURE_2_changeofmind(plt, savename, dc, sub)
    if plt.set_savename(savename)
        return;
    end

    cm = W.cell_vertcat_cellfun(@(x)x.n_changemind, dc, false);
    sub.n_changemind = cm;
%     gp = W.analysis_tab_av_bygroup(sub, 'animal', {'V','W'}, ...
%         {'avCHOICE_byCONDITION','ENTROPY_byCONDITION', ...
%         'avDELAY_byCONDITION', 'avDROP_byCONDITION','n_changemind'});
    %% figures
    plt.figure(1,2);
    
%     cm = gp.avN_CHANGEMIND_byANIMAL;
%     et = gp.avENTROPY_BYCONDITION_byANIMAL;
    for i = 1:2
        plt.ax(i);
        x = sub.ENTROPY_byCONDITION(sub.idx_animal == i,:);
        y = sub.n_changemind(sub.idx_animal == i,:);
        str = plt.scatter(x(:),y(:), 'corr');
        plt.setfig_ax('legend', str, 'xlabel', 'entropy', 'ylabel', 'changeofmind', 'title', plt.custom_vars.name_monkeys{i});
    end
    plt.update;
end
