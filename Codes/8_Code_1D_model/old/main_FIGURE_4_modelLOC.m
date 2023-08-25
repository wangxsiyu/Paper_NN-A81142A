run('../setup_plot.m');
%%
md1 = W_lp.load({'model1Dloc_t0t1000_svm_scaledEVloc_npool1'},[],'cell');
time_md = md1{1}.time_md;
md1 = W.cellfun(@(x)x.mdfit, md1, false);
%%
FIGURE_1D_model(plt, md1, sub, time_md,'test');
%% soft
md1 = W_lp.load({'model1D_t0t1000_svm_residue_npool1'},[],'cell');
time_md = md1{1}.time_md;
md1 = W.cellfun(@(x)x.mdfit, md1, false);
%%
FIGURE_1D_model(plt, md1, sub, time_md,'test');