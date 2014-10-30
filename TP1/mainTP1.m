%% Problem setting 

M = 15; % taille du stock
K = 0.8; % frais de livraison
c = 0.5; % prix d'achat
h = 0.3; % co?t d'entretien
pr = 1; % prix de vente
gamma = 0.98; % calcul� � partir du taux d'inflation

p = 0.1; % param�tre de la loi g�om�trique
D=zeros(1,M+1); % vecteur de la loi g�om�trique (tronqu�e)
D(1+(0:(M-1)))=p*(1-p).^(0:(M-1));
D(M+1)=1-sum(D);

x0=M; % stock initial

%% Visualisation d'une trajectoire

pi=2*ones(1,M+1);%exemple de politique
n=1000;

[X,R] = trajectory(n,x0,pi,D,M,K,h,c,pr);
plot(cumsum(gamma.^((1:n)-1).*R))



% Estimation du la r�compense cumul�e discount�e

    

%% Calcul des param�tres du MDP

[P,R]=MDP(D,M,K,h,c,pr);

[newP, newR] = policy_matrices(P, R, pi); %I don't think this line is useful
V0 = ((1:16) - ones(1,16))';
pol_eval_1(pi, P, R, gamma)
pol_eval_2(500,n,V0,pi,D,M,K,h,c,pr,gamma)
pol_eval_3(pi, P, R, gamma, 600)

%% Value iteration

nb_it=100;
V0=zeros(M+1,1);

tic
[V, pol]=VI(P,R,gamma,nb_it);
toc


%% Policy iteration 
%which one is the fastest ?
tic
[V, pol]=PI(P,R, gamma, nb_it);
%note that 500 iterations are used for policy evaluation (arbitrary)
toc

tic
[V, pol]=PIbis(P,R, gamma, nb_it);
toc
%much faster using PIbis !
%and PIbis faster than VI for the same number of iterations


[V_PI, pi_PI] = PIbis(P,R, gamma, 500)
[V_VI, pi_VI] = VI(P, R, gamma, 500)

K= 50;
errVI = zeros(1, K);
errPI = zeros(1, K);

for iter = 1:K
    [V_value, piV] = VI(P, R, gamma, iter); %probable Schlemiel, starting from 0 again each time
    errVI(iter) = max(abs(V_value-V_VI));
    [V_policy, piP] = PIbis(P,R, gamma, iter);
    errPI(iter) = max(abs(V_policy - V_PI));
end

plot(1:K, errVI, 1:K, errPI);
legend({'Error for Value iteration', 'Error for Policy iteration'});
%we state that the PI algorithm converges much faster than VI

%% Q-Learning
tic
Qlearning(0.2, 10000, 100, M,K,h,c,pr)
toc
