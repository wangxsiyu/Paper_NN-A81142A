function [plt, figdata] = FIGax_x0(plt, mdX, sub, time_md)
    cols = plt.custom_vars.color_monkeys;
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
%     time_md = mdX{1}.time_md;

    x0_1 = W.cellfun(@(x)x.x0(:,1), mdX);
    x0_1 = horzcat(x0_1{:})';
    x0_2 = W.cellfun(@(x)x.x0(:,2), mdX);
    x0_2 = horzcat(x0_2{:})';

    [~,pp_1] = ttest(x0_1-x0_2);
%     [~,pp_2] = ttest(x0_2);
    [av1, se1] = W.analysis_av_bygroup(x0_1, sub.animal, mks);
    [av2, se2] = W.analysis_av_bygroup(x0_2, sub.animal, mks);
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', 'ylabel', 'x0', ...
        'legloc', 'SE', ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av2, se2, 'line', 'color', cols);
    hold on;
    plt.plot(time_md, av1, se1, 'line', 'color', strcat(cols,'50'), 'addtolegend', 0);
    plt.dashY(0, [-1 1]);
    figdata.x = time_md;
    figdata.y_dark = av2;
    figdata.se_dark = se2;
    figdata.y_light = av1;
    figdata.se_light = se1;
    figdata.monkeys = mks;
    W.print('sig T (x0-1): %.2f', min(time_md(pp_1 < 0.05 & time_md > 0)));
%     W.print('sig T (x0-2): %.2f', min(time_md(pp_2 < 0.05 & time_md > 0)));

end