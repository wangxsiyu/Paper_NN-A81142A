run('../setup_plot.m')
%%
anova = W_lp.load('anova_pos_neg');
%% Figure positive/negative neurons
perc_positive = W.cellfun(@(x)x.perc_positive, anova, false);
plt.figure(1,1);
plt.ax(1);
dst = [];
for i = 1:16
    [dst(i,:), x] = hist(vertcat(perc_positive{i}), 20);
    dst(i,:) = dst(i,:)./sum(dst(i,:))/mean(diff(x));
end
[tav, tse] = W.analysis_av_bygroup(dst, sub.animal, {"V", "W"});
plt.plot(x, tav, tse, 'line', 'color', plt.custom_vars.color_monkeys);
plt.setfig_ax('xlabel', 'percentage of positive neurons', 'ylabel', 'density', ...
    'legend', {'Monkey V', 'Monkey W'});
plt.update('distribution of neurons');
%%
npos = W.cellfun(@(x)x.n_pos_neg_min(1), anova);
nneg = W.cellfun(@(x)x.n_pos_neg_min(2), anova);
p = npos./(npos + nneg);
[avW, seW] = W.avse(p(sub.animal == "W")')
[avV, seV] = W.avse(p(sub.animal == "V")')
npos = W.cellfun(@(x)x.n_sig_pos_neg_min(1), anova);
nneg = W.cellfun(@(x)x.n_sig_pos_neg_min(2), anova);
p = npos./(npos + nneg);
[avW, seW] = W.avse(p(sub.animal == "W")')
[avV, seV] = W.avse(p(sub.animal == "V")')


%% loadings on the choice dimension
lds = W_lp.loop('function_loadings1D', {'anova_pos_neg', 'pca_t0t1000', 'x1D_t0t1000_svm'}, 'loadings_pos_neg');
lds = W.cellfun(@(x)x.av_ld, lds);
lds = vertcat(lds{:});


%% variability in firing rate
fr = W_lp.loop('function_fr_pos_neg', {'anova_pos_neg', 'data_cleaned'}, 'fr_pos_neg');
avFR = W.cellfun(@(x)x.avFR_byPosNeg, fr);
steFR = W.cellfun(@(x)x.steFR_byPosNeg, fr);

%% FIGURE
[tav, tse] = W.analysis_av_bygroup(lds, sub.animal);
plt.figure(1,3, 'is_title', 1);
plt.plot(W.bin_middle([0:.1:1]), tav, tse, 'line', 'color', plt.custom_vars.color_monkeys);
plt.setfig_ax('xlabel', 'value coding of neurons', ...
    'ylabel', 'weight on the choice dimension', ...
    'legend', plt.custom_vars.name_monkeys);
% plt.update('valuecoding_vs_weight');
% %% FIGURE
% plt.figure(1,2, 'is_title',1);
plt.setfig(2:3,'title', plt.custom_vars.name_monkeys)
cols = plt.translatecolors({plt.custom_vars.color_rejectaccept{1},'yellow',plt.custom_vars.color_rejectaccept{2}});
mks = unique(sub.animal);
plt.setfig_all(2:3,'xlabel', 'value coding of neurons', 'ylabel', 'mean firing rates')
[tav, tse] = W.analysis_av_bygroup(avFR, sub.animal);
for i = 1:2
    pa = mean(sub.avCHOICE_byCONDITION(sub.animal == mks(i),:));
    [~,od] = sort(pa);
    condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), pa);
    plt.ax(1,i+1);
    plt.plot(W.bin_middle(0:.1:1), tav{i}(od,:), tse{i}(od,:), 'line', 'color', condcolors(od));
end
% plt.setfig_all(3:4,'xlabel', 'value coding of neurons', 'ylabel', 'std firing rates')
% [tav, tse] = W.analysis_av_bygroup(steFR, sub.animal);
% for i = 1:2
%     pa = mean(sub.avCHOICE_byCONDITION(sub.animal == mks(i),:));
%     [~,od] = sort(pa);
%     condcolors = W.arrayfun(@(x)plt.interpolatecolors(cols, [0,.5,1], x), pa);
%     plt.ax(2,i);
%     plt.plot(W.bin_middle(0:.1:1), tav{i}(od,:), tse{i}(od,:), 'line', 'color', condcolors(od));
% end
plt.update('FR vs pos_neg');