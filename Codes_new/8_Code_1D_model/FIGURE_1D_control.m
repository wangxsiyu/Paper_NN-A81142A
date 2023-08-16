function FIGURE_1D_control(plt, savename, sub, d)
if plt.set_savename(savename)
    return;
end
%%
plt.figure;
mdX = W.cellfun(@(x)x.mdfit, d);
time_md = d{1}.time_md;
cols = plt.custom_vars.color_monkeys;
mks = unique(sub.animal);
leg = W.file_prefix(mks,'Monkey', ' ');
av =[]; se = [];
for i = 1:2
    as = W.arrayfun(@(x)x.a(:,i), mdX, false);
    aa{i} = horzcat(as{:})';
    [av(i,:), se(i,:)] = W.avse(aa{i});
end

[~,pp] = ttest(aa{2}-aa{1});

colra = plt.custom_vars.color_rejectaccept;
tod = [1, 4, 2, 3];
plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
    'legend',{'most inconsistent cue', 'matched consistent cues'}, ...
    'legloc', 'SE', ...
    'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
plt.plot(time_md, av, se, 'line', 'color', {'gray', 'black'});
plt.dashY(0, [.2 1]);
plt.sigstar(time_md, pp*0 +0.94, pp);
W.print('sig T (A0): %.2f', min(time_md(pp < 0.05 & time_md > 0)));
plt.update;