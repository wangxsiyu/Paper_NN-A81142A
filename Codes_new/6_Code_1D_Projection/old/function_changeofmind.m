function sub = function_changeofmind(x1D, sub)
    games = x1D.games;
    x = x1D.x1D;
    sgnx = sign(x);

    ischange = [NaN(size(x,1),1) diff(sgnx')' ~= 0];
    idxwin = x1D.time_at >= 0 & x1D.time_at <= 1000;

    countchange = sum(ischange(:, idxwin),2);
    sub.n_changemind = W.analysis_av_bygroup(countchange, games.condition);
end