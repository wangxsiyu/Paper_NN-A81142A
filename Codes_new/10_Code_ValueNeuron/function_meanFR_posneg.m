function out = function_meanFR_posneg(anv, data)
    id = anv.time_at >= 0 & anv.time_at <= 1000;
    avFR = W.cellfun(@(x)mean(x(:, id), 2), data.spikes);
    avFR = horzcat(avFR{:});
    avFR = avFR * 1000 /data.time_window;
    cond = data.games.condition;
    [tav, tse] = W.analysis_av_bygroup(avFR, cond, 1:9);
    out.avFR = tav;
    out.steFR = tse;

    ppos = anv.perc_positive;

    out.avFR_byPosNeg = W.bin_avYs_byX(out.avFR', ppos, [0:0.1:1]);
    out.steFR_byPosNeg = W.bin_avYs_byX(out.steFR', ppos, [0:0.1:1]);
end

