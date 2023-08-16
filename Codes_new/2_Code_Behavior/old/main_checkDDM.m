tab = W.readtable('./fit_ddm.csv');
tab2 = W.readtable('./fit_ddm_collapsingbound.csv');
%%
ddr = NaN(16,9);
ddr2 = NaN(16,9);
for i = 1:size(tab,1)
    ddr(tab.sessionID(i)+1, tab.condition(i)+1) = tab.drift(i);
    ddr2(tab2.sessionID(i)+1, tab2.condition(i)+1) = tab2.drift(i);
end
%%
save('./ddm_formatted', 'ddr','ddr2');
%%
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
dr = subs.avDRIFTRATE_byCONDITION;
%%
plt = W_plt;
plt.figure(2,2);
tids = {1:8,9:16};
for i = 1:2
    tid = tids{i};
    plt.ax(1,i);
    str = plt.scatter(reshape(ddr(tid,:),[],1), reshape(dr(tid,:), [], 1), 'corr');
    plt.setfig_ax('legend', str, 'xlabel', 'drift rate (original)', 'ylabel', 'drift rate (fitted)');

    plt.ax(2,i);
    str = plt.scatter(reshape(ddr2(tid,:),[],1), reshape(dr(tid,:), [], 1), 'corr');
    plt.setfig_ax('legend', str, 'xlabel', 'drift rate (original)', 'ylabel', 'drift rate (fitted)');
end
plt.update;