figdir = W.get_fullpath(W.mkdir('../../Figures/COSYNE'));
run('../setup_plot.m');
plt.plt_switch.disable_addABCs = true;
%%
load_1D;
%%
plt.figure(1,3);
plt = fig_ax_x0(plt, md1, sub);
plt.new;
plt = fig_ax_EV(plt, md1, sub);

plt.new;
plt = fig_ax_accept_reject(plt, md1, sub);
plt.update('model1D')
%%
plt.figure(1,3);
plt = fig_ax_A(plt, md1, sub);
plt.new;
plt = fig_ax_Acor(plt, md1, sub,[2 3]);
plt.update('model1Dcorr')
%%
Figure7_1Dmodel_RT(plt, md1, sub);
