function plt = FIGax_EVresidue(plt, mdX, sub, time_md)

    cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
%     time_md = mdX{1}.time_md;

    evs = W.cellfun(@(x)x.b_ev, mdX);
%     evs = horzcat(evs{:})';
%     [~,pp] = ttest(evs, [], 'tail', 'right');
    sub.evs = W.vert(evs);
    [gp] = W.analysis_1group(sub);
    condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), gp.GPav_avCHOICE_byCONDITION);
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'beta EV', ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'}, ...
        'ylim', [-1 1]);
    plt.plot(time_md, gp.GPav_evs{1}', gp.GPste_evs{1}', 'line', 'color', condcolors);
%     plt.sigstar(time_md, pp*0 -0.04, pp);
    plt.dashY(0, [-1 1]);
end