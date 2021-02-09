%Atividade 1
close all; clear all; clc;
%equa��o diferencial dada por
%       y'''(t) + (2+6p)y''(t) + (9+12p)y'(t) +18y(t) = 18x(t)
%na qual p � um valor desconhecido que pertence � faixa [0.1, 1.2]

%definir p
p = linspace(0.1,1.2,50);

%chama o diagrama do simulink 50 vezes, para 50 valores diferentes de p
for i = 1:51
    simOut = sim('sistemaLinearOrdem3','SrcWorkspace','current','maxstep','0.1');
end

%encontrar maior valor de Mp e para qual p ele ocorre
%   m � o vetor com os maiores valores de Mp
%   pm � o vetor com seus �ndices
y_end = simOut.yout{1}.Values.Data(end); %valor em que o sinal estabiliza

[m,pm] = max(simOut.yout{1}.Values.Data);

[y_max,index] = max(m);%Valor m�ximo para o sobressinal
m_max = (y_max - y_end)/y_end;
fprintf("Maior valor de Mp %.3f \n", m_max);

p_max = p(index);%Valor de p para o m�ximo M
fprintf("Valor de p para o qual o maior Mp ocorre %.2f \n", p_max);

pm_m_max = pm(index);%Valor de pm (�ndice) para M maximo

%encontrar o valor no tempo para o qual ocorre o m�ximo sobressinal
t_max = simOut.tout(pm_m_max);%Valor em que ocorre o m�ximo sobressinal
fprintf("Instante de tempo em que o maior Mp ocorre %.2f \n", t_max);

%valores de p para os quais o sobressinal n�o execede em 7%
n = 1;
pmenor7 = [];
for i = 1:50
%se o sobressinal � menor que 1.07 do valor em que o sinal estabiliza
  if (((m(i)-y_end)/y_end) < 0.07)
      p_menor7(n) = p(i); %salvar o p correspondente a esse �ndice em um vetor
      n = n + 1;
  end
end

%menor valor de p
fprintf("menor valor de p que o sobressinal n�o execede 0.07: %.3f \n", p_menor7(1));
%maior valor de p
fprintf("maior valor de p que o sobressinal n�o execede 0.07: %.3f \n",p_menor7(end));

%valor de p que gera o Mp mais pr�ximo de 7%
x = 5;
for i = 1:50
  if (abs(((m(i)-y_end)/y_end) - 0.07)<x) %se diferen�a for menor que a anterior
      x =abs(((m(i)-y_end)/y_end) - 0.07); %redefine x
      p_prox = p(i); %redefine p que gera o sinal
      m_prox = m(i) - y_end;
  end
end

fprintf("valor de p que gera o sinal mais pr�ximo de 0.07: %.3f \n",p_prox);
fprintf("valor de mp mais pr�ximo de 0.07: %.3f \n", m_prox);

%fun��o de transfer�ncia
Func_transferencia=tf(18,[1 (2+6*p_prox) (9+12*p_prox) 18])
polos = pole(Func_transferencia)

%encontrar faixa de p para a qual n�o h� sobressinal (Mp < 1%)
n = 1;
pmenor1 = [];
for i = 1:50
 %se o sobressinal � menor que 1.01 do valor em que o sinal estabiliza
  if (abs(((m(i)-y_end)/y_end) <= 0.01))
      p_menor1(n) = p(i); %salvar o p correspondente a esse �ndice em um vetor
      n = n + 1;
  end
end

%menor valor de p
fprintf("menor valor de p que o sobressinal n�o execede 0.01: %.3f \n", p_menor1(1));
%maior valor de p
fprintf("maior valor de p que o sobressinal n�o execede 0.01: %.3f \n",p_menor1(end));
