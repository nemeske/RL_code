function graWoLF2

% Parameters
alpha = 0.1;
delta_l = 0.2;
delta_w = 0.1;
epsilon = 0.1;
beta = 0.2;
w = zeros(3,3,2);
theta = zeros(3,1);
e = zeros(3,3,2);
gamma = 0.2;

N = 10000;
r_mat = [0 1 -1;-1 0 1;1 -1 0];
action = randi(3);
ai_ans = rps_ai_alg(action,3,1);
state = action;
prev(1,1:2) = [action,ai_ans];
t = 0;
phi = [1 1 1;2 2 2;3 3 3];

% Init
pol = zeros(3);
Q = zeros(3);
f_w = zeros(3);

for t = 0:N-1
    % ----------------------------------- Policy Upgrade
    for ii = 1:3 
       for jj = 1:3
           pol(ii,jj) = exp(theta(1).*phi(ii,jj,1)+theta(2).*phi(ii,jj,2))/...
               (exp(theta(1).*phi(ii,1,1)+theta(2).*phi(ii,1,2)) + ...
               exp(theta(1).*phi(ii,2,1)+theta(2).*phi(ii,2,2)) + ...
               exp(theta(1).*phi(ii,3,1)+theta(2).*phi(ii,2,2)));
       end
    end
    % ------------------------------------ Q upgrade
    for ii = 1:3
        for jj = 1:3
            Q(ii,jj) = w(ii,jj,1).*phi(ii,jj,1)+w(ii,jj,2).*phi(ii,jj,2);
        end
    end
    % ------------------------------------ f_w upgrade
    for ii = 1:3
        for jj = 1:3
            f_w(ii,jj) = Q(ii,jj) -  w(ii,jj,1).*phi(ii,jj,1)+w(ii,jj,2).*phi(ii,jj,2);
        end
    end
    
    % ----------------------------------- Next action
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
    
    e = gamma^t*e + phi;
    w(state,action,1) = w(state,action,1)  + alpha*(reward + gamma*Q(action,next_action) - Q(state,action));
    w(state,action,2) = w(state,action,2)  + alpha*(reward + gamma*Q(action,next_action) - Q(state,action));
    
    if reward == 1
        Delta = delta_w;
    else
        Delta = delta_l;
    end
    
    theta(1) = theta(1) + gamma^t*Delta * e(state,action,1) * pol(state,action)*Q(state,action);
    theta(2) = theta(2) + gamma^t*Delta * e(state,action,2) * pol(state,action)*Q(state,action); 
    
    state = action;
    ai_ans = rps_ai_alg(action,3,1);
    action = next_action;
    
    prev(t+1,1:3) = [action,ai_ans,r_mat(ai_ans,action)];
end
pol