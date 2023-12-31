function FIGURE_rejectonly(plt, sub, m1,m2,m3)
    %%
    all = [m1;m2;m3];
    time_md = all{1}.time_md;
    plt.figure(1,3,'is_title', 1);
    tlt = {'Original', 'Vanilla', 'Collapsingbound'};
    plt.setfig(1:3,'title', tlt);
    for i = 1:3
        plt.ax(1,i);
        tmdX = W.cellfun(@(x)x.mdfit, all(i,:), false);
        plt = FIGax_rejectonly(plt, tmdX, sub, time_md);
        plt.setfig_ax('legloc', W.iif(i == 3, 'SE', 'none'));
    end
    plt.update;
end