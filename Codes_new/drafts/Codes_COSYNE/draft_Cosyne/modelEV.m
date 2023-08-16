function pred = modelEV(a, x0, b, x, ev, dummy_cond, dummy_c, option)
    if option == "full"
        ta = dummy_cond * a';
        tx0 = dummy_c * x0';
        pred = x + b * ev + ta .* tx0 - ta .* x;
    elseif option == "diff"
        pred = x;
    elseif option == "drift"
        pred = x + b * ev;
    elseif option == "diffav"
        tecond = dummy_cond;
        tecond(tecond==0) = NaN;
        xav = nanmean( tecond.* repmat(x, 1,9));
        pred = dummy_cond * xav';
    elseif option == "driftav"
        tecond = dummy_cond;
        tecond(tecond==0) = NaN;
        xav = nanmean( tecond.* repmat(x, 1,9));
        pred = dummy_cond * xav' + b*ev;
    elseif option == "drift9"
        pred = x + dummy_cond * b';
    end
end