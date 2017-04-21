function active_LZ(alpha,gamma)
% This is the acitve LZ algorithm implemented in Matlab. The algorithm is
% designed by Vivek F. Farias
% See more: http://web.mit.edu/vivekf/www/papers/ul-jrnl.pdf

% INPUT: alpha: discount factor, gamma: exploration probabilites

% init
alpha = 0.1;
c = 1; %  the index of the current phrase
tau_c = 1; % start time of the cth phrase
N = zeros(3);% contex count
P_h = ones(3)*1/3; % P_hat: estimated trasition probabiliteis
J_h = zeros(3); % estimated cost-to-go
g_mat = [0 1 -1;-1 0 1;1 -1 0];
t = 1;
move = randi(3);
A(t) = move;
X(t+1) = rps_ai_alg(A(t),3);
for t = 2:10000
    if t == 2
        A(t) = randi(3);
    end
    X(t) = rps_ai_alg(A(t),3);
    g = g_mat(X(t),A(t));
    if N(X(t),A(t)) > 0 % context seen
        if rand <= gamma
            A(t+1) = randi(3);
        else
            % TODO ELSE ÁG
            [k,~] = size(P_h)
            for jj = 1:k
            	temp(jj,:) = P_h(X(t-2),A(t))*g+alpha*J_h(X(t-1),A(t)); 
            end
            minMatrix = min(temp(:)); % finding the index of the smallest element
            [~,A(t+1)] = find(temp==minMatrix);
        end
    else
        A(t+1) = randi(3);
        for s =tau_c:t
            N(X(s),A(s-1)) = N(X(s),A(s+1)) + 1; % updating context
            P_h((s-1),A(s-1)) = (N(X(s-1),A(s-1)) +0.5 )/(sum(N(:,A(s-1))) + 3/2);
            
            tempP = sum(P_h(X(s),A(s-1))*g+alpha*J_h(:,A(s-1)));
            tempP = min(temP
            J_h(X(s-1),A(s))= tempP;
        end
        c = c + 1;
        tau_c = t+1;
    end
end
            
            
