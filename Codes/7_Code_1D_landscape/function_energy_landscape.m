function [out] = function_energy_landscape(x1D, pos1D, npool, winsize, option)
    nstep = winsize/unique(diff(x1D.time_at));
    npool = W.str_select(npool);    
    games = x1D.games;
    time_at = x1D.time_at;
    x1D = x1D.x1D;
    %% compute energy landscape by cue
    xbins = -5:.1:5;
    cond = games.condition;
    out = [];
    out.EL_cue = W.neuro_EnergyLandscape_1D_defaultformat(x1D, cond, xbins, npool, nstep, time_at);
    
    switch option
        case 'choice'
            cc = games.choice;
            out.EL_choice = W.neuro_EnergyLandscape_1D_defaultformat(x1D, [], xbins, npool, nstep, time_at, cc);
            out.EL_choiceXcue = W.neuro_EnergyLandscape_1D_defaultformat(x1D, cond, xbins, npool, nstep, time_at, cc);
        case 'position'
            tid = time_at >= 0 & time_at <= 1000;
            cc = (mean(x1D(:, tid),2) > 0)+ 0;
            out.EL_choice = W.neuro_EnergyLandscape_1D_defaultformat(x1D, [], xbins, npool, nstep, time_at, cc);
            out.EL_choiceXcue = W.neuro_EnergyLandscape_1D_defaultformat(x1D, cond, xbins, npool, nstep, time_at, cc);
        case 'soft'
            out.EL_choice = W.neuro_EnergyLandscape_1D_defaultformat(x1D, [], xbins, npool, nstep, time_at, pos1D.pos1D);
            out.EL_choiceXcue = W.neuro_EnergyLandscape_1D_defaultformat(x1D, cond, xbins, npool, nstep, time_at, pos1D.pos1D);    
        case 'softwin'
            tpos = repmat(pos1D.pos1D_bywin, 1, size(pos1D.pos1D, 2));
            out.EL_choice = W.neuro_EnergyLandscape_1D_defaultformat(x1D, [], xbins, npool, nstep, time_at, tpos);
            out.EL_choiceXcue = W.neuro_EnergyLandscape_1D_defaultformat(x1D, cond, xbins, npool, nstep, time_at, tpos);     
    end
end