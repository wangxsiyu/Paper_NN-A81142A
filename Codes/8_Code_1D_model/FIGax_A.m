function [plt,figdata] = FIGax_A(plt, mdX, sub, time_md, ispartial)
    cols = plt.custom_vars.color_monkeys;
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
%     time_md = mdX{1}.time_md;
    if ispartial
        corAE = W.arrayfun(@(x)partialcorr(mdX{x}.a',W.vert(sub.ENTROPY_byCONDITION(x,:)), ...
            W.vert(sub.avCHOICE_byCONDITION(x,:))), ...
        1:size(sub,1), false);
    else
    corAE = W.arrayfun(@(x)corr(mdX{x}.a',W.vert(sub.ENTROPY_byCONDITION(x,:))), ...
        1:size(sub,1), false);
    end
    corAE = horzcat(corAE{:})'; 
    [~,pp] = ttest(corAE);
    [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
        'ylabel', 'retraction coef vs entropy', ...
        'ylim', [-1 0.6], ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    figdata.x = time_md;
    figdata.y = av;
    figdata.se = se;
    figdata.legend = leg;
    figdata.p = pp;
    plt.dashY(0, [-1 0.6]);
    plt.sigstar(time_md, pp*0 -1, pp);
    W.print('sig T (A): %.2f', min(time_md(pp < 0.05 & time_md > 0)));
end