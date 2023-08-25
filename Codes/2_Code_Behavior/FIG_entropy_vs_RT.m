function [plt] = FIG_entropy_vs_RT(plt, sub, option)
    if ~exist('option', 'var') || isempty(option)
        option = 'reject';
    end
    option = upper(option);
    % correlation between RT and entropy
    plt.setfig_ax('xlabel', 'entropy', 'ylabel', 'Reaction time (s)', ...
        'ylim', [],'ytick', 0:.1:2);
    cols = plt.custom_vars.color_monkeys;
    str ={};
    mks = unique(sub.animal);
    for si = 1:2
        tt = sub(sub.animal == mks(si),:);
        cc = tt.avCHOICE_byCONDITION;
        E = tt.ENTROPY_byCONDITION;
        rt = tt.(sprintf('avRT_%s_byCONDITION', option));
        switch option
            case 'REJECT'
                cid = cc <= 0.5;
            case 'ACCEPT'
                cid = cc >= 0.5;
        end
        tx = E(cid);
        ty = rt(cid);
        % standardize across sessions
        sesid = meshgrid(1:size(E,1),1:size(E,2))';
        ts = sesid(cid);
%         ttab = table(tx, ty, ts);
%         tmd = fitlme(ttab, 'ty ~  tx + (1|ts)');
%         randeff = tmd.randomEffects;
%         ty0 = arrayfun(@(x)ty(x) - randeff(ts(x)), 1:length(ts))';
        rtav = tt.(['avRT_' option]);
        rtse = tt.(['seRT_' option]);
        ty0 = W.vert(arrayfun(@(x)(ty(x) - rtav(ts(x)))/rtse(ts(x)) * mean(rtse) + mean(rtav), ...
            1:length(ty)));
%         ty0 = W.vert(arrayfun(@(x)(ty(x) - rtav(ts(x))) + mean(rtav), ...
%             1:length(ty)));
        tstr = plt.scatter(tx, ty0, 'corr', 'color', cols{si});
%         tstr = sprintf('R^2 = %.2f, p = %.2g', tmd.Rsquared.Adjusted, tmd.Coefficients.pValue(2));
        hold on;
        str{si} = sprintf("Monkey %s: %s", mks(si), tstr);
    end
    l = lsline;
    set(l, 'linewidth', plt.param_plt.linewidth);
    plt.setfig_ax('legend', str, 'legloc', "NW");
end