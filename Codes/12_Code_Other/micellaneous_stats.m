masterdir = '..\TempData';
version = W.basenames(masterdir);
%% loopers
W_lp = W_looper_folder(masterdir);
sub = W.decell(W_lp.looper_loadall('sub'));
sub = cellfun(@(x)x, sub);
sub = struct2table(sub);
%% 1-basin vs 2-basin
m1 = W_lp.looper_loadall({'model1D_t0t1000_svmp_midRT_nstd_1basin_npool1', ...
    'model1D_t0t1000_svmp_midRT_nstd_scaledEV_npool1'}, 'cell');
time_md = m1{1}{1}.time_md;
AIC1 = cellfun(@(x)mean(x.mdfit.AIC(time_md >= 0 & time_md <=1000)), m1{1});
AIC2 = cellfun(@(x)mean(x.mdfit.AIC(time_md >= 0 & time_md <=1000)), m1{2});
%% value responses
anova = W_lp.looper_loadall('anova_posneg');
anova = anova{1};
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

%
%         steFR = W.cellfun(@(x)x.steFR_byPosNeg, fr);