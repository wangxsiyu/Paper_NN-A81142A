function main_FIGURE_1_symmetry(plt, savename, sub, mdX)
    if plt.set_savename(savename)
        return;
    end
    %% symmetry
    for si = 1:size(sub,1)
        tsym = W.cellfun(@(x)[x(2,3)-x(3,2), x(1,3)-x(3,1), x(1,2)-x(2,1)], mdX{si}.a, false);
%         tstat = tsym;
    %     tsdsum = W.cellfun(@(x)[x(2,3)+x(3,2), x(1,3)+x(3,1), x(1,2)+x(2,1)],d{si}.mdfits.covA, false);
    %     tdf = d{si}.mdfits.df;
    %     for x = 1:size(tdf,1)
    %         for y = 1:size(tdf,2)
    %             tsdsum{x,y} = sqrt(tsdsum{x,y}/tdf{x,y});
    %             tstat{x,y} = tsym{x,y}./tsdsum{x,y};    
    %         end
    %     end
        for di = 1:3
            symm{di,si} =cellfun(@(x)x(di), tsym);
    %         tstats{di, si} = cellfun(@(x)x(di), tstat);
        end
    end
    %%
    time_md = mdX{1}.time_md;
    %% 
    plt.figure(1,3,'is_title', 1);
    plt.setfig('ylabel', {'A23-A32','A13-A31','A12-A21'})
    for i = 1:3
        cols = plt.custom_vars.color_monkeys;
    
    %     plt.ax(1,i);
    %     mdX = tstats(i,:);
    %     corAE = W.arrayfun(@(x)sum(mdX{x},2), ...
    %         1:size(sub,1), false);
    %     corAE = horzcat(corAE{:})'; 
    %     [~,pp] = ttest(corAE);
    %     mks = ["V","W"];
    %     [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
    %     leg = W.file_prefix(mks,'Monkey', ' ');
    %     plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
    %         'ylabel', 'retraction coef vs entropy', ...
    %         'ylim', [-0.9 0.6], ...
    %         'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    %     plt.plot(time_md, av, se, 'line', 'color', cols);
    %     plt.dashY(0, [-100 100]);
    %     plt.sigstar(time_md, pp*0 -100.9, pp);
        plt.ax(1,i);
        tmd = symm(i,:);
        corAE = W.arrayfun(@(x)mean(tmd{x},2), ...
            1:size(sub,1), false);
        corAE = horzcat(corAE{:})'; 
        [~,pp] = ttest(corAE);
        mks = ["V","W"];
        [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
        leg = W.file_prefix(mks,'Monkey', ' ');
        plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
            'ylim', [-1 1]/2, ...
            'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
        plt.plot(time_md, av, se, 'line', 'color', cols);
        plt.dashY(0, [-0.5 .5]);
        plt.sigstar(time_md, pp*0 -0.5, pp);
    end
    plt.update();