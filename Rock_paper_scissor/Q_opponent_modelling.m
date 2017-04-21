function Q_opponent_modelling

% Init
C = 0;
n = 0;
N = 10000;
alpha = 0.1;
Q = zeros(3,3,3); %state action ai_ans
C = zeros(3);
n = zeros(1,3);

r_mat = [0 1 -1;-1 0 1;1 -1 0];

action = randi(3);
ai_ans = rps_ai_alg(action,2,1);
state = action;
prev(1,1:2) = [action,ai_ans];
for ii = 1: N 
    
    % ...
    reward = r_mat(ai_ans,action);
    Q(state,action,ai_ans) = (1-alpha)* Q(state,action,ai_ans)+ ...
        alpha*(reward + 0 );
    C(state,ai_ans) = C(state,ai_ans) + 1;
    n(state) = n(state) + 1;
    
    % next action
    if ii < 1000
        action = randi(3);
    else
        for jj = 1:3
            cost(jj) =C(state,jj)/n(state) * Q(state,action,jj);
        end
        [~,action] = max(cost);
    end
    ai_ans = rps_ai_alg(action,4,1);
    state = action;
    prev(ii+1,1:3) = [action,ai_ans,reward];
end

Q
    
    