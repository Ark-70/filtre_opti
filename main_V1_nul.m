%% Reset
clear all, close all, clc;

%% Params USER

PROC_REEL = 1;
nb_ech = 500
poles_tab = [0.95*exp(1j*(pi/5)) 0.9*exp(1j*(3*pi/4)) 0.95*exp(1j*(pi/2))]

%% Params calculés

if(PROC_REEL)
   poles_tab = [poles_tab conj(poles_tab)]; 
end

%% Création processus

[x, H] = create_AR_proc(poles_tab, 10, nb_ech); %poles_tab, var, nb_ech

N = length(H); % on veut des paquets de x de longueur = longueur h = n

rx = xcorr(x); % on fait le vecteur d'autocor
plot(rx);

% ech_en_0 = rx((length(rx)+1)/2);
% Rx = toeplitz(ech_en_0, ech_en_0+p); % on fait une toeplitz pour avoir la matrice d'autocor


% H_chap = ones(1, N); % on initialise notre H estimé a je sais pas quoi

padding = 7-mod(length(x),7); % je rajoute un padding a la fin de x pour etre divisible par nombre de coef de H

% mat = temps en horizontal, vecteur d'un instant t en vertical
X_mat = toeplitz(x, [x(1) ; zeros(N-1, 1)])'; % des zeros parce qu'on connait pas avant t0
H_chap_mat = zeros(N, nb_ech)

H_chap_mat(:, 1) = ones(N, 1); 
H = H';
%% A l'instant t

X = X_mat(:,1); % On prend le premier "paquet"
H_chap = H_chap_mat(:, 1);

y = X' * flip(H_chap, 1);


d = X' * flip(H, 1); % notre réponse désirée

e = d - y;


