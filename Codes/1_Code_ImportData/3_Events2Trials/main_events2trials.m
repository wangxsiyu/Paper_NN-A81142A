[evs, files] = W.load('../../../Data/events_merged','csv');
files = arrayfun(@(x)replace(W.func('fileparts',2,x),'events','trials'), files);
%% set up savedir
trialdir = W.mkdir('../../../Data/trials');
%% codes
code_condition = {2121:2138, ... % define next condition
    1002, ... % start trial
    1001, ... % 500ms after bar touched
    1100, ... % Ask red on
    2201, ... % 500ms after red is on
    4001:4018, ... % condition
    2011:2013, ... % delay time
    2022:2:2026, ... % drop size
    1198, ... % ask CUE ON
    1400, ... % (unknown)
    1199, ... % this is to verify that CUE is ON (use 1198 as CUE ON)
    4001:4018, ... % condition
    1111, ... % unknown
    1039, ... % choice - reject
    1121, ... % PURPLE ON
    1141, ... % bar released on purple
    1123, ... % (potentially for feedback on)
    1022, ... % feedback off
    1400, ... % (unknown)
    1190, ... % all off
    1023, 1124, ... % drop #1-#6
    1024, 1124, ...
    1025, 1124, ...
    1026, 1124, ...
    1027, 1124, ...
    1028, 1124, ...
    1030, ... % trial accepted
    [1040 1041 1034 1035], ... % error codes
    1031, ... % 
    1032, ... %
    1400, ... %
    3199}; %
code_ignore = [10 8892 65424 0];
% 8892 - start
% 10 - end
% 65424 unknown
%% events to trials
isoverwrite = true;
for ei = 1:length(evs)
    W.print('events2trials: %d', ei);
    savename = W.enext(fullfile(trialdir, files(ei)),'csv');
    if ~exist(savename, 'file') || isoverwrite
        ev = evs{ei};
        usenext = [1124,1400];
        trials = W.events2trials(ev, code_condition, code_ignore, usenext);
        W.writetable(trials, savename);
    end
end