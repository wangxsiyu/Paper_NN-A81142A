function FIG_SUP_alternative_dimension(plt, savename, sub, timeslice, md1, md2)
    if plt.set_savename(savename)
        return;
    end
    %%
    plt.figure(3,3,'matrix_title',[0 0 0;0 1 1;0 0 0], 'matrix_hole', [1 1 1; 1 1 1; 1 0 0]);

    mdX = md2;
    time_md = mdX{1}.time_md;
    mdX = W.cellfun(@(x)x.mdfit, mdX, false);
    axIDs = 1:6;
    % fig - x0
    plt.ax(axIDs(1));
    plt.setfig_ax('ylim', [-1, 1]);
    plt = FIGax_x0(plt, mdX, sub,time_md);
    % fig - evidence
    plt.ax(axIDs(2));
    plt = FIGax_EV(plt, mdX, sub,time_md);

    % reject vs accept
    plt.ax(axIDs(3));
    plt = FIGax_accept_reject(plt, mdX, sub,time_md);

    % correlation between a and entropy
    plt.ax(axIDs(4));
    plt = FIGax_A(plt, mdX, sub,time_md, 0);

    % fig - scatter
    plt = FIGax_Acor(plt, mdX, sub, axIDs(5:6),time_md);
    %
    time_md = md1{1}.time_md;
    ta = cell(1, size(sub, 1));
    tb = cell(1, size(sub, 1));
    for si = 1:size(sub, 1)
        if W.is_stringorchar(timeslice)
            ttmslice = sub.midRT_REJECT(si) * 1000;
        else
            ttmslice = timeslice;
        end
        idxt = dsearchn(time_md', ttmslice);
        ta{si} = md1{si}.mdfit.a(idxt,:); 
        tb{si} = md2{si}.mdfit.a(idxt,:); 
    end
    ta = vertcat(ta{:});
    tb = vertcat(tb{:});
    plt.ax(7);
    str = plt.scatter(ta, tb, 'diag');
    plt.setfig_ax('legend', str, 'xlabel', 'svm', 'ylabel', 'proj', 'legloc', 'NW');

    plt.update([],'ABCDE F');
end