function figdata = main_FIGURE_3_model3D_x0(plt, option1D, sub, mdX, x1D)
    %% figure 2
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
%     plt.figure(3,3,'is_title',1, 'matrix_hole', [1 1 1; 1 1 1; 1 0 0]);
    plt.figure(2,3,'is_title',1, 'matrix_hole', [1 1 1; 1 0 0]);
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
            'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'}, 'ylim', [-1, 0.5]);
        plt.plot(time_md, av, se, 'line', 'color', cols);
        plt.dashY(0, [-1 1]);
        plt.sigstar(time_md, pp*0 -1, pp);
        
        figdata.panelABC{i}.x = time_md;
        figdata.panelABC{i}.y = av;
        figdata.panelABC{i}.se = se;
        figdata.panelABC{i}.p = pp;
%         plt.ax(2,i);
%         pas = reshape(sub.avCHOICE_byCONDITION',[],1);
%         as = W.cellfun(@(x)x, zmag, false);
%         as = horzcat(as{:})';
%         av =[]; se = [];
%         for ti = 1:size(as, 2)
%             [av(:,ti), se(:,ti)] = W.bin_avY_byX(as(:,ti), pas, [0 0.1 0.5 0.9 1]);
%         end
%             
% 
%         for ti = 1:size(as, 2)
%             tavs = {};
%             for si = 1:length(mdX)
%                 tavs{si} = W.bin_avY_byX(zmag{i, si}(ti,:)', sub.avCHOICE_byCONDITION(si,:)', [0 0.1 0.5 0.9 1]);
%             end
%             tavs = vertcat(tavs{:});
%             [~,pp(ti)] = ttest(nanmean(tavs(:, [1 4]),2) - nanmean(tavs(:,2:3),2), [],'tail', 'right');
%         end
% 
% 
% 
% 
%         colra = plt.custom_vars.color_rejectaccept;
%         tod = [1, 4, 2, 3];
%         plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
%             'legend',{'reject, certain', 'accept certain', 'reject, uncertain', 'accept, uncertain'}, ...
%             'legloc', 'SE', ...
%             'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
%         plt.plot(time_md, av(tod,:), se(tod,:), 'line', 'color', [colra strcat(colra, '50')]);
%         plt.dashY(0, [0, 1]);
%         plt.sigstar(time_md, pp*0 +0.94, pp);
    end
    %%
    nses = size(sub, 1);
    tcor =[];
    for si = 1:nses
        tw = W.cell_vertcat_cellfun(@(x)x(2,:) - x(1,:), mdX{si}.x0, false);

%         tw = tw ./repmat(sqrt(sum(tw.^2,2)),1,3);
        if contains(option1D, 'svm')
            w2 = [1,0,0]';
        elseif contains(option1D, 'r_a_w')
            w2 = x1D{si}.w_svm(1:3)';
            w2 = w2 ./ sqrt(sum(w2.^2));
        end
        tcor(:,si) = tw* w2;    
    end
    for i = 1:2
        [tav(i,:), tse(i,:)] = W.avse(tcor(:, sub.idx_animal == i)');
    end

%     corAE = W.arrayfun(@(x)corr(mdX{x}.a',W.vert(sub.ENTROPY_byCONDITION(x,:))), ...
%         1:size(sub,1), false);
    [~, pp] = ttest(tcor');
%     plt.figure;
    plt.new;
    plt.plot(mdX{1}.time_md, tav, tse, 'line', 'color', plt.custom_vars.color_monkeys);
    plt.setfig_ax('xlabel', 'time', 'ylabel', 'correlation (3D vs 1D)', 'legend', plt.custom_vars.name_monkeys, ...
        'ylim', [-0.2, 1]);

    figdata.panelD.x = mdX{1}.time_md;
    figdata.panelD.y = tav;
    figdata.panelD.se = tse;
    figdata.panelD.p = pp;
%     plt.sigstar(time_md, pp*0 -0.2, pp);
    plt.dashY(0, [-0.2, 1]);
    plt.update;