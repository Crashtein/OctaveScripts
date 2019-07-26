#pkg load io;
#pkg load windows;
#pkg load control;

% one inertive object Time const seek

clear;

time = xlsread('data.xlsx', 'Arkusz1', 'A2:A32');
Twe = xlsread('data.xlsx', 'Arkusz1', 'B2:B32');
Twy = xlsread('data.xlsx', 'Arkusz1', 'C2:C32');

blad_min=10000000;

stala_min=input("Podaj pocz¹tkowy zakres poszukiwañ sta³ej czasowej(2):");
if isempty (stala_min)
  stala_min=2;
endif
stala_max=input("Podaj koñcowy zakres poszukiwañ sta³ej czasowej(6): ");
if isempty (stala_max)
  stala_max=6;
endif
st=input("Podaj krok(0.1): ");
if isempty (st)
  st=0.1;
endif

for tstala=stala_min:st:stala_max
  blad=0;
  Twy_obliczone=double(size(time));
  Twy_obliczone(1)=Twy(1);
  for i=2:size(time)
    Twy_obliczone(i) = Twy_obliczone(i-1)+(Twe(i)-Twy_obliczone(i-1))*(time(i)-time(i-1))/tstala;
    blad+=(Twy(i)-Twy_obliczone(i))^2;
  endfor
  if (blad<blad_min)
    blad_min=blad;
    stala_czasowa=tstala;
  endif
endfor

blad=0;
Twy_obliczone=double(size(time));
Twy_obliczone(1)=Twy(1);
for i=2:size(time)
  Twy_obliczone(i) = Twy_obliczone(i-1)+(Twe(i)-Twy_obliczone(i-1))*(time(i)-time(i-1))/stala_czasowa;
  blad+=(Twy(i)-Twy_obliczone(i))^2;
endfor

disp("Wyznaczona stala wynosi: "), disp(stala_czasowa)
disp("B³¹d dla wyznaczonej sta³ej wynosi: "), disp(blad)

figure(1)
plot(time, Twe, 'r', time, Twy, 'g', time, Twy_obliczone, '--');
xlabel ("time [min]");
ylabel ("temperature [C]");
title ("Temperature(time)");
legend ("Twe", "Twy", "Twy obliczone");

disp('Generowanie odpowiedzi skokowej dla wyznaczonej sta³ej')
k=input("WprowadŸ wzmocnienie(1): ");
if isempty(k )
  k=1;
endif
disp("Transmitancja obiektu wynosi: ");
G_s=tf(1,[stala_czasowa,1])
figure(2)
step(G_s);
