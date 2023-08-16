function plt = fig_avcer_var(plt, mdX, sub, time_md)
    cols = plt.custom_vars.color_monkeys;
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
%     time_md = mdX{1}.time_md;

    pas = reshape(sub.avCHOICE_byCONDITION',[],1);
    as = W.cellfun(@(x)x.error_bycond', mdX, false);
    as = horzcat(as{:})';
    av =[]; se = [];
    for i = 1:size(as, 2)
        [av(:,i), se(:,i)] = W.bin_avY_byX(as(:,i), pas, [0 0.1 0.5 0.9 1]);
    end
    colra = plt.custom_vars.color_rejectaccept;
    tod = [1, 4, 2, 3];
    plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
        'legend',{'reject, certain', 'accept certain', 'reject, uncertain', 'accept, uncertain'}, ...
        'legloc', 'SW', ...
        'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
    plt.plot(time_md, av(tod,:), se(tod,:), 'line', 'color', [colra strcat(colra, '50')]);
    plt.dashY(0, [.2 1]);
end