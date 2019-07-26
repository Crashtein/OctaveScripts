#pkg load io;
#pkg load windows;
#pkg load control;

% two inertial object Time const seeking

clear;

time = xlsread('datazad2.xlsx', 'Arkusz1', 'A2:A32');
Twe = xlsread('datazad2.xlsx', 'Arkusz1', 'B2:B32');
Twy2 = xlsread('datazad2.xlsx', 'Arkusz1', 'D2:D32');

T1_min=input("Podaj pocz¹tkowy zakres poszukiwañ sta³ej czasowej1(1):");
if isempty (T1_min)
  T1_min=1;
endif
T1_max=input("Podaj koñcowy zakres poszukiwañ sta³ej czasowej1(4): ");
if isempty (T1_max)
  T1_max=4;
endif
st1=input("Podaj krok1(0.1): ");
if isempty (st1)
  st1=0.1;
endif

T2_min=input("Podaj pocz¹tkowy zakres poszukiwañ sta³ej czasowej2(1):");
if isempty (T2_min)
  T2_min=1;
endif
T2_max=input("Podaj koñcowy zakres poszukiwañ sta³ej czasowej2(4): ");
if isempty (T2_max)
  T2_max=4;
endif
st2=input("Podaj krok2(0.1): ");
if isempty (st2)
  st2=0.1;
endif

blad1_min=10000000;
Twy1_obliczone=double(size(time));
Twy1_obliczone(1)=Twy2(1);
Twy2_obliczone=double(size(time));
Twy2_obliczone(1)=Twy2(1);
    
for T1=T1_min:st1:T1_max
  for T2=T2_min:st2:T2_max
    if (((time(2)-time(1))-T1+T2)==0)
      continue
    endif
    blad1=0;
    for i=2:size(time)
      Twy1_obliczone(i)=Twy1_obliczone(i-1)+(Twe(i)-Twy1_obliczone(i-1))*(time(i)-time(i-1))/T1;
      Twy2_obliczone(i)=Twy2_obliczone(i-1)+(Twy1_obliczone(i)-Twy2_obliczone(i-1))*(time(i)-time(i-1))/T2;
      blad1+=(Twy2(i)-Twy2_obliczone(i))^2;
    endfor
    if (blad1<blad1_min)
      blad1_min=blad1;
      stala1=T1;
      stala2=T2;
    endif
  endfor
endfor

for i=2:size(time)
      Twy1_obliczone(i)=Twy1_obliczone(i-1)+(Twe(i)-Twy1_obliczone(i-1))*(time(i)-time(i-1))/stala1;
      Twy2_obliczone(i)=Twy2_obliczone(i-1)+(Twy1_obliczone(i)-Twy2_obliczone(i-1))*(time(i)-time(i-1))/stala2;
endfor

disp("Wyznaczona stala1 wynosi: "), disp(stala1)
disp("Wyznaczona stala2 wynosi: "), disp(stala2)
disp("B³¹d dla wyznaczonej sta³ej wynosi: "), disp(blad1_min)

figure(1)
plot(time, Twy2, 'g', time, Twy2_obliczone, '--');
xlabel ("time [min]");
ylabel ("temperature [C]");
title ("Temperature2(time)");
legend ("Twy2", "Twy2 obliczone");

figure(2)
plot(time, Twe, 'b', time, Twy1_obliczone, '-.', time, Twy2, 'g', time, Twy2_obliczone, '--');
xlabel ("time [min]");
ylabel ("temperature [C]");
title ("Temperature(time) summary");
legend ("Twe", "Twy1 obliczone", "Twy2", "Twy2 obliczone");

disp('Generowanie odpowiedzi skokowej dla obiektu o wyznaczonych sta³ych')
k=input("WprowadŸ wzmocnienie(1): ");
if isempty(k )
  k=1;
endif
disp("Transmitancja obiektu wynosi: ");
G_s=tf(1,[stala1,1])*tf(1,[stala2,1])
figure(4)
step(G_s);
title ("OdpowiedŸ skokowa obiektu");