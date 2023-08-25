function main_FIGURE_2_1D_model(plt, savename, sub, all)
    if plt.set_savename(savename)
        return;
    end    

    %% Figure
    time_md = all{1}.mdfit{1}.time_md;
    plt.figure(2,3,'is_title', 1);
    tlt = {'Only positive neurons', 'Only negative neurons', 'Mixture'};
    for i = 1:3
        mdX = W.cellfun(@(x)x.mdfit{i}.mdfit, all, false);
        cols = plt.custom_vars.color_monkeys;
    
        plt.ax(1,i);
        plt.setfig_ax('title', tlt{i});
%         corAE = W.arrayfun(@(x)corr(mdX{x}.mdfit.a',W.vert(sub.ENTROPY_byCONDITION(x,:))), ...
%             1:size(sub,1), false);
%         corAE = horzcat(corAE{:})'; 
%         [~,pp] = ttest(corAE);
%         mks = ["V","W"];
%         [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
%         leg = W.file_prefix(mks,'Monkey', ' ');
%         plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
%             'ylabel', 'retraction coef vs entropy', ...
%             'ylim', [-0.9 0.6], ...
%             'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
%         plt.plot(time_md, av, se, 'line', 'color', cols);
%         plt.dashY(0, [-0.9 0.6]);
%         plt.sigstar(time_md, pp*0 -0.9, pp);
        plt = FIGax_A(plt, mdX, sub,time_md, 0);
        
        plt.ax(2,i);
%         pas = reshape(sub.avCHOICE_byCONDITION',[],1);
%         as = W.cellfun(@(x)x.mdfit.a, mdX, false);
%         as = horzcat(as{:})';
%         av =[]; se = [];
%         for i = 1:size(as, 2)
%             [av(:,i), se(:,i)] = W.bin_avY_byX(as(:,i), pas, [0 0.1 0.5 0.9 1]);
%         end
%         for ti = 1:size(as, 2)
%             tavs = {};
%             for si = 1:length(mdX)
%                 tavs{si} = W.bin_avY_byX(mdX{si}.mdfit.a(ti,:)', sub.avCHOICE_byCONDITION(si,:)', [0 0.1 0.5 0.9 1]);
%             end
%             tavs = vertcat(tavs{:});
%             [~,pp(ti)] = ttest(nanmean(tavs(:, [1 4]),2) - nanmean(tavs(:,2:3),2), [],'tail', 'right');
%         end
%         colra = plt.custom_vars.color_rejectaccept;
%         tod = [1, 4, 2, 3];
%         plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
%             'legend',{'reject, certain', 'accept certain', 'reject, uncertain', 'accept, uncertain'}, ...
%             'legloc', 'SE', ...
%             'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
%         plt.plot(time_md, av(tod,:), se(tod,:), 'line', 'color', [colra strcat(colra, '50')]);
%         plt.dashY(0, [.2 1]);
%         plt.sigstar(time_md, pp*0 +0.94, pp);
        plt = FIGax_accept_reject(plt, mdX, sub,time_md);
    end
    plt.update;