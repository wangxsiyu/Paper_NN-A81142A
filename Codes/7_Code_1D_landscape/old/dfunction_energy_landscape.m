function [out] = function_energy_landscape(x1D, pos11D, nstep, option)
%     group_by_choice = W.strs_selectbetween2patterns(savename, '_', [], -1);
%     if ~exist('group_by_choice', 'var') || isempty(group_by_choice)
%         group_by_choice = "choice";
%     end
%     npool = W.strs_selectbetween2patterns(savename, '_npool', '_',1, -1);
%     npool = str2num(npool);
    nstep = data.time_window/unique(diff(data.time_at));
    games = data.games;
    time_at = x1D.time_at;
    x1D = x1D.x1D;
    if exist('savename', 'var') && exist(savename, 'file') && false
        return;
    end
    %% compute energy landscape by cue
    xbins = -5:.1:5;
    cond = games.condition;
    [EL_cue, x_EL, time_EL, conds_cue, grad_cue, ste_grad_cue] = W.neuro_EnergyLandscape(x1D, cond, xbins, npool, nstep, time_at);
    switch group_by_choice
        case 'choice'
            cc = games.choice;
            [EL_choice, x_EL, time_EL, conds_choice, grad_choice, ste_grad_choice] = W.neuro_EnergyLandscape(x1D, cc, xbins, npool, nstep, time_at);
            cccond = cc*9 + cond;
            [EL_choiceXcue, x_EL, time_EL, conds_choiceXcue, grad_choiceXcue, ste_grad_choiceXcue] = W.neuro_EnergyLandscape(x1D, cccond, xbins, npool, nstep, time_at);
        case 'position'
            tid = time_at >= 0 & time_at <= 1000;
            cc = (mean(x1D(:, tid),2) > 0)+ 0;
            W.print('%.2f', mean(cc == games.choice))
            [EL_choice, x_EL, time_EL, conds_choice, grad_choice, ste_grad_choice] = W.neuro_EnergyLandscape(x1D, cc, xbins, npool, nstep, time_at);
            cccond = cc + (cond -1)*2 + 1;
            [EL_choiceXcue, x_EL, time_EL, conds_choiceXcue, grad_choiceXcue, ste_grad_choiceXcue] = W.neuro_EnergyLandscape(x1D, cccond, xbins, npool, nstep, time_at);
        case 'soft'
            [EL_choice, x_EL, time_EL, conds_choice, grad_choice, ste_grad_choice] = W.neuro_EnergyLandscape(x1D, [], xbins, npool, nstep, time_at, pos1D.pos1D);
            [EL_choiceXcue, x_EL, time_EL, conds_choiceXcue, grad_choiceXcue, ste_grad_choiceXcue] = W.neuro_EnergyLandscape(x1D, cond, xbins, npool, nstep, time_at, pos1D.pos1D);    
        case 'softwin'
            tpos = pos1D.pos1D_bywin;
            tpos = repmat(tpos, 1, size(pos1D.pos1D, 2));
            [EL_choice, x_EL, time_EL, conds_choice, grad_choice, ste_grad_choice] = W.neuro_EnergyLandscape(x1D, [], xbins, npool, nstep, time_at, tpos);
            [EL_choiceXcue, x_EL, time_EL, conds_choiceXcue, grad_choiceXcue, ste_grad_choiceXcue] = W.neuro_EnergyLandscape(x1D, cond, xbins, npool, nstep, time_at, tpos);     
    end
    %% save
    out = W.struct('EL_cue', EL_cue, 'EL_choice', EL_choice, ...
            'EL_choiceXcue', EL_choiceXcue, 'x_EL', x_EL, 'time_EL', time_EL,...
            'conds_cue', conds_cue, 'conds_choice', conds_choice, ...
            'conds_choiceXcue', conds_choiceXcue, 'grad_cue', grad_cue, ...
            'grad_choice', grad_choice, 'grad_choiceXcue', grad_choiceXcue, ...
            'ste_grad_cue', ste_grad_cue, ...
            'ste_grad_choice', ste_grad_choice, 'ste_grad_choiceXcue', ste_grad_choiceXcue);
    if exist('savename', 'var')
        W.save(savename, 'EL', out);
    end
end