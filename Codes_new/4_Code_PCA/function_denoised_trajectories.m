function trajs = function_denoised_trajectories(data)
    cond2av = data.games.choice*9+data.games.condition;
    trajs = W.neuro_meantrajectories_bycond(data.spikes, cond2av);
end