function main_optional_Figure_1_compare_3driftrates(plt, sub)
dr0 = sub.avDRIFTRATE_byCONDITION;
dr1 = sub.pyDDM_vanilla;
dr2 = sub.pyDDM_collapsingbound;
%% drift rate correlation by animal
plt.figure(2,2, 'is_title',1);
plt.setfig(1:2, 'title', plt.custom_vars.name_monkeys);
plt.setfig_all('legloc', 'SE');
for i = 1:2
    tid = sub.idx_animal == i;
    plt.ax(1,i);
    str = plt.scatter(reshape(dr0(tid,:),[],1), reshape(dr1(tid,:), [], 1), 'corr');
    plt.setfig_ax('legend', str, 'xlabel', 'drift rate (original)', 'ylabel', 'drift rate (vanilla)');

    plt.ax(2,i);
    str = plt.scatter(reshape(dr0(tid,:),[],1), reshape(dr2(tid,:), [], 1), 'corr');
    plt.setfig_ax('legend', str, 'xlabel', 'drift rate (original)', 'ylabel', 'drift rate (collapsing bound)');
end
plt.update;
%% 