function graWoLF

% Parameters
alpha = 0.1;
delta_l = 0.2;
delta_w = 0.1;
epsilon = 0.1;
beta = 0.2;
w = 0;
theta = zeros(3);
theta_h = zeros(3);
e = 0;
gamma = 0.2;

N = 10000;
r_mat = [0 1 -1;-1 0 1;1 -1 0];
action = randi(3);
ai_ans = rps_ai_alg(action,3,1);
state = action;
prev(1,1:2) = [action,ai_ans];
t = 0;
phi_sa = theta;

% Init
pol =ones(3,3)* 1/3;
Q_w = zeros(3);
f_w = zeros(3);

for jj = 1:N
    pol = exp(theta_h*phi_sa)/
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
    
    e = gamma^t*e + phi_sa;
    w = w + alpha*(reward + gamma*Q_(action,next_action) - Q_w(state,action));
    theta = theta + gamma*delta
    
        
        
    t = t+0.1;    
end