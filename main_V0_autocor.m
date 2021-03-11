%% Reset
clear all, close all, clc;

%% Params USER

PROC_REEL = 1;

poles_tab = [0.95*exp(1j*(pi/5)) 0.9*exp(1j*(3*pi/4)) 0.95*exp(1j*(pi/2))]

%% Params calculés

if(PROC_REEL)
   poles_tab = [poles_tab conj(poles_tab)]; 
end

%% Création processus

x = create_AR_proc(poles_tab, 10, 500); %poles_tab, var, nb_ech

rx = xcorr(x); % on fait le vecteur d'autocor
plot(rx);

% ech_en_0 = rx((length(rx)+1)/2);
% Rx = toeplitz(ech_en_0, ech_en_0+p); % on fait une toeplitz pour avoir la matrice d'autocor



