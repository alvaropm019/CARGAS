% INICIALIZACIÓN
main_datos
addpath("Simulacion Tiempo\")
tmax = 35;

f = f_Chirp;
%f = f_Sin;
f = f_ImpactoGaussiano;
f = f_SpectroGaussiano;

tejemplo =  0:0.01:tmax;

figure
ejes = gca;
plot(tejemplo, f(tejemplo),'-r')
ejes.XLim = [0,tmax];
ejes.YLim = [-1.5,5];
grid on;