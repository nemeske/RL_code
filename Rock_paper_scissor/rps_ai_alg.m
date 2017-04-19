function ai_sel = rps_ai_alg(player_sel,alg,isai)
if nargin == 2
    isai == 0;
end
%%% Alogritms %%%
% 1 -> Random
% 2 -> Most likely
% 3 -> Last winner
% 4 -> Extra

% Random: generates a random integer in 1-3

% Most likely: tracks the last n choice of the player and plays the 
%counter of the most likely

% Last winner: the ai plays the cunter of the player's last move

% Extra: To be defiened

persistent player_arr % the array of player moves
player_arr = [player_arr player_sel]; % Short term

% Extra long term: only if a human is playing
if isai == 0
    if mod(length(player_arr),10) == 0 && length(player_arr) ~= 0
        % we save a batch of 10 entry
        if exist('player_arr_longterm.mat', 'file') == 2
            % If the file exsits load, if not create one
            load('player_arr_longterm');
        else
            player_arr_longterm = [];
        end
        player_arr_longterm = [player_arr_longterm player_arr(length(player_arr)-9:end)];
        save('player_arr_longterm','player_arr_longterm');
    end
end    
% Main switch

switch alg
    case 1 
        % Random
        persistent ai_arr 
        ai_sel = randi(3);
        ai_arr = [ai_arr ai_sel];
    case 2
        % Most likely saves the player's last steps from the last n steps
        n = 5; % the optimal choice is an odd number 
        if length(player_arr) < n + 1
            ai_sel = randi(3); % use the default rng
        else
            player_freq = mode(player_arr(end-n:end-1));
            % If the frequency of two selection are the same, the smaller
            % will be chosen
            ai_sel = beats(player_freq);               
        end            
    case 3
        % The answer to the last player move
        if length(player_arr) == 1
            ai_sel = randi(3);
        else
            ai_sel = beats(player_arr(end-1)); 
        end
            
end


end



