function WoLF(alpha,delta_l,delta_w,epsilon)
if nargin == 0
    alpha = 0.5;
    delta_l = 0.02;
    delta_w = 0.01;
    epsilon = 0.1;
end

gamma = 0.2;
% Init

Q = zeros(3);
pol =ones(3,3)* 1/3; % the probalility of choosing something (policy)
C = zeros(1,3); % observing the enemy
N = 10000; % Number of runs
pol_h = pol;

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
    
    for ii = 1:3
        pol_h(state,ii) = pol_h(state,ii) + 1/C(state)*(pol(state,ii)-pol_h(state,ii));
    end
    % pol_h(state,action) = pol_h(state,action) + 1/C(state)*(pol(state,action)-pol_h(state,action));

    P1 = 0;
    P2 = 0;
    for ii = 1:3
        P1 = P1 + pol(state,ii)*Q(state,ii);
        P2 = P2 + pol_h(state,ii)*Q(state,ii);
    end
    if P1>=P2
        Delta = delta_w;
    else
        Delta = delta_l;
    end
    pol(state,action) = pol(state,action)+Delta;
    
    state = action;
    action = next_action;
    ai_ans = rps_ai_alg(action,3,1);
    
    prev(jj+1,1:3) = [action,ai_ans,r_mat(ai_ans,action)];
    
end
Q;
% Megjegyzés: A Q-t jól becsüli, vagyis rájön az ellenfél lépéseire, pl
% elég sok futás után Q(1,1)=Q(2,2)=Q(3,3) = -1
        
    
    