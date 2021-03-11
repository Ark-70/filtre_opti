function [x, H] = create_AR_proc(poles_tab, var, ech)
PLOT_FFT = 1
PLOT_DSP = 1

%     nfft = 1000;
%     fech = nfft;
    
    ordre_p = length(poles_tab);
    
    u = randn(ech, 1)*sqrt(var);
%     x = zeros(ech, 1);
    
    memory = zeros(length(poles_tab), 1);
    
        
    % Nos poles sont des racines de polynomes
    H = poly(poles_tab)
    % ((les coefs de notre polynome correspondent aux ai))
    
%     x = conv(h,u, 'same');
%     x = conv(u,H, 'same'); % conv ca va faire un Filtre RIF, nous on veut
%     un RII, on veut un filtre de 1/mes_coefs, pas un filtre mes_coefs
    x = filter(1, H, u); 

    if(PLOT_FFT)
        
        figure;
        X = fft(x);
        
        plot(abs(X).^2)
%         plot(-fech/2:(fech/2)-1, fftshift(X));
%         hold on
    end
    if(PLOT_DSP)
%         dsp = ech*abs(fft(H,ech)).^2*var;
        figure;
        dsp = periodogram(x);
        plot(dsp);
        hold off
    end
    
    
end