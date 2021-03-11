function[x,P] = kalman_perso(x,phi, H, R, G, Q, P, y)
%% Phase d'estimation
x = phi*x;
P = phi*P*phi.'+G*Q*G.';
%% Phase de correction
K = P*H.'*inv(H*P*H.'+R);
s = size(K*H);
x = x + K*(y-H*x);
P = (eye(s)-K*H)*P;

end