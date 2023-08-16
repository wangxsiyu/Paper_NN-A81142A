% %%
% vers = W.basenames(W.ls('../Temp'));
% %%
% isoverwrite = true;
% parfor veri = 1:length(vers)
%     versionname = vers(veri);
%     figdir = fullfile('../Figures', versionname);
%     if exist(figdir, 'dir') && ~isoverwrite
%         W.print('folder exists, skip: %s', versionname);
%         continue;
%     end
%     if sum(char(versionname) == '_') > 3
%         versionbasename = W.str_selectbetween2patterns(versionname, [],'_',1,4);
%     else
%         versionbasename = versionname;
%     end
%     %%
%     plt = W_plt('savedir', figdir, ...
%         'issave', true, 'extension', {'svg','jpg'}, ...
%         'isshow', true);
%     plt.set_custom_variables('color_monkeys', {'AZred', 'AZblue'}, ...
%         'color_rejectaccept', {'RSgreen', 'RSred'}, ...
%         'color_anova', {'RSred','AZcactus','AZsand','AZsky'});
    %%
%     sub = W.load(sprintf('../Temp/%s/sub_%s.mat', versionbasename, versionbasename));
%     files = W.dir(sprintf('../Temp/%s/*/dataset*', versionbasename));
%     data = W.load(files.fullpath);
%     games = W.cellfun(@(x)x.games, data, false);
%     %% print stats
%     idxmk = W.str_getID(sub.animal, unique(sub.animal));
%     te_nt = cellfun(@(x)size(x.games,1), data);
%     W.print('#trials = %.2f',W.analysis_av_bygroup(te_nt', idxmk'));
%     idxmk = W.str_getID(sub.animal, unique(sub.animal));
%     te_nt = cellfun(@(x)length(x.spikes), data);
%     W.print('#cells = %.2f',W.analysis_av_bygroup(te_nt', idxmk'));
%     %%
%     files = W.dir(sprintf('../Temp/%s/*/anova*', versionbasename));
%     wv_anova = W.load(files.fullpath);
%     files = W.dir(sprintf('../Temp/%s/*/spikes_cleaning_info*', versionname));
%     infocleaning = W.load(files.fullpath);
%     tfr = W.struct_compilefromcell(infocleaning, 'fr_approx');
%     tfr = [tfr{:}];
%     tperc = W.struct_compilefromcell(infocleaning, 'percbin_sig');
%     tperc = [tperc{:}];
%     tbin = [0:.05:1,2:10,20:20:100];
%     tline = W.bin_avY_byX(tperc, tfr, tbin)
%     plot(tline);
%     set(gca, 'xtick', 1:length(tline),'xticklabel', W.bin_middle(tbin))
    %%
%     Figure1_behavior(plt, sub, games);
    %%
    FigureS1_RTvsEntropy(plt, sub, games);
    %%
    FigureS2_ANOVA(plt, wv_anova, data{1}.time_at, sub.animal)
    %%
    BySession_ANOVA(plt, wv_anova, data{1}.time_at, sub.filename)
    %%
%     files_pca = W.dir(sprintf('../Temp/%s/*/pc*', versionname));
%     ver_pcas = unique(W.file_getprefix(W.file_deprefix(files_pca.filename)));
%     for pcai = 1:length(ver_pcas)
%         plt.set_pltsetting('savesfx', ver_pcas(pcai));
%         tfiles = W.dir(sprintf('../Temp/%s/*/pc*%s*', versionname, ver_pcas(pcai)));
%         wv_pca = W.load(tfiles.fullpath);
%         tfiles = W.dir(sprintf('../Temp/%s/*/decode*%s*', versionname, ver_pcas(pcai)));
%         wv_decode = W.load(tfiles.fullpath);
        %%
%         Figure2_ANOVA_decoding(plt, wv_anova, wv_decode, data{1}.time_at, sub.animal);
        %%
        FigureS3_decodeDelayDrop(plt, wv_pca, wv_decode, sub.animal);
        %%
%         ver_x1Ds = ["x1Dsvm", "x1Dmean"];
%         x1Di = 1;
        %%
%         tfiles = W.dir(sprintf('../Temp/%s/*/%s*%s*', versionname, ver_x1Ds(x1Di), ver_pcas(pcai)));
%         x1D = W.load(tfiles.fullpath);
%         tfiles = W.dir(sprintf('../Temp/%s/*/EL*%s*%s*', versionname, ver_x1Ds(x1Di), ver_pcas(pcai)));
%         EL = W.load(tfiles.fullpath);
        %%
%         Figure3_Energy_landscape_over_time(plt, x1D, EL, games, sub.animal);
        %%
%         Figure3b_grad(plt, EL, sub, 'median');
%         %%
%         Figure4_Energy_landscape_by_cue(plt, EL, sub, 'median')
%         Figure4_Energy_landscape_by_cue(plt, EL, sub, 300);
%         Figure4_Energy_landscape_by_cue(plt, EL, sub, 400);
        %%
        FigureS4_Energy_landscape_by_choice(plt, EL, sub, 'median');
        %%
        FigureS5_avtraj(plt, x1D, games, sub);
        %%
%         tfiles = W.dir(sprintf('../Temp/%s/*/model1D_scaledEV*%s*%s*', versionname, ver_x1Ds(1), ver_pcas(pcai)));
%         md1 = W.load(tfiles.fullpath);
        tfiles = W.dir(sprintf('../Temp/%s/*/model1D_scaledEV*%s*%s*', versionname, ver_x1Ds(2), ver_pcas(pcai)));
        md2 = W.load(tfiles.fullpath);
        %%
%         Figure5_1Dmodel(plt, md1, sub);
        %%
        tfiles = W.dir(sprintf('../Temp/%s/*/model1D_residue*%s*%s*', versionname, ver_x1Ds(1), ver_pcas(pcai)));
        mdev = W.load(tfiles.fullpath);
        %%
        FigureS6_evidence(plt, mdev, sub);
        %%
        FigureS7_1Dmodel(plt, md1, md2, sub, 'median');
        FigureS7_1Dmodel(plt, md1, md2, sub, 450);
        %%
%         Figure7_1Dmodel_RT(plt, md1, sub);
        %%
        FigureS8_1Dmodel_RT(plt, md1, sub);
        %%
        BySession_1Dmodel(plt, md1, sub);
        % %%
        % Figure6_nDmodel(plt, versionname, 20, 3);
        % Figure_individualeigenvalue(plt, versionname, 10, 5);
%     end
% end