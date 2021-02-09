%Atividade 2
clear all; close all;
% teta''(t) + g/l sen teta(t) = 0
% v1 = teta
% v2 = teta'
% A = [ 0            1]   B = [0]
%     [ -g cos(v1)   0]       [0]
%

%declarar variáveis globais
global l;
global g;
l = 1;
g = 9.81;
tempoTotal = 10;
optOde = odeset('maxStep', 0.05);

% condição inicial (pi/10,0)
v0_pi_10 = [pi/10 0];
%não linear
outOde_pi_10 = ode45(@Naolinear,[0 tempoTotal], v0_pi_10, optOde);
%linear (utilizando modelo para (0,0))
outOde2_pi_10 = ode45(@linear, [0 tempoTotal], v0_pi_10, optOde);

%plots
figure()
subplot(2,1,1);
plot(outOde_pi_10.x,outOde_pi_10.y(1,:),'r',outOde_pi_10.x,outOde_pi_10.y(2,:),'g');
xlabel('tempo [s]'); grid;
hold on
plot(outOde2_pi_10.x,outOde2_pi_10.y(1,:),'b',outOde2_pi_10.x,outOde2_pi_10.y(2,:),'m');
xlabel('tempo [s]'); grid;
legend('\theta_1','\omega_1','\theta_2','\omega_2');
title('Fase e derivada em função do tempo (condição inicial - pi/10,0)');
xlabel('tempo [s]');
grid;
hold off;

subplot(2,1,2);
plot(outOde_pi_10.y(1,:),outOde_pi_10.y(2,:),'r');
title('Plano de fase (condição inicial - pi/10,0)');
hold on
plot(outOde2_pi_10.y(1,:),outOde2_pi_10.y(2,:),'b');
xlabel('tempo [s]'); grid;
legend('Não linear','Linear');
xlabel('tempo [s]'); ylabel('omega [rad/s]')
grid;
hold off;

% condição inicial (pi/4,0)
v0_pi_4 = [pi/4 0];
%não linear
outOde_pi_4 = ode45(@Naolinear,[0 tempoTotal], v0_pi_4, optOde);
%linear (utilizando modelo para (0,0))
outOde2_pi_4 = ode45(@linear, [0 tempoTotal],  v0_pi_4, optOde);

%plots
figure()
subplot(2,1,1);
plot(outOde_pi_4.x,outOde_pi_4.y(1,:),'r',outOde_pi_4.x,outOde_pi_4.y(2,:),'g');
xlabel('tempo [s]'); grid;
hold on
plot(outOde2_pi_4.x,outOde2_pi_4.y(1,:),'b',outOde2_pi_4.x,outOde2_pi_4.y(2,:),'m');
xlabel('tempo [s]'); grid;
legend('\theta_1','\omega_1','\theta_2','\omega_2');
title('Fase e derivada em função do tempo (condição inicial - pi/4,0)');
xlabel('tempo [s]');
grid;
hold off;

subplot(2,1,2);
plot(outOde_pi_4.y(1,:),outOde_pi_4.y(2,:),'r');
title('Plano de fase (condição inicial - pi/4,0)');
hold on
plot(outOde2_pi_4.y(1,:),outOde2_pi_4.y(2,:),'b');
xlabel('tempo [s]'); grid;
legend('Não linear','Linear');
xlabel('tempo [s]'); ylabel('omega [rad/s]')
grid;
hold off;

%videos
%geraVideo(outOde_pi_10.x, outOde2_pi_10.y, outOde_pi_10.y, tempoTotal, l,'pendSimples_pi_10.avi');
%geraVideo(outOde_pi_4.x, outOde2_pi_4.y, outOde_pi_4.y, tempoTotal, l, 'pendSimples_pi_4.avi');

def_pi_10 = defasagem(outOde_pi_10, outOde2_pi_10);
title('Defasagem entre simulações para \Theta_0 = \Pi/10');
def_pi_4 = defasagem(outOde_pi_4, outOde2_pi_4);
title('Defasagem entre simulações para \Theta_0 = \Pi/4');

disp("Tempos com defasagem superior a 2 graus para Pi/10")
def_tempo(def_pi_10,outOde_pi_10.x)
disp("Tempos com defasagem superior a 2 graus para Pi/4")
def_tempo(def_pi_4,outOde_pi_4.x)

function def = defasagem(outOde,outOde2)%Encontra a defasagem angular
    %outOde = não linear
    %outOde2 = linear
    def = abs(rad2deg(outOde.y(1,:) - outOde2.y(1,:)));
    figure()
    plot(outOde.x, def);
    ylabel('Defasagem [graus]');
    xlabel('Tempo [s]');
    grid;
end

function def_t = def_tempo(def, outOde)
    %Encontra os intervalos temporais com defasagem superiores a 2 graus
    primeiro = 0;
    for k = 1:length(def)
        if (def(1,k) >= 2) && (primeiro == 0)
            primeiro = 1;
            fprintf("T: %.2f s --", outOde(k))
        elseif (def(1,k) <= 2) && (primeiro == 1)
            primeiro = 0;
            fprintf("%.2f \n", outOde(k))
        end
    end
end


%função para o caso não linear
function dV_nl = Naolinear(t,v)
global l;
global g;
l = 1;
g = 9.81;
dV_nl(1,1) = v(2);
dV_nl(2,1) = (-g/l)*sin(v(1));

end

%função para o caso linear
function dV = linear(t,v)

A = calculaMatrizA(v);
dV = A*v;

end

%calcula matriz do caso linear
function A = calculaMatrizA(v)
global l;
global g;
l = 1;
g = 9.81;
A = [0 1;
    (-g/l) 0];
end

function geraVideo (tempo , estadosN , estadosL , tempoTotal , L, nome)
% entradas :
% tempo : vetor contendo os instantes de tempo da simulação
% estadosN : vetor contando os estados ( theta e dot_theta ) da simulação não linear
% estadosL : vetor contando os estados ( theta e dot_theta ) da simulação linear
% tempoTotal : tempo total da simulação
% L: comprimento do fio ( metros )
%nome: nome do arquivo a ser salvo
writerObj = VideoWriter (nome , 'Motion JPEG AVI') ;
writerObj.FrameRate = ceil ( size ( tempo ,2) / tempoTotal ) ;
open ( writerObj );
fig = figure () ;
ori = [0 0]; % origem do pêndulo
f = 1;
while f <= length ( tempo )
theta1 = estadosN (1 , f) ;
% determine aqui as coordenadas do corpo para o caso não linear ( use L)
x1 = L*sin(theta1);
y1 = -L*cos(theta1);
% determine aqui as coordenadas do corpo para o caso linearizado ( use L )
theta2 = estadosL (1 , f) ;
x2 = L*sin(theta2);
y2 = -L*cos(theta2);

axis ([ -2 2 -2.5 0.5]) ;
hold on ;
% desenhe os pêndulos aqui
plot(x1,y1,'o','MarkerSize',10,'MarkerFaceColor','r');
line([0 x1],[0 y1]);
plot(x2,y2,'o','MarkerSize',10,'MarkerFaceColor','b');
line([0 x2],[0 y2]);
legend('Não linear','Linear'); grid;

hold off ;
F = getframe ;
writeVideo (writerObj , F) ;
clf ( fig ) ;
f = f +1;

end
close (writerObj );
end