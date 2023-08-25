run('../setup_plot.m');
%%
W_lp.reset();
W_lp.add_loopsfx("t0t1000", {"svm", "mean"}, "scaledEV", "npool1");
W_lp.add_loopsfx("t0t1000", {"svm","svm1000"}, "scaledEV", {'npool1', 'npool3'});
W_lp.add_loopsfx("t0t1000", {'svm'}, {'scaledEVsoft', 'scaledEVloc'}, {'npool1'});
W_lp.add_loopsfx("t0t1000", {'svm'}, {'scaledEVsoftfixwin'}, {'npool3'});
W_lp.loopsfx_all('function_FIG_1D', {'model1D_autosfx4','sub'}, 'FIG_1D', plt, 'variable3', 1);
%%
W_lp.reset();
W_lp.add_loopsfx("t0t1000", "svm", {'residue','residuesoftfixwin'}, "npool1");
W_lp.add_loopsfx("t0t1000", {'svm'}, {'residuesoft', 'residueloc'}, {'npool1'});
W_lp.loopsfx_all('function_FIG_1D', {'model1D_autosfx4','sub'}, 'FIG_1D', plt, 'variable3');
%%
%% residual model
md1 = W_lp.load({'model1D_t0t1000_svm_residue_npool1'},[],'cell');
time_md = md1{1}.time_md;
mdX = W.cellfun(@(x)x.mdfit, md1, false);
figdir = './Figures';
run('../setup_plot.m');
plt.figure(2,2,'matrix_title',[0 0 ; 1 1]);

axIDs = [0 0 2 3 4 5]-1;
% plt.ax(axIDs(1));
% plt = FIGax_x0(plt, mdX, sub,time_md);

% fig - evidence
% plt.ax(axIDs(2));
% plt = FIGax_EV(plt, mdX, sub,time_md);

% reject vs accept
plt.ax(axIDs(3));
plt = FIGax_accept_reject(plt, mdX, sub,time_md);

% correlation between a and entropy
plt.ax(axIDs(4));
plt = FIGax_A(plt, mdX, sub,time_md);

% fig - scatter
plt = FIGax_Acor(plt, mdX, sub, axIDs(5:6),time_md);


plt.update('residual','ABCDE F');
%%
% Figure7_1Dmodel_RT(plt, md1, sub);
