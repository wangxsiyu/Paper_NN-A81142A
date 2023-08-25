function FIGURE_1D_model(plt, mdX, sub, ver, ispartial)
    %%
    if plt.set_savename(savename)
        return;
    end
    time_md = mdX{1}.time_md;
    mdX = W.cellfun(@(x)x.mdfit, mdX, false);
    %%
    plt.figure(2,3,'matrix_title',[0 0 0;0 1 1]);

    axIDs = 1:6;
    % fig - x0
    plt.ax(axIDs(1));
    plt.setfig_ax('ylim', [-1, 1]);
    plt = FIGax_x0(plt, mdX, sub,time_md);
    if contains(ver, 'scaledEV')
        % fig - evidence
        plt.ax(axIDs(2));
        plt = FIGax_EV(plt, mdX, sub,time_md);
    elseif contains(ver, 'residue')
        plt.ax(axIDs(2));
        plt = FIGax_EVresidue(plt, mdX, sub,time_md);
    end

    % reject vs accept
    plt.ax(axIDs(3));
    plt = FIGax_accept_reject(plt, mdX, sub,time_md);

    % correlation between a and entropy
    plt.ax(axIDs(4));
    plt = FIGax_A(plt, mdX, sub,time_md, ispartial);

    % fig - scatter
    plt = FIGax_Acor(plt, mdX, sub, axIDs(5:6),time_md);


    plt.update([],'ABCDE F');
end
%%
%         plt.ax(7)
%         corAE = W.arrayfun(@(x)diag(corr(md.mdfit{x}.a',md2.mdfit{x}.a')), ...
%             1:data.nsession, false);
%         corAE = horzcat(corAE{:})';
%         [~,pp] = ttest(corAE);
%         [av, se] = W.analysis_av_bygroup(corAE, data.animal);
%         plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
%             'ylabel', 'retraction coef vs entropy', ...
%             'ylim', [-0.9 0.6], ...
%             'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
%         plt.plot(md.time_md, av, se, 'line', 'color', cols);
%         plt.dashY(0, [-0.9 0.6]);
%         plt.sigstar(md.time_md, pp*0 -0.9, pp);