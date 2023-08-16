figdir = W.get_fullpath(W.mkdir('../../Figures/COSYNE'));
run('../setup_plot.m');
%%
load_ANOVA_decoding;
%%
leg_anova = wv_anova{1}.anova.anovafactornames;
%% figures
plt.figure(1,1);
plt = fig_ax_ANOVA(plt, wv_anova, data{1}.time_at);
plt.update('ANOVA', ' ');
%
plt.figure(1,1);
plt = fig_ax_decoding(plt, wv_decode, data{1}.time_at, sub.animal);
plt.update('decoding', ' ');
%%
files = W.dir(fullfile(datadir, '*/decode_pc50_t0t1000.mat'));
wv_decode50 = W.load(files.fullpath);
%%
plt.figure(1,2);
plt = fig_ax_decoding(plt, wv_decode, data{1}.time_at, sub.animal);
plt.new;
plt = fig_ax_decoding(plt, wv_decode50, data{1}.time_at, sub.animal);
plt.update('decoding', ' ');
