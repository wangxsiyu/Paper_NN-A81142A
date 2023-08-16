figdir = W.get_fullpath(W.mkdir('../../Figures/COSYNE'));
run('../setup_plot.m');
run('../load_behavior.m');
%%
gp = W.analysis_tab_av_bygroup(sub, 'animal', {'V','W'}, ...
    {'avCHOICE_byCONDITION','ENTROPY_byCONDITION', ...
    'avDELAY_byCONDITION', 'avDROP_byCONDITION'});
%%
plt.figure(1,1);
plt = figax_behavior_vs_cue(plt, gp, 'AVCHOICE_BYCONDITION_byANIMAL', 'p(accept)');
plt.update('COSYNE_p_accept',' ');
%%
plt.figure(1,1);
plt = figax_behavior_vs_cue(plt, gp, 'ENTROPY_BYCONDITION_byANIMAL', 'entropy');
plt.update('COSYNE_entropy',' ');