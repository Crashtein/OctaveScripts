%e^((-Tks)/(1+Ts)) Maclauren approximation
clear;
k=input("Podaj k(2):");
if isempty (k)
  k=2;
endif
T=input("Podaj T(40): ");
if isempty (T)
  T=40;
endif
n=input("Podaj P(5): ");
if isempty (n)
  n=5;
endif
I=tf([-T*k 0], [T 1])
G_s=tf([1], [1]);
for i=1:n
  Ii=I^i;
  for j=1:i
    Ii=Ii/j;
  endfor
  G_s+=Ii;
endfor
display(G_s);
step(G_s,T*15);