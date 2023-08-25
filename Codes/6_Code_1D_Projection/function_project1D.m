function x1D = function_project1D(pc, varargin)
    pc.games.rt = pc.games.rt_reject;
    x1D = W.neuro_project1D_defaultformat(pc, 20, 'choice', varargin{:}, 1);
end