run('../setup_analysis.m')
run('../setup_plot.m')
subs = W.load(fullfile(datadir, 'behavior_sub.mat'));
ver_pca = 't0t1000';
ses = W.dir(datadir, 'folder');
nses = size(ses,1);
for si = 1:nses
    sdir = ses.fullpath(si);
    mdname = fullfile(sdir, sprintf('model3Dpure.mat'));
    mdfit{si} = W.load(mdname);
end
%% compute eig
zeig = cell(3,nses);
for si = 1:nses
    teig = W.cellfun(@(x)eig(x), mdfit{si}.mdfit_3D.a, false);
    for di = 1:3
        zeig{di,si} =cellfun(@(x)x(di), teig);
    end
end
%%
zmag = W.cellfun(@(x)abs(x), zeig);
%%
run('../load_behavior.m');
%%
plt.figure(2,3,'is_title',1);
for i = 1:3
    cols = plt.custom_vars.color_monkeys;
    plt.ax(1,i);
    corAE = W.arrayfun(@(x)corr(zmag{i,x}',W.vert(sub.ENTROPY_byCONDITION(x,:))), ...
        1:size(sub,1), false);
    corAE = horzcat(corAE{:})'; 
    [~,pp] = ttest(corAE);
    [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
        'ylabel', 'retraction coef vs entropy', ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    plt.dashY(0, [-0.9 0.6]);
    plt.sigstar(time_md, pp*0 -0.9, pp);
    
    plt.ax(2,i);
    pas = reshape(subs.avCHOICE_byCONDITION',[],1);
    as = W.cellfun(@(x)x, zeig, false);
    as = horzcat(as{:})';
    av =[]; se = [];
    for i = 1:size(as, 2)
        [av(:,i), se(:,i)] = W.bin_avY_byX(as(:,i), pas, [0 0.1 0.5 0.9 1]);
    end
    colra = plt.custom_vars.color_rejectaccept;
    tod = [1, 4, 2, 3];
    plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
        'legend',{'reject, certain', 'accept certain', 'reject, uncertain', 'accept, uncertain'}, ...
        'legloc', 'SE', ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av(tod,:), se(tod,:), 'line', 'color', [colra strcat(colra, '50')]);
    plt.dashY(0, [.2 .2]);
end
%% symmetry
for si = 1:nses
    tsym = W.cellfun(@(x)[x(2,3)-x(3,2), x(1,3)-x(3,1), x(1,2)-x(2,1)], mdfit{si}.mdfit_3D.a, false);
    tstat = tsym;
    tsdsum = W.cellfun(@(x)[x(2,3)+x(3,2), x(1,3)+x(3,1), x(1,2)+x(2,1)],mdfit{si}.mdfit_3D.covA, false);
    tdf = mdfit{si}.mdfit_3D.df;
    for x = 1:size(tdf,1)
        for y = 1:size(tdf,2)
            tsdsum{x,y} = sqrt(tsdsum{x,y}/tdf{x,y});
            tstat{x,y} = tsym{x,y}./tsdsum{x,y};    
        end
    end
    for di = 1:3
        symm{di,si} =cellfun(@(x)x(di), tsym);
        tstats{di, si} = cellfun(@(x)x(di), tstat);
    end
end
%%
time_md = mdfit{1}.time_md;
%% 
plt.figure(2,3,'is_title', 1);
for i = 1:3
    mdX = tstats(i,:);
    cols = plt.custom_vars.color_monkeys;

    plt.ax(1,i);
    corAE = W.arrayfun(@(x)sum(mdX{x},2), ...
        1:size(subs,1), false);
    corAE = horzcat(corAE{:})'; 
    [~,pp] = ttest(corAE);
    mks = ["V","W"];
    [av, se] = W.analysis_av_bygroup(corAE, subs.animal, mks);
    leg = W.file_prefix(mks,'Monkey', ' ');
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
        'ylabel', 'retraction coef vs entropy', ...
        'ylim', [-0.9 0.6], ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    plt.dashY(0, [-100 100]);
    plt.sigstar(time_md, pp*0 -100.9, pp);
    plt.ax(2,i);
    mdX = symm(i,:);
    corAE = W.arrayfun(@(x)sum(mdX{x},2), ...
        1:size(subs,1), false);
    corAE = horzcat(corAE{:})'; 
    [~,pp] = ttest(corAE);
    mks = ["V","W"];
    [av, se] = W.analysis_av_bygroup(corAE, subs.animal, mks);
    leg = W.file_prefix(mks,'Monkey', ' ');
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
        'ylabel', 'retraction coef vs entropy', ...
        'ylim', [-0.9 0.6], ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    plt.dashY(0, [-1 1]);
    plt.sigstar(time_md, pp*0 -0.9, pp);
end