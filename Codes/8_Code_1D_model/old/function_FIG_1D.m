function function_FIG_1D(md1, sub, plt, ver, ispartial, savename)
time_md = md1(1).time_md;
md1 = W.arrayfun(@(x)x.mdfit, md1, false);
%%
sub = struct2table(sub);
FIGURE_1D_model(plt, md1, sub, time_md, ver, ispartial, savename);
end