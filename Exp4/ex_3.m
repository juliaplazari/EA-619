%Atividade 3
clear all; close all;

%variáveis globais
global L1;
global L2;
global m1;
global m2;
global g;
L1 = 1;
L2 = 1;
m1 = 2;
m2 = 2;
g = 9.81;

%condição inicial zerada
x0 = [pi/10 0 pi/10 0];

tempoTotal = 20;
optOde = odeset('maxStep', 0.05);

outOde = ode45(@PenduloDuplo,[0 tempoTotal], x0, optOde);

figure()
plot(outOde.x,outOde.y); xlabel t;grid;
legend('\Theta_1', '\omega_1','\Theta_2', '\omega_2')
title("Pêndulo duplo, comportamento de \Theta_1, \Theta_2, \omega_1 e \omega_2");
figure()
plot(outOde.y(1,:),outOde.y(2,:));
ylabel('\Theta_1[rad]');xlabel('\omega_1[rad/s]')
ylabel('\Theta_1[rad/s]')
title("Pêndulo duplo, comportamento de \omega_1 em função de \Theta_1[rad]");
grid;
figure()
plot(outOde.y(3,:),outOde.y(4,:)); xlabel t;grid;
ylabel('\Theta_2[rad]');xlabel('\omega_2[rad/s]')
title("Pêndulo duplo, comportamento de \omega_2 em função de \Theta_2[rad]");

%videos
geraVideo(outOde.x, outOde.y, tempoTotal, L1,L2,'pendDuplo.avi');

%função para pendulo duplo
function dX = PenduloDuplo (t , x)
global L1 ;
global L2 ;
global m1 ;
global m2 ;
global g ;
L1 = 1;
L2 = 1;
m1 = 2;
m2 = 2;
g = 9.81;

% variaveis de estado x1 = theta_1 , x2 = w_1 , x3 = theta_2 , x4 = w_2
dX (1 ,1) = x (2) ;
num1 = -g *(2* m1 + m2 )* sin (x (1) ) -m2 *g * sin (x (1) -2* x (3) ) -2* sin (x(1) -x (3) )* m2 *( x (4) ^2* L2 + x (2) ^2* L1 * cos (x (1) -x (3) )) ;
den1 = L1 *(2* m1 + m2 - m2 * cos (2* x (1) -2* x (3) )) ;
num2 = 2* sin (x (1) -x (3) ) *( x (2) ^2* L1 *( m1 + m2 )+ g *( m1 + m2 ) *cos (x (1) ) +x(4) ^2* L2 * m2 * cos ( x (1) -x (3) )) ;
den2 = L2 *(2* m1 + m2 - m2 * cos (2* x (1) -2* x (3) )) ;
dX (2 ,1) = num1 / den1 ;
dX (3 ,1) = x (4) ;
dX (4 ,1) = num2 / den2 ;
end

function geraVideo (tempo , estadosN , tempoTotal , L1, L2, nome)
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
theta = estadosN (1 , f) ;
theta2 = estadosN (3 , f) ;
% determine aqui as coordenadas do corpo para o caso não linear (use L)
x1 = L1*sin(theta);
y1 = -L1*cos(theta);
x2 = L1*sin(theta)+L2*sin(theta2);
y2 = -L1*cos(theta2) - L2*cos(theta2);

axis ([ -2 2 -2.5 0.5]) ;
hold on ;
% desenhe os pêndulos aqui
line([0 x1],[0 y1]);
plot(x1,y1,'o','MarkerSize',10,'MarkerFaceColor','r');
line([x1 x2],[y1 y2]);
plot(x2,y2,'o','MarkerSize',10,'MarkerFaceColor','b');
grid;
title("Pêndulo Duplo");

hold off ;
F = getframe ;
writeVideo (writerObj , F) ;
clf ( fig ) ;
f = f +1;

end
close (writerObj );
end
