function plt = figax_1Dmodel(plt, mdX, sub, axIDs,time_md)
    % fig - x0
    plt.ax(axIDs(1));
    plt = fig_ax_x0(plt, mdX, sub,time_md);

    % fig - evidence
    plt.ax(axIDs(2));
    plt = fig_ax_EV(plt, mdX, sub,time_md);

    % reject vs accept
    plt.ax(axIDs(3));
    plt = fig_ax_accept_reject(plt, mdX, sub,time_md);

    % correlation between a and entropy
    plt.ax(axIDs(4));
    plt = fig_ax_A(plt, mdX, sub,time_md);

    % fig - scatter
    plt = fig_ax_Acor(plt, mdX, sub, axIDs(5:6),time_md);
end