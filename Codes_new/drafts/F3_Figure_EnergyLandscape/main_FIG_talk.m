figdir = W.get_fullpath(W.mkdir('../../Figures/COSYNE'));
run('../setup_plot.m');
%%
load_EL;
%%
plt.plt_switch.disable_addABCs = true;
%%
Figure3_Energy_landscape_over_time(plt, x1D, EL, games, sub.animal);
%%
Figure4_Energy_landscape_by_cue(plt, EL, sub, 'median')
Figure4_Energy_landscape_by_cue(plt, EL, sub, 300);
Figure4_Energy_landscape_by_cue(plt, EL, sub, 400);
%%
plt.reload_paramdatabase();
plt.param_scale(1,[],1,1.3);
Figure3b_grad(plt, EL, sub, 'median');
