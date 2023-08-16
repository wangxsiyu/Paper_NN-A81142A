function plt = FIGax_Acor(plt, mdX, sub, axIDs, time_md)
    if ~exist('axIDs', 'var')
        axIDs = [1,2];
    end
    cols = plt.custom_vars.color_monkeys;
    mks = unique(sub.animal);
    leg = W.file_prefix(mks,'Monkey', ' ');
%     time_md = mdX{1}.time_md;

    xs = {[],[]};
    ys = cell(1,2);
    for i = 1:length(mks)
        ys{i} = reshape(sub.ENTROPY_byCONDITION(sub.animal == mks(i),:)',[],1);
    end
    id_animal = W.str_getID(sub.animal, mks);
    for si = 1:size(sub,1)
        time_median = sub.avRT_REJECT(si) * 1000;
        idxt = dsearchn(time_md', time_median);
        tx = [mean(mdX{si}.a(idxt + [-1:1],:))]';
        xs{id_animal(si)} = [xs{id_animal(si)};tx];
    end
    plt.ax(axIDs(1));
    plt.setfig_ax('xlabel', 'retraction coef', 'ylabel', 'entropy', 'title', 'Monkey V');
    st1 = plt.scatter(xs{1}, ys{1}, 'corr', 'color', cols{1});
    plt.ax(axIDs(2));
    plt.setfig_ax('xlabel', 'retraction coef', 'ylabel', 'entropy', 'title', 'Monkey W');
    st2 = plt.scatter(xs{2}, ys{2}, 'corr', 'color', cols{2});
    W.print(st1)
    W.print(st2)
end