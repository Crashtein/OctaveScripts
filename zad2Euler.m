#pkg load io;
#pkg load windows;
#pkg load control;

% some tries with Z Euler Transform

clear;

time = xlsread('datazad2.xlsx', 'Arkusz1', 'A2:A32');
Twe = xlsread('datazad2.xlsx', 'Arkusz1', 'B2:B32');
Twy2 = xlsread('datazad2.xlsx', 'Arkusz1', 'D2:D32');

T1_min=input("Podaj pocz¹tkowy zakres poszukiwañ sta³ej czasowej1(-3):");
if isempty (T1_min)
  T1_min=0.5;
endif
T1_max=input("Podaj koñcowy zakres poszukiwañ sta³ej czasowej1(5): ");
if isempty (T1_max)
  T1_max=15;
endif
st1=input("Podaj krok1(0.1): ");
if isempty (st1)
  st1=0.1;
endif

T2_min=input("Podaj pocz¹tkowy zakres poszukiwañ sta³ej czasowej2(-3):");
if isempty (T2_min)
  T2_min=0.5;
endif
T2_max=input("Podaj koñcowy zakres poszukiwañ sta³ej czasowej2(5): ");
if isempty (T2_max)
  T2_max=15;
endif
st2=input("Podaj krok2(0.1): ");
if isempty (st2)
  st2=0.1;
endif

blad1_min=10000000;
Twy2_obliczone=double(size(time));
Twy2_obliczone(1)=Twy2(1);
Twy2_obliczone(2)=Twy2(2);
    
for T1=T1_min:st1:T1_max
  for T2=T2_min:st2:T2_max
    if (((time(2)-time(1))-T1+T2)==0)
      continue
    endif
    blad1=0;
    for i=3:size(time)
      Twy2_obliczone(i) = (Twe(i)*(time(i)-time(i-1))-Twy2(i-2)*T2+(Twy2(i-1))*(T1-2*T2))/(T2-1+(time(i)-time(i-1)));
      %Twy2_obliczone(i) = ((time(i)-time(i-1))*Twe(i)+(2*T2/(time(i)-time(i-1))-T1)*Twy2(i-1)-T2*Twy2(i-2)/(time(i)-time(i-1)))/((time(i)-time(i-1))-T1+T2);
      blad1+=(Twy2(i)-Twy2_obliczone(i))^2;
    endfor
    if (blad1<blad1_min)
      blad1_min=blad1;
      stala1=T1;
      stala2=T2;
    endif
  endfor
endfor

disp("Wyznaczona stale wynosz¹: "), disp(stala1), disp(stala2)
disp("B³¹d1 dla wyznaczonej sta³ej1 wynosi: "), disp(blad1_min)
disp("Transmitancja obiektu wynosi: ")
G_s=tf(1,[stala2 stala1 1])