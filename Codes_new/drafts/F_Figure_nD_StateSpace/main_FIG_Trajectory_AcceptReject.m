figdir = W.get_fullpath(W.mkdir('../../Figures/COSYNE'));
run('../setup_plot.m')
run('../load_behavior.m')
plt.set_pltsetting('extension', {'fig'});
W.mkdir(fullfile(figdir, 'session'));
%%
files = W.dir(fullfile(datadir, '*/pca_t0t1000.mat'));
pcs = W.load(files.fullpath);
%%
files = W.dir(fullfile(datadir, '*/x1Dsvm_t0t1000.mat'))
x1D = W.load(files.fullpath);
%%
for si = 1:length(pcs)
    %%
    plt.figure;
    pc = pcs{si}.pc;
    pc = W.cellfun(@(x)x(:,1:3), pc, false);
    d = data{si}.games;
    %
    tid = dsearchn(W.vert(pcs{si}.time_at), sub(si,:).midRT_REJECT * 1000)+1;
    xx = pc{tid};
    id_r = d.choice == 0;
    plt.scatter3D(xx(id_r,:),'color', plt.custom_vars.color_rejectaccept{1});
    plt.scatter3D(xx(~id_r,:), 'color', plt.custom_vars.color_rejectaccept{2});
    plt.setfig('xlabel', 'PC1', 'ylabel', 'PC2', 'zlabel', 'PC3');
    grid on
    
    tw = x1D{si}.w_svm(1:3);
    clm = [xlim();ylim();zlim()];
    tp = [-tw;tw]* min(abs(clm ./ tw'),[],'all');
    plt.plot3D(tp, 'shape', '-');
    plt.update(sprintf('session/choicedim_scatter_S%d', si),' ');
end
%%
%     tid = dsearchn(W.vert(pcs{si}.time_at), sub(si,:).midRT_REJECT * 1000) + [-1:0];
%     plt.figure;
%     id_r = d.choice == 0;
%     for di = 1:size(d,1)
%         tx = W.arrayfun(@(x)pc{x}(di,:), tid, false);
%         tx = vertcat(tx{:});
%         tcol = W.iif(id_r(di), 'r', 'g');
%         plot3(tx(:,1), tx(:,2), tx(:,3), '-', 'color', tcol);
%         hold on;
%     end