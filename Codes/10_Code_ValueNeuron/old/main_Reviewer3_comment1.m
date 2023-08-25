vers = W.dir('../Temp', 'folder');
vers = vers(arrayfun(@(x)sum(char(x)=='_'), vers.filename) == 3,:);
versioni = 2; % use all 50/50
isoverwrite = true;
versionname = vers.filename(versioni);
ses = W.dir(vers.fullpath(versioni), 'folder');
files = W.ls(vers.fullpath(versioni), 'file');
files = files(contains(files, 'sub'));
subs = W.load(files);
%%
nsession = length(ses.filename);
saveout = cell(1, nsession);
for si = 1:nsession
    sessionname = ses.filename(si);
    sub = subs(strcmp(subs.filename, sessionname),:);
    dataname = sprintf('dataset_%s.mat', sessionname);
    data0 = W.load(fullfile(ses.fullpath(si), dataname));
    data0.games.value = arrayfun(@(x) sub.avCHOICE_byCONDITION(x), data0.games.condition);
    %% anova to figure out positive vs negative neurons
    savename = fullfile(ses.fullpath(si), sprintf('anova_value_%s.mat', sessionname));
    factornames = {'choice','value'};
    model = [1,0;0 1;1 1];
    [wv_anova, rawcoef] = W.neuro_ANOVA(data0, [], factornames, [], [0 1000], 0.05, 50, 'model', model, ...
        'continuous', [2]);
    rawcoef = rawcoef{1};
    t_rowid = find(strcmp(rawcoef{1}.varname, 'value'));
    rawcoef = cellfun(@(x)x.value(t_rowid), rawcoef);
    W.save(savename, 'anova', wv_anova.anova, 'raw_panova', wv_anova.raw_panova, 'raw_coef', rawcoef);
    %% basic cleaning
    [data1, spikes_cleaning_info, iskeep] = W.clean_spikes(data0, [], 0.2, 0.05, wv_anova);
    rawcoef = rawcoef(iskeep, :);
    %% choose positive/negative/mixed neuron populations
    tid = data1.time_at >=0 & data1.time_at <= 1000;
    perc_positive = mean(rawcoef(:, tid)>0,2);
    saveout{si} = struct;
    saveout{si}.perc_positive = perc_positive;

    % compute chance
    nmax = sum(tid);
    pas = abs(pascal(nmax + 1,1));
    w = repmat(1./sum(pas, 2), 1, nmax + 1);
    p = w.*pas;
    cump = cumsum(p,2);
    pval = arrayfun(@(x)1-cump(nmax+1, max(x,1)), 1:nmax);
    nchance = find(pval< 0.05, 1 );

    id_positive = perc_positive * nmax >= nchance - 1e-5;
    id_negative = perc_positive * nmax <= nmax - nchance + 1e-5;
    ncommon = min(sum(id_positive), sum(id_negative));
    saveout{si}.num_pos_neg_common_sig = [sum(id_positive), sum(id_negative), ncommon];

    id_positive = perc_positive >= 0.5;
    id_negative = perc_positive <= 0.5;
    ncommon = min(sum(id_positive), sum(id_negative));
    saveout{si}.num_pos_neg_common = [sum(id_positive), sum(id_negative), ncommon];
    %% sample sub populations
    pop_pos = sort(randsample(find(id_positive), ncommon));
    pop_neg = sort(randsample(find(id_negative), ncommon));
    pop_mix = sort(randsample(1:length(perc_positive), ncommon));
    idx_pops = {pop_pos, pop_neg, pop_mix};
    name_pops = {'pos','neg','mix'};
    %% loop over three sub populations
    saveout{si}.mdfit = cell(1,3);
    for pi = 1:3
        data = data1;
        data.spikes = data.spikes(idx_pops{pi});
        %
        ver_pcs = {'t0t1000','q5q95'};
        pci = 1;
        wv_pc = main_PCA_projection(data, ver_pcs{pci});
        ver_1Dproj = {'svm','mean'};
        proji = 1;
        x1D = main_1D_projection(wv_pc, data.games, ver_1Dproj{proji});
        ver_1Dmodel = {'scaledEV', 'residue'};
        mdi = 1;
        npool = 3;
        nstep = data.time_window/unique(diff(data.time_at));
        mdfit = main_1D_model(x1D, data.games, sub, npool, nstep, ver_1Dmodel{mdi});
        saveout{si}.mdfit{pi} = mdfit;
    end
end
%%
W.save('../Temp/review3_comment1.mat', 'all', saveout);
%%
all = importdata('../Temp/review3_comment1.mat');

figdir = W.mkdir('../Figures/Reviewer3');
plt = W_plt('savedir', figdir, ...
    'issave', true, 'extension', {'svg','jpg'}, ...
    'isshow', true);
plt.set_custom_variables('color_monkeys', {'AZred', 'AZblue'}, ...
    'color_rejectaccept', {'RSgreen', 'RSred'}, ...
    'color_anova', {'RSred','AZcactus','AZsand','AZsky'});
%% Figure positive/negative neurons
perc_positive = W.cellfun(@(x)x.perc_positive, all, false);
plt.figure(1,1);
plt.ax(1);
dst = [];
for i = 1:16
    [dst(i,:), x] = hist(vertcat(perc_positive{i}), 21);
    dst(i,:) = dst(i,:)./sum(dst(i,:))/mean(diff(x));
end
[tav, tse] = W.analysis_av_bygroup(dst, subs.animal, {"V", "W"});
plt.plot(x, tav, tse, 'line', 'color', plt.custom_vars.color_monkeys);
plt.setfig_ax('xlabel', 'percentage of positive neurons', 'ylabel', 'density', ...
    'legend', {'Monkey V', 'Monkey W'});
plt.update('distribution of neurons');
%% Figure
time_md = all{1}.mdfit{1}.time_md;
plt.figure(2,3,'is_title', 1);
tlt = {'Only positive neurons', 'Only negative neurons', 'Mixsure'};
for i = 1:3
    mdX = W.cellfun(@(x)x.mdfit{i}, all, false);
    cols = plt.custom_vars.color_monkeys;

    plt.ax(1,i);
    plt.setfig_ax('title', tlt{i});
    corAE = W.arrayfun(@(x)corr(mdX{x}.mdfit.a',W.vert(subs.ENTROPY_byCONDITION(x,:))), ...
        1:size(subs,1), false);
    corAE = horzcat(corAE{:})'; 
    [~,pp] = ttest(corAE);
    mks = ["V","W"];
    [av, se] = W.analysis_av_bygroup(corAE, subs.animal, mks);
    leg = W.file_prefix(mks,'Monkey', ' ');
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
        'ylabel', 'retraction coef vs entropy', ...
        'ylim', [-0.9 0.6], ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    plt.dashY(0, [-0.9 0.6]);
    plt.sigstar(time_md, pp*0 -0.9, pp);
    
    plt.ax(2,i);
    pas = reshape(subs.avCHOICE_byCONDITION',[],1);
    as = W.cellfun(@(x)x.mdfit.a, mdX, false);
    as = horzcat(as{:})';
    av =[]; se = [];
    for i = 1:size(as, 2)
        [av(:,i), se(:,i)] = W.bin_avY_byX(as(:,i), pas, [0 0.1 0.5 0.9 1]);
    end
    colra = plt.custom_vars.color_rejectaccept;
    tod = [1, 4, 2, 3];
    plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
        'legend',{'reject, certain', 'accept certain', 'reject, uncertain', 'accept, uncertain'}, ...
        'legloc', 'SE', ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av(tod,:), se(tod,:), 'line', 'color', [colra strcat(colra, '50')]);
    plt.dashY(0, [.2 1]);
end
plt.update('reviewer3_comment1');
