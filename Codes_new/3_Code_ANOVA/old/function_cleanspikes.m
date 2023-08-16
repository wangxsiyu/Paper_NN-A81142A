function data = function_cleanspikes(varargin)
    savenames = varargin{end};
    savenames = W.string(savenames);
    [data, spikes_cleaning_info] = W.clean_spikes(varargin{1:end-1});
    W.save(savenames(1), 'data', data);
    W.save(savenames(2), 'spikes_cleaning_info', spikes_cleaning_info);
end