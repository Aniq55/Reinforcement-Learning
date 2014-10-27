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

[newP, newR] = policy_matrices(P, R, pi);
[P,R]=MDP(D,M,K,h,c,pr);
V0 = ((1:16) - ones(1,16))';
pol_eval_1(pi, P, R, gamma)
pol_eval_3(pi, P, R, gamma, V0 , 600)
pol_eval_2(500,n,V0,pi,D,M,K,h,c,pr,gamma)

%% Value iteration

nb_it=100;
V0=zeros(M+1,1);

tic
[V, pol]=VI(P,R,gamma,V0,nb_it);
toc


%% Policy iteration 
[VPI, piPI] = PI(P,R, gamma, (1:16)', 500);

%% Q-Learning
