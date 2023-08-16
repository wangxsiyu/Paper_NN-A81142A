function main_FIGURE_2_EL_bycue(plt, savename, EL, sub, timeslice, option)
    if plt.set_savename(savename)
        return;
    end
    %%
    FIG_Energy_landscape_by_cue(plt, EL, sub, timeslice, option);   
end