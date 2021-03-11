function [x, H] = create_AR_proc_evolutif(poles_tab, var, ech, PROC_REEL)
% NE PAS INSERER TOUS LES POLES
% FILER JUSTE CEUX DANS LA PARTIE COMPLEXE avec e^1j...


PLOT_FFT = 0;
PLOT_DSP = 1;
PAS_FIXE = 1;
PLOT_SIGNAL = 1;
PLOT_SPECTROGRAM = 1;

pas_evolution = 500; % en ech
inter_var = [-0.5 0.5]; % en radian
ordre_p = length(poles_tab); % p poles
    
modules = abs(poles_tab);

for i=1:(ech/pas_evolution) % iterations pour construire chaque signal par tranche de pas_evolution


    memory = zeros(ordre_p, 1);

    angles = angle(poles_tab);
    pas_aleatoires = inter_var(1)+(inter_var(2)-inter_var(1)).*rand(1, ordre_p);

    angles = angles+pas_aleatoires;
    
    u = randn(pas_evolution, 1)*sqrt(var);

    % Nos poles sont des racines de polynomes
    new_poles_tab = modules .* exp(1j*(angles));
    
    if(PROC_REEL)
       new_poles_tab = [new_poles_tab conj(new_poles_tab)]; 
    end
    
    H = poly(new_poles_tab);
    % ((les coefs de notre polynome correspondent aux ai))

    % conv() ca va faire un Filtre RIF, nous on veut
    % un RII, on veut un filtre de 1/mes_coefs, pas un filtre mes_coefs
    
    if exist('x','var')
        x = [x ; filter(1, H, u)]; 
    else
        x = filter(1, H, u);
    end
end

if(PLOT_SIGNAL)
    figure;
    plot(x);
end

if(PLOT_FFT)

    figure;
    X = fft(x);

    plot(abs(X).^2)
%         plot(-fech/2:(fech/2)-1, fftshift(X));
    hold on
end

if(PLOT_DSP)
%         dsp = ech*abs(fft(H,ech)).^2*var;
    figure;
    dsp = periodogram(x);
    plot(dsp);
    hold off
end

if(PLOT_SPECTROGRAM)
    figure;
    spectrogram(x, 500, 'yaxis');
end
    
    
end