function figdata = main_FIGURE_2_model3D(plt, sub, mdX)
    time_md = mdX{1}.time_md;
    %% compute eig
    nses = size(sub, 1);
    zeig = cell(3,nses);
    for si = 1:nses
        teig = W.cellfun(@(x)eig(x), mdX{si}.a, false);
        for di = 1:3
            zeig{di,si} =cellfun(@(x)x(di), teig);
        end
    end
    %% compute relative magnitude of imaginary component
    pim = W.cellfun(@(x)mean(imag(x).^2 ./ [imag(x).^2 + real(x).^2], 'all'), zeig);
    mean(pim')
    %%
    zmag = W.cellfun(@(x)abs(x), zeig);
    %%
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
    plt.figure(1,3,'is_title',1);
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
            'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'}, ...
            'ylim', [-1, 0.5]);
        plt.plot(time_md, av, se, 'line', 'color', cols);
        figdata.panelABC{i}.x = time_md;
        figdata.panelABC{i}.y = av;
        figdata.panelABC{i}.se = se;
        figdata.panelABC{i}.p = pp;
        plt.dashY(0, [-1, 1]);
        plt.sigstar(time_md, pp*0 -0.9, pp);
        
%         plt.ax(2,i);
%         pas = reshape(sub.avCHOICE_byCONDITION',[],1);
%         as = W.cellfun(@(x)x, zeig, false);
%         as = horzcat(as{:})';
%         av =[]; se = [];
%         for i = 1:size(as, 2)
%             [av(:,i), se(:,i)] = W.bin_avY_byX(as(:,i), pas, [0 0.1 0.5 0.9 1]);
%         end
%         colra = plt.custom_vars.color_rejectaccept;
%         tod = [1, 4, 2, 3];
%         plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
%             'legend',{'reject, certain', 'accept certain', 'reject, uncertain', 'accept, uncertain'}, ...
%             'legloc', 'SE', ...
%             'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
%         plt.plot(time_md, av(tod,:), se(tod,:), 'line', 'color', [colra strcat(colra, '50')]);
%         plt.dashY(0, [.2 .2]);
    end
    plt.update;

%% ratio of eigenvalue
% time_md = d{1}.time_md;
% mks = unique(sub.animal);
% leg = W.file_prefix(mks,'Monkey', ' ');
% plt.figure(2,3,'is_title',1);
% for i = 1:3
%     iis = setdiff(1:3, i);
%     i1 = iis(1);
%     i2 = iis(2);
%     cols = plt.custom_vars.color_monkeys;
%     plt.ax(1,i);
%     corAE = W.arrayfun(@(x)corr((zmag{i1,x}./zmag{i2,x})',W.vert(sub.ENTROPY_byCONDITION(x,:))), ...
%         1:size(sub,1), false);
%     corAE = horzcat(corAE{:})'; 
%     [~,pp] = ttest(corAE);
%     [av, se] = W.analysis_av_bygroup(corAE, sub.animal, mks);
%     plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
%         'ylabel', 'retraction coef vs entropy', ...
%         'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
%     plt.plot(time_md, av, se, 'line', 'color', cols);
%     plt.dashY(0, [-0.9 0.6]);
%     plt.sigstar(time_md, pp*0 -0.9, pp);
%     
%     plt.ax(2,i);
%     pas = reshape(sub.avCHOICE_byCONDITION',[],1);
%     as = W.cellfun(@(x)x, zeig, false);
%     as = horzcat(as{:})';
%     av =[]; se = [];
%     for i = 1:size(as, 2)
%         [av(:,i), se(:,i)] = W.bin_avY_byX(as(:,i), pas, [0 0.1 0.5 0.9 1]);
%     end
%     colra = plt.custom_vars.color_rejectaccept;
%     tod = [1, 4, 2, 3];
%     plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
%         'legend',{'reject, certain', 'accept certain', 'reject, uncertain', 'accept, uncertain'}, ...
%         'legloc', 'SE', ...
%         'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'}, ...
%         'ylim', [0.6 1]);
%     plt.plot(time_md, av(tod,:), se(tod,:), 'line', 'color', [colra strcat(colra, '50')]);
%     plt.dashY(0, [.2 .2]);
% end
% plt.update('model3D');