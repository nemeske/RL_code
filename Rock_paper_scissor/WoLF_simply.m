function WoLF(alpha,delta_l,delta_w,epsilon)
if nargin == 0
    alpha = 0.5;
    delta_l = 0.02;
    delta_w = 0.01;
    epsilon = 0.1;
end
%%%%%%%% BINARY WOLF
gamma = 0.2;
% Init

Q = zeros(3);
pol =ones(3,3)* 1/3; % the probalility of choosing something (policy)
C = zeros(1,3); % observing the enemy
N = 10000; % Number of runs
r_mat = [0 1 -1;-1 0 1;1 -1 0];

action = randi(3);
ai_ans = rps_ai_alg(action,2,1);
state = action;
prev(1,1:2) = [action,ai_ans];
% Loop
for jj = 1:N
    % ...
    % next_state = action;
    if jj < 10
        next_action = randi(3);
    else
        if rand() < epsilon 
        % eps (exploration rate)
            next_action = randi(3);
        else
            [~,next_action] = max(pol(state,:));
        end
    end
    reward = r_mat(ai_ans,action);
    %disc = gamma*max(Q(action,:)); % not so short sighted
    disc = 0;
    Q(state,action) = (1-alpha)* Q(state,action)+ ...
                    alpha*(reward +  disc); % abolutely short sighted
    C(state) = C(state) + 1;
    if reward == 1
        Delta = delta_w;
    else
        Delta = delta_l;
    end
    [~, max_a] = max(Q(state,:));
    if action == max_a
        DD = Delta;
    else
        DD = -Delta/2;
    end
    pol(state,action) = pol(state,action)+DD;
    
    state = action;
    ai_ans = rps_ai_alg(action,3,1);
    action = next_action;
    
    prev(jj+1,1:3) = [action,ai_ans,r_mat(ai_ans,action)];
    
end
Q;
        
    
    