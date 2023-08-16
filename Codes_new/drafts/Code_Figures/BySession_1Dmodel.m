function BySession_1Dmodel(plt, md, sub)
    %%
    cols = {'gray', 'black'};
    tlt = W.str2cell(sub.filename);
    plt.figure(4,4, 'matrix_title', ones(4,4));
    % reject vs accept
    for si = 1:length(tlt)
        plt.ax(si);
        pas = sub.avCHOICE_byCONDITION(si,:)';
        as = md{si}.mdfit.a';
        av =[]; se = [];
        for i = 1:size(as, 2)
            [av(:,i), se(:,i)] = W.bin_avY_byX(as(:,i), abs(pas-0.5), [0 0.4 0.5]);
        end
        plt.setfig_ax('xlabel','time (ms)', 'ylabel', 'retraction coefficient',...
            'legend',{'uncertain', 'certain'}, ...
            'legloc', 'SW', ...
            'xtick', -1000:1000:2000, 'xticklabel', {'-1000','Cue On','1000','2000'});
        plt.plot(md{si}.time_md, av, se, 'line', 'color', cols);
        plt.dashY(0, [.2 1]);
    end
    
    plt.update('BySession - 1D dynamics A');
end