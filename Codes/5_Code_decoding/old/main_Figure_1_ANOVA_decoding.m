run('../setup_plot.m');
W_lp.add_sfx('t0t1000');
%%
data = W_lp.load({'anova', 'decoding_autosfx', 'data_cleaned'}, [], 'cell');
%%
wv_anova = W.cellfun(@(x)x, data(:,1), false);
wv_decode = W.cellfun(@(x)x, data(:,2), false);
FIG_ANOVA_decoding(plt, wv_anova, wv_decode, data{1,3}.time_at, sub.animal);
%% 