%% get files
mk = [];
mk{1} = W.dir('../../../RawFiles/VOLTAIRE/VOLTAIRE_RECORDING_FROM_RIPPLE/*.nev');
mk{2} = W.dir('../../../RawFiles/WALDO/WALDO_RECORDING_RIPPLE_FILES/*.nev');
mk = vertcat(mk{:});
%% group into sessions
outputdir = '../../../Data/events';
if ~exist(outputdir, 'dir')
    mkdir(outputdir);
end
[infullpaths, outname] = W.nev_filesbybox(mk.fullpath);
outname = lower(outname);
outname = replace(outname, 'waldo', 'W');
outname = replace(outname, 'voltaire', 'V');
%% change datetime format
tid = contains(outname, 'V');
outname(tid) = W.str_datetime(outname(tid), 'ddmmyyyy', 'yymmdd');
tid = contains(outname, 'W');
outname(tid) = W.str_datetime(outname(tid), 'ddmmyy', 'yymmdd');
outfullpaths = fullfile(outputdir, outname);
%% load behavior from .nev
W_import.import_events(infullpaths, outfullpaths, 'nev', false);


