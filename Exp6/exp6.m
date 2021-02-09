 %chama função para frequências desejadas
 omega = [21 22 23 24 25 26 27 28 29];
 pico = identificaBode(omega_3);
 pico_dB = mag2db(pico);
 
 plot(omega, pico_dB, 'b', omega, pico_dB, 'r o')
 title("Diagrama de Bode para o módulo");
 xlabel("Omega");ylabel("Mp [dB]");
 set(gca,'xscale','log')
 grid();
 
 %plotar função de transferência
 k = 178.078;
 b = 2.0648;
 m = 0.1641;
 G = abs((0.0049*k)/(m*s.^2 + b*s + k));
 G_db = mag2db(G);
 G = tf([0.0049*k],[m b k]);
 
  %plotar função de transferência
 k = 178.078;
 b = 2.0648;
 m = 0.1641;
 
 geraBode2(omega, pico_dB, G);

function geraBode2(omega,Mp, G)
        figure; Mp = mag2db(Mp)-46.2;
        semilogx(omega, Mp, 'ro');legend('Experimental');
        hold on;
        bodeplot(G);legend('Analítico')
        grid;
        xlabel('\omega');ylabel('G(j\omega)');
        title('Valores experimentais e analíticos')
end
 
 