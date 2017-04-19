function wins = beats(sel)
% The function decides what will beat the given selection
% A jump table
switch sel
    case 1 % rock
        wins = 2; % paper
    case 2 % paper
        wins = 3; %scissors
    case 3 % scissors
        wins = 1;
end

end