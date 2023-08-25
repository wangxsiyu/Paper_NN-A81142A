function out = function_1D_calcpos(x1D, data, winname, savename)
    c = data.games.choice;
    x = x1D.x1D;
    for i = 1:size(x,2)
        [out.pos1D(:, i)] = calc_posterior(x(:,i), c);
    end
    if strcmp(W.select(char(winname),1), 't')
        [twin] = W.strs_select(winname);
        tid = x1D.time_at >= twin(1) & x1D.time_at <= twin(2);
        tx = x(:, tid);
        tx = mean(tx, 2);
        out.pos1D_bywin = calc_posterior(tx, c);
        out.pos1D_t = twin;
    end
    W.save(savename, 'pos1D', out);
end
function pos = calc_posterior(x, c)
    [m1,s1] = normfit(x(c == 1));
    [m2,s2] = normfit(x(c == 0));
    p1 = normpdf(x, m1, s1);
    p2 = normpdf(x, m2, s2);
    prior1 = mean(c == 1);
    prior2 = 1 - prior1;
    pos = p1 * prior1./(p1* prior1 + p2 * prior2);
end