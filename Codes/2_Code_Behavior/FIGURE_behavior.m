function figdata = FIGURE_behavior(plt, sub, games)
    %%
    gp = W.analysis_tab_av_bygroup(sub, 'animal', {'V','W'}, ...
        {'avCHOICE_byCONDITION','ENTROPY_byCONDITION', ...
        'avDELAY_byCONDITION', 'avDROP_byCONDITION'});
    %% figures
    plt.figure(3,3,'matrix_hole',[1,1,1;0,1,1;1,1,0]);
    %
    plt.ax(2);
    [plt, figdata.panelC] = FIG_behavior_vs_cue(plt, gp, 'AVCHOICE_BYCONDITION_byANIMAL', 'p(accept)');
    %
    plt.ax(4);
    [plt, figdata.panelD] = FIG_behavior_vs_cue(plt, gp, 'ENTROPY_BYCONDITION_byANIMAL', 'entropy');
    %
    plt.ax(3);
    [plt, figdata.panelE] = FIG_dist_RT(plt, games, sub.animal);
    %
    plt.ax(5);
    [plt, figdata.panelF] = FIG_entropy_vs_RT(plt, sub, 'reject');
    %
    plt.update([], 'ACEDFBG');
end