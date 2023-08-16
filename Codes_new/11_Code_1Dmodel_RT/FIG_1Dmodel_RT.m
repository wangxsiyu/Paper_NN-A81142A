function FIG_1Dmodel_RT(plt, savename, sub, option, md1)
    if plt.set_savename(savename)
        return;
    end
    %%
    plt.figure(1,3)
    cols = plt.custom_vars.color_monkeys;
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
    nsession = size(sub, 1);
    time_md = md1{1}.time_md;
    % correlation between a and entropy
    switch option
        case 'reject'
            indices = sub.avCHOICE_byCONDITION < 0.5;
            rt = sub.avRT_REJECT_byCONDITION;
        case 'accept'
            indices = sub.avCHOICE_byCONDITION > 0.5;
            rt = sub.avRT_ACCEPT_byCONDITION;
    end
    idanimal = W.str_getID(sub.animal, mks);
%     sesid = meshgrid(1:size(rt,1),1:size(rt,2))';
%     ntime = length(time_md);
%     pp = NaN(1, ntime);
%     rand_eff = NaN(ntime, nsession);
%     for i = 1:ntime
%         ty = rt(indices);
%         ts = sesid(indices);
%         mdA = W.arrayfun(@(x)md1{x}.mdfit.a(i, :), 1:nsession, false);
%         mdA = W.cell_autoverthorzcat(mdA);
%         tx = mdA(indices);
%         tmk = idanimal(ts)';
%         ttab = table(tx, tmk, ty, ts);        
%         tmd = fitlme(ttab, 'ty~  tx+ (1|ts) + (tx|tmk) ');
%         pp(i) = tmd.Coefficients.pValue(2);
%         trandeff = tmd.randomEffects;
%         rand_eff(i,:) = trandeff(1:nsession);
%         av1(i) = tmd.Coefficients.Estimate(2);
%         se1(i) = 0;
%     end

    corAE = W.arrayfun(@(x)corr(helper_slidemean(md1{x}.mdfit.a(:, indices(x,:)))',...
        W.vert(rt(x,indices(x,:)))), ...
        1:nsession, false);
    corAE = horzcat(corAE{:})';
    [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
    plt.setfig_ax('legend', leg, 'legloc', 'NW', ...
        'xlabel', 'time (ms)', 'ylabel', sprintf('retraction coef vs RT (%s)', option), ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    [~,pp] = ttest(corAE);
    plt.sigstar(time_md, pp*0-1, pp);
    plt.dashY(0,[-1 1]);
    % scatter

    rtav = sub.(['avRT_' upper(option)]);
    rtse = sub.(['seRT_' upper(option)]);
    for i = 1:size(rt,1)
        for j = 1:size(rt,2)
            rt(i,j) = (rt(i,j) - rtav(i))/rtse(i) * ...
                mean(rtse(idanimal == idanimal(i))) + mean(rtav(idanimal == idanimal(i)));
        end
    end
    xs1 = {[],[]};
    xs2 = {[],[]};
    ys1 = {[],[]};
    ys2 = {[],[]};
    for si = 1:nsession
        time_av = sub.avRT_REJECT(si,:) * 1000; 
%         (sub.midRT_REJECT(si,:) - rtav(si))/rtse(si) * ...
%                 mean(rtse(idanimal == idanimal(si))) + mean(rtav(idanimal == idanimal(si))) * 1000;
        idxt = dsearchn(time_md', time_av);
        tx1 = [mean(md1{si}.mdfit.a(idxt + [-1:1], indices(si,:)))]';
        ty1 = rt(si,indices(si,:))'; %- rand_eff(idxt, si);
        xs1{idanimal(si)} = [xs1{idanimal(si)};tx1];
        ys1{idanimal(si)} = [ys1{idanimal(si)};ty1];
    end
    for i = 1:length(mks)
        plt.ax(1+i);
        plt.setfig_ax('title', leg(i), 'xlabel', 'retraction coef', ...
            'ylabel', sprintf('RT (%s)', option));
        stat{i} = plt.scatter(xs1{i}, ys1{i}, 'corr', 'color', cols{i});
        l = lsline;
        tc = plt.translatecolors(cols(i));
        set(l, 'color', tc{1});
        set(l, 'linewidth', plt.param_plt.linewidth);
        W.print(stat{i})
    end
    plt.update;
end


%     for si = 1:2
%         tt = d2.sub(data.animal == mks(si),:);
%         cc = tt.avCHOICE_byCONDITION;
%         rt = tt.avRT_REJECT_byCONDITION;
%         cid = cc <= 0.5;
%         tx = rt(cid);
%         % standardize across sessions
%         sesid = meshgrid(1:size(cid,1),1:size(cid,2))';
%         ts = sesid(cid);
%         rtav = tt.avRT_REJECT;
%         rtse = tt.seRT_REJECT;
%         tx0 = W.vert(arrayfun(@(x)(tx(x) - rtav(ts(x)))/rtse(sesid(x)) * mean(rtse) + mean(rtav), ...
%             1:length(tx)));
%         for ti = 1:length(time_md)
%             ta = W.arrayfun(@(x)mdfit{x}.a(ti,:), find(data.animal == mks(si)), false);
%             ta = vertcat(ta{:});
%             ty = ta(cid);
%             tbl = table(ty, tx0, ts);
%             tmd = fitlme(tbl, 'ty ~ tx0 + (1|ts)');
%             p(si, ti) = tmd.Coefficients.pValue(2);
%             beta(si, ti) = tmd.Coefficients.Estimate(2);
%             se(si, ti) = (tmd.Coefficients.Upper(2) - tmd.Coefficients.Lower(2))/2;
%         end
%     end


%     plt.ax(5);
%     plt.setfig_ax('xlabel', 'retraction coef', 'ylabel', 'RT (accept)');
%     plt.scatter(xs2{1}, ys2{1}, 'corr', 'color', cols{1});
%     plt.ax(6);
%     plt.setfig_ax('xlabel', 'retraction coef', 'ylabel', 'RT (accept)');
%     plt.scatter(xs2{2}, ys2{2}, 'corr', 'color', cols{2});
% 
% 
%     plt.ax(4);
%     indices = W.decell(W.arrayfun(@(x)sub.avCHOICE_byCONDITION(x,:) > 0.5, 1:data.nsession, false));
%     corAE = W.arrayfun(@(x)corr(mdfit{x}.a(:, indices{x})',...
%         W.vert(sub.avRT_ACCEPT_byCONDITION(x,indices{x}))), ...
%         1:data.nsession, false);
%     corAE = horzcat(corAE{:})';
%     [av, se] = W.analysis_av_bygroup(corAE, data.animal);
%     plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', 'ylabel', 'retraction coef vs RT (accept)');
%     plt.plot(time_md, av, se, 'line', 'color', cols);
