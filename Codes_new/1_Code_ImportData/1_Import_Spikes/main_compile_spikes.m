spikedir = '../../../Spikes/SpikesSorted/**';
[spikedir] = W.dir(spikedir,'dir');
spikedir = spikedir(contains(lower(spikedir.filename), {'voltaire_','waldo_'}),:);
infullpath = W.mksort_filesbybox(spikedir.fullpath);
%%
outputdir = '../../../Data/spikes';
if ~exist(outputdir, 'dir')
    mkdir(outputdir);
end
idx = contains(lower(spikedir.filename), 'wang') | contains(lower(spikedir.filename), 'yi');
outname = arrayfun(@(x)strcat(W.str_selectbetween2patterns(spikedir.filename(x),[],'_',[],2),...
    '_',  W.iif(idx(x), 'Wsorted', 'unsorted'),'.mat'), 1:length(idx));
outname = replace(outname, 'Waldo', 'W');
outname = replace(outname, 'Voltaire', 'V');
outfullpath = fullfile(outputdir, outname);
%%
W_import.import_spikes(infullpath, outfullpath, 'mksort', false);