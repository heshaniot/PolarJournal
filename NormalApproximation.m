%normal approx

clear all;
subplot(211)
% close all;
format long
SNR = 1:0.5:5;
n = 128;
% epsi = [ 0.1 0.01 0.001];
Rs = log2(1+SNR);
Rs_v = Rs*ones(size(n));
linewidth = 1.5;
% semilogx(n,Rs_v,'LineWidth',linewidth)
% hold on;

R = 0.5 ;
epsilon1 = qfunc( (Rs - R)* sqrt( n./vfunc(SNR))/log2(exp(1)) );

epsilon2 = qfunc( (Rs - R + log2(n)/(2*n))* sqrt( n./vfunc(SNR))/log2(exp(1))) ;
epsilon3 = qfunc( (Rs - R + log2(n)/(2*n))* sqrt( n./vfunc(SNR))) ;



% for i= 1:3
%     epsilon = epsi(i);
%     Rf = Rs - sqrt(vfunc(SNR)./n)*qfuncinv(epsilon)*log2(exp(1));
%     semilogx(n,Rf,'LineWidth',linewidth)
% end
% xlabel('Blocklength - n')
% ylabel('Rate - R')
% grid on;
% legend('Shannon','\epsilon =0.1','\epsilon =0.01','\epsilon =0.001');
% title('Communication at (in)finite block length, SNR = 5 dB')
semilogy(SNR, epsilon1)
hold on
semilogy(SNR, epsilon2)
% hold on
% semilogy(SNR, epsilon3)

legend('limit1', 'limit2', 'limit3')
function v = vfunc(x)
v = x.*(2.+x)/((1.+x).^2);
end