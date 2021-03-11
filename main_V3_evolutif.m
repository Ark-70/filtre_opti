%% Reset
clear all, close all, clc;

%% Params USER

PLOT_PROC = 0;
PLOT_ESTIMATION = 0;
PROC_REEL = 1;
nb_ech = 50000;
var_proc = 10;
% poles_tab = [0.95*exp(1j*(pi/5)) 0.9*exp(1j*(3*pi/4)) 0.95*exp(1j*(pi/2))]
poles_tab = [0.95*exp(1j*(pi/5)) 0.9*exp(1j*(3*pi/4))];

%% Params calculés


%% Création processus

[x, H] = create_AR_proc_evolutif(poles_tab, var_proc, nb_ech, PROC_REEL); %poles_tab, var, nb_ech

N = length(H); % on veut des paquets de x de longueur = longueur h = n

rx = xcorr(x); % on fait le vecteur d'autocor
if(PLOT_PROC)
    figure;
    plot(rx);
end
% ech_en_0 = rx((length(rx)+1)/2);
% Rx = toeplitz(ech_en_0, ech_en_0+p); % on fait une toeplitz pour avoir la matrice d'autocor


% H_chap = ones(1, N); % on initialise notre H estimé a je sais pas quoi

padding = 7-mod(length(x),7); % je rajoute un padding a la fin de x pour etre divisible par nombre de coef de H

% mat = temps en horizontal, vecteur d'un instant t en vertical
realisation_mat = toeplitz(x, [x(1) ; zeros(N-1, 1)])'; % des zeros parce qu'on connait pas avant t0


H_chap_mat = zeros(N-1, nb_ech); % on s'en fout du premier coef parce que c'est un 1
% Hypothèse personnelle, c'est peut-être le coef pour aller de X(k) (dans
% la mémoire) à X(k) (le même instant) donc bon c'est 1

H_chap_mat(:, 1) = zeros(N-1, 1); 
%% A l'instant t

E = 0;

for i=7:nb_ech-1

    d = realisation_mat(1,i); % le x du temps présent, celui qu'on essaie d'estimer, = réponse 
    X = -realisation_mat(2:end,i); % On a tous les x dans le passé
    
    H_chap = H_chap_mat(:, i);

    y = H_chap' * X;

    e = d - y;

    % Correction
    alpha = 0.0001;
    
    
    terme_correction = alpha*X'* e;
    H_chap_mat(:, i+1) = H_chap_mat(:, i)+terme_correction';
    E = [E e];
end

H_estime = [1 H_chap'];

% figure
% plot(E)

if(PLOT_ESTIMATION)
    figure
    axe = 1:nb_ech;
    plot(axe, H_chap_mat(1,:));
    hold on;
    plot(axe, H_chap_mat(2,:));
    plot(axe, H_chap_mat(3,:));
    plot(axe, H_chap_mat(4,:));
    plot(axe, H_chap_mat(5,:));
    plot(axe, H_chap_mat(6,:));
    plot([0 nb_ech], [H(2) H(2)], 'b')
    plot([0 nb_ech], [H(3) H(3)], 'r')
    plot([0 nb_ech], [H(4) H(4)], 'y')
    plot([0 nb_ech], [H(5) H(5)], 'k')
    plot([0 nb_ech], [H(6) H(6)], 'g')
    plot([0 nb_ech], [H(7) H(7)], 'b')
end

