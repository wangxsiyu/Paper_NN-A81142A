% vers = W.dir('../Temp', 'folder');
% vers = vers(arrayfun(@(x)sum(char(x)=='_'), vers.filename) == 3,:);
% isoverwrite = true;
% iscontinuebeyondanova = true;
% versioni = 2;
% versionname = vers.filename(versioni);
% ses = W.dir(vers.fullpath(versioni), 'folder');
% %% load sub
% files = W.ls(vers.fullpath(versioni), 'file');
% files = files(contains(files, 'sub'));
% subs = W.load(files);
% %%
% aa= cell(1,length(ses.filename));
% dec0= cell(1,length(ses.filename));
% dec= cell(1,length(ses.filename));
% for si = 1:length(ses.filename)
%     sessionname = ses.filename(si);
%     sub = subs(strcmp(subs.filename, sessionname),:);
%     dataname = sprintf('dataset_%s.mat', sessionname);
%     data0 = W.load(fullfile(ses.fullpath(si), dataname));
%     %%
%     savename = fullfile(ses.fullpath(si), sprintf('anova_%s.mat', sessionname));
%     [wv_anova] = main_ANOVA(data0, savename, false);
%     %%
%     thres_fr = [0, 1];
%     str_excludeversion = {'','ex_fr1'};
%     excludeversioni = 1;
%     savedir_current = fullfile(W.file_suffix(ses.filepath(si), str_excludeversion{excludeversioni}), ...
%         ses.filename(si));
%     [data, spikes_cleaning_info] = W.clean_spikes(data0, thres_fr(excludeversioni), 0.2, 0.05, wv_anova);
%     %%
%     ver_pcs = {'t0t1000','q5q95'};
%     pci = 1;
%     %%
%     savename = fullfile(savedir_current, sprintf('pc20_%s_%s.mat', ver_pcs{pci}, sessionname));
%     wv_pc = W.load(savename);
%     %%
%     ver_1Dproj = {'svm','mean'};
%     proji = 1;
%     %%
%     savename = fullfile(savedir_current, sprintf('x1D%s_%s_%s.mat', ver_1Dproj{proji}, ver_pcs{pci}, sessionname));
%     [x3D, tpc] = main_1D_projection_with2PCA(wv_pc, data.games, ver_1Dproj{proji}, savename);
%     %%
    dec0{si} = decodetemp(wv_pc.pc, data.games);
    dec{si} = decodetemp(tpc, data.games);
    dec1{si} = decodetemp(W.arrayfun(@(x) wv_pc.pc{x} - tpc{x}, 1:61, false), data.games);
%     %%
%     npool = 3;
%     nstep = data.time_window/unique(diff(data.time_at));
%     W.print('time window = %d, nstep = %d', data.time_window, nstep);
%   %%
%    [aa{si},time_md] = draft_main_multiD_model(x3D, data, npool, nstep);
% end
%%
animal = subs.animal;
plt.figure(1,2);
    plt.new;
    ac_svm = W.cellfun(@(x)x.ac_choice, dec0, false);
    ac_svm = vertcat(ac_svm{:});
    ac_svm1 = W.cellfun(@(x)x.ac_choice, dec, false);
    ac_svm1 = vertcat(ac_svm1{:});
    ac_svm2 = W.cellfun(@(x)x.ac_choice, dec1, false);
    ac_svm2 = vertcat(ac_svm2{:});
    mks = unique(animal);
    [av, se] = W.analysis_av_bygroup(ac_svm, animal, mks);
    [av1, se1] = W.analysis_av_bygroup(ac_svm1, animal, mks);
    [av2, se2] = W.analysis_av_bygroup(ac_svm2, animal, mks);
    for i = 1:2
        plt.ax(i);
    plt.setfig_ax('xlabel', 'time (ms)', 'ylabel', 'decoding accuracy', ...
        'legloc', 'SE', 'legend', {'tot','res','1D'}, ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
  
    plt.plot(data.time_at, [av(i,:);av1(i,:);av2(i,:)], [se(i,:);se1(i,:);se2(i,:)], 'line', 'color', plt.custom_vars.color_monkeys);
    plt.dashY(0);
    end
    plt.update;
% %% compute eig
% zeig = cell(3,length(ses.filename));
% for si = 1:length(aa)
%     teig = W.cellfun(@(x)eig(x-eye(3)), aa{si}, false);
%     for di = 1:3
%         zeig{di,si} =cellfun(@(x)x(di), teig);
%     end
% end

%%
figdir = W.mkdir('../Figures/Reviewer1');
plt = W_plt('savedir', figdir, ...
    'issave', true, 'extension', {'svg','jpg'}, ...
    'isshow', true);
plt.set_custom_variables('color_monkeys', {'AZred', 'AZblue'}, ...
    'color_rejectaccept', {'RSgreen', 'RSred'}, ...
    'color_anova', {'RSred','AZcactus','AZsand','AZsky'});
%% Figure corr
plt.figure(2,3,'is_title', 1);
for i = 1:3
    mdX = zeig(i,:);
    cols = plt.custom_vars.color_monkeys;

    plt.ax(1,i);
    corAE = W.arrayfun(@(x)corr(mdX{x}',W.vert(subs.ENTROPY_byCONDITION(x,:))), ...
        1:size(subs,1), false);
    corAE = horzcat(corAE{:})'; 
    [~,pp] = ttest(corAE);
    mks = ["V","W"];
    [av, se] = W.analysis_av_bygroup(corAE, subs.animal, mks);
    leg = W.file_prefix(mks,'Monkey', ' ');
    plt.setfig_ax('legend', leg, 'xlabel', 'time (ms)', ...
        'ylabel', 'retraction coef vs entropy', ...
        'ylim', [-0.9 0.9], ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av, se, 'line', 'color', cols);
    plt.dashY(0, [-0.9 0.6]);
    plt.sigstar(time_md, pp*0 -0.9, pp);
    
    plt.ax(2,i);
    pas = reshape(subs.avCHOICE_byCONDITION',[],1);
    as = W.cellfun(@(x)x, mdX, false);
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
%% symmetry
symm = cell(3,length(ses.filename));
for si = 1:length(aa)
    tsym = W.cellfun(@(x)[x(1,2)-x(2,1), x(1,3)-x(3,1), x(2,3)-x(3,2)], aa{si}, false);
    for di = 1:3
        symm{di,si} =cellfun(@(x)x(di), teig);
    end
end
%% 
plt.figure(2,3,'is_title', 1);
for i = 1:3
    mdX = symm(i,:);
    cols = plt.custom_vars.color_monkeys;

    plt.ax(1,i);
    corAE = W.arrayfun(@(x)corr(mdX{x}',W.vert(subs.ENTROPY_byCONDITION(x,:))), ...
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
    as = W.cellfun(@(x)x, mdX, false);
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
    plt.dashY(0, [.2 .2]);
end
%%


