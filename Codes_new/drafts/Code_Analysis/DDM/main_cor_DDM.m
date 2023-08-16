vers = W.dir('../../Temp', 'folder');
vers = vers(arrayfun(@(x)sum(char(x)=='_'), vers.filename) == 3,:);
versioni = 2; % use all 50/50
isoverwrite = true;
versionname = vers.filename(versioni);
ses = W.dir(vers.fullpath(versioni), 'folder');
files = W.ls(vers.fullpath(versioni), 'file');
files = files(contains(files, 'sub'));
subs = W.load(files);
%%
ddm = importdata('./ddm_formatted.mat');
%%
nsession = length(ses.filename);
saveout = cell(nsession,3);
for si = 1:nsession
    sessionname = ses.filename(si);
    sub = subs(strcmp(subs.filename, sessionname),:);
    dataname = sprintf('dataset_%s.mat', sessionname);
    data = W.load(fullfile(ses.fullpath(si), dataname));
    savedir_current = fullfile(ses.filepath(si), ...
                        ses.filename(si));
    %%
    savename = fullfile(savedir_current, sprintf('x1D%s_%s_%s.mat', 'SVM', 't0t1000', sessionname));
    x1D = importdata(savename);
    ver_1Dmodel = {'scaledEV', 'residue'};
    mdi = 1;
    npool = 3;
    nstep = data.time_window/unique(diff(data.time_at));
    tsub = sub;
    evs = {sub.avDRIFTRATE_byCONDITION, ddm.ddr(si,:), ddm.ddr2(si,:)}
    for evi = 1:2
        saveout{si, evi} = struct;
        tsub.avDRIFTRATE_byCONDITION = evs{evi};
        mdfit = main_1D_model(x1D, data.games, tsub, npool, nstep, ver_1Dmodel{mdi});
        saveout{si, evi}.mdfit = mdfit;
    end
end
%%
W.save('../../Temp/review2_comment2.mat', 'all', saveout);
%%
all = importdata('../../Temp/review2_comment2.mat');

figdir = W.mkdir('../Figures/Reviewer3');
plt = W_plt('savedir', figdir, ...
    'issave', true, 'extension', {'svg','jpg'}, ...
    'isshow', true);
plt.set_custom_variables('color_monkeys', {'AZred', 'AZblue'}, ...
    'color_rejectaccept', {'RSgreen', 'RSred'}, ...
    'color_anova', {'RSred','AZcactus','AZsand','AZsky'});
%%
time_md = all{1}.mdfit.time_md;
plt.figure(2,3,'is_title', 1);
tlt = {'Only positive neurons', 'Only negative neurons', 'Mixsure'};
for i = 1:2
    mdX = W.cellfun(@(x)x.mdfit, all(:,i), false);
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

