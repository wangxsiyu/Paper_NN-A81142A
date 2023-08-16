function main_FIGURE_1_EL_overtime(plt, savename, EL, x1D, sub)
    if plt.set_savename(savename)
        return;
    end

% plt.reload_paramdatabase();
% plt.param_scale(1,[],1,1.3);
    tx1D = W.cellfun(@(x)x.x1D, x1D);
    ttime_at = x1D{1}.time_at;
    tgames = W.cellfun(@(x)x.games, x1D);
    FIG_Energy_landscape_over_time(plt, tx1D, ...
        ttime_at, EL, tgames, sub.animal);
    
end