function wins = rps_winner(p1,p2)
% 1 -> p1 wins
% 2 -> p2 wins
% 0 -> tie

if p1 == p2
    wins = 0;
else
    if p1 == 1 % rock
       if p2 == 2 % rock vs paper
           wins = 2;
       else
           wins = 1; % rock vs scissors
       end
    end
    if p1 == 2 % paper
        if p2 == 1 % paper vs rock
            wins = 1;
        else
            wins = 2;
        end
    end
    if p1 == 3 % scissors
        if p2 == 1 % scissors vs rock
            wins = 2;
        else
            wins = 1;
        end
    end
end
        

end