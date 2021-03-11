%% Permet de estimer les parametres AR en sappuyant sur Kalman
function [x, P,Mat_X,Mat_P] = generation_AR_Kalman(x,P,y,Q,R,Phi,H,G,u)
    
    %% Etape de prediction
    x = Phi*x + G*u; 
    P = Phi*P*Phi' + G*Q*G';
    
    % stockage des predictions
    %Mat_X(:,1) = x;
    %Mat_P(:,1:4) = P;
    
    
    %% Etape de Correction
    K = (H*P*H' + R)\(P*H'); % gain     
    x = x + K.*(y-H*x); 
    P = P - K*H*P; 
    
    % Stockage de la correction
    %Mat_X(:,2) = x;
    %Mat_P(:,5:8) = P;
     
end
