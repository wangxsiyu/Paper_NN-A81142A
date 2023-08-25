[trials, files] = W.load('../../../Data/trials','csv');
files = replace(W.basenames(files),'trials','games');
%%
gamedir = W.mkdir('../../../Data/games');
%%
for fi = 1:length(files)
    savename = fullfile(gamedir, files(fi));
    W.print('trial2game: %s', savename);
    game = preprocess_WV(trials{fi});
    game = W.tab_fill(game, 'filename', W.file_deprefix(files(fi)));
    W.writetable(game, savename);
end