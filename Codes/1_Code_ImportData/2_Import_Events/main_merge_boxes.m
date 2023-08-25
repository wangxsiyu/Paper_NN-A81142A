%% load session names
ses = W.dir('../../../Data/spikes','.mat');
ses = W.strs_selectbetween2patterns(ses.filename, '_', '_', 1, 3);
%% select files
eventdir = '../../../Data/events';
files = W.dir(eventdir);
tid = contains(files.filename, ses);
files = files(tid,:);
files = files.fullpath;
%%
eventdir_merged = W.mkdir('../../../Data/events_merged');
W.merges_box_pair(files, eventdir_merged);