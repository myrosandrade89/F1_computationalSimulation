%%SIMULACIÓN FORMULA 1
clear
a=[100 450 730 875 1900 2020 2200 2400];
b=[1700 748 690 752 2569 2636 2447 1800];
c=polyfit(a,b,3);
c(4)=c(4)-25;
[x,y]=polinomio(c);
[A,ra]=radio(c(1),c(2),c(3),c(4));
[large]=largofun(c(1),c(2),c(3));
%MODELACIÓN LA FUNCIÓN OBTENIDA SE MUESTRA EN PANTALLA
figure(1)
plot (x,y)
%VALORES
fprintf("El valor de a1 de la función es: %f\n",c(1))
fprintf("El valor de a2 de la función es: %f\n",c(2))
fprintf("El valor de a3 de la función es: %f\n",c(3))
fprintf("El valor de a4 de la función es: %f\n",c(4))
%VALIDACIÓN LOS PUNTOS SE MUESTRAN EN MATLAB
hold on
plot(a(1), b(1),"-o")
plot(a(8), b(8),"-o")
%LC
fprintf("El largo de la función es de: %f\n", large)
%MÁXIMOS Y MÍNIMOS
[MA,MI]=MAXMIN(c(1),c(2),c(3));
MA=eval(MA);
MI=eval(MI);
maximo=max(y);
minimo=min(y);
CO=[MA maximo MI minimo];
txt = (string("\bullet \leftarrow Máximo: ("+string(CO(1))+','+string(CO(2))+')'));
text(CO(1),CO(2),txt)
txt = (string("\bullet \leftarrow Mínimo: ("+string(CO(3))+','+string(CO(4))+')'));
text(CO(3),CO(4),txt)
%ZONA CRÍTICA
fprintf("La función tiene un radio mínimo de: %f\n",A)

% PROGRAMA PRINCIPAl % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf("//////////////////////////SIMULACIÓN//////////////////////////\n")

%DATOOOS
%Fuerza de arrastre a 300 km/h: 5000 N
fuerza_arrastre = 5000;
k = fuerza_arrastre/(300*(1000/3600))^2;
%Fuerza de sustentación invertida a 300 km/h: 14000 N
fuerza_sustentacion = 14000;
constante_sustentacion = fuerza_sustentacion/(300*(1000/3600))^2;
%Peso mínimo incluido el piloto 820 kg
masa = 900;
%Potencia máxima del motor sin considrear (ERS) 600 HP. Considere un 20% de pérdida en la transmisión a las llanta.
potencia_caballos = input("Ingresa la potencia inicial en HP (El valor máximo es de 480 HP)");
potencia_watts = potencia_caballos * 745.7;
%Longitud mínima 3.5 km y máxima 7.0 km
%Ancho de la pista 12 m y 15 m en la línea de salida
%Longitud máxima para una recta 2.0 km
%Peralte máximo en las curva: 10%
angulo = atan(10/100)*180/pi;
% Coeficiente de fricción estático con las llantas u=1.18
coeficiente_friccion_s = 1.18;
% Gravedad m/s
gravedad = 9.81;
%velocidad inicial
velocidad_km = input("Ingresa la velocidad inicial en km/h: ");
velocidad_m = velocidad_km*(1000/3600);

%CONDICIONES INICIALES

potenciaAuto = zeros(1,2299);
potenciaAutoCaballos = zeros(1,2300);
velocidadInstantanea = zeros(1, 2300);
aceleracionLineal = zeros(1, 2300);
fuerza = zeros(1, 2300);
velocidadMedia = zeros(1, 2300);
perdidaEnergia = zeros(1, 2300);
deltax=zeros(1,2300);
deltay=zeros(1,2300);
velocidadInstantaneaKM = zeros(1, 2300);

r=[];




figure(2)
%Simbolos para resolver ecuaciones
syms u(t) h


%Valores iniciales
potenciaAuto(1) = potencia_watts;
potenciaAutoCaballos(1) = potencia_caballos;

velocidadInstantanea(1) = velocidad_m;
velocidadInstantaneaKM(1) = velocidad_km;
fuerza(1) = potencia_watts/velocidad_m;
aceleracionLineal(1) = fuerza(1)/masa;
velocidadMedia(1) = (velocidadInstantaneaKM(1))/1;
perdidaEnergia(1) = 0;
deltax(1) = 100;
deltay(1) = 1693;



%Fondo
ax=axes("units", "normalized", "position", [0 0 1 1]); %El comando axes crea un objeto eje.Es creado con unidades normales, así como la posición [0,0,1,1] que llena la ventana completa.
uistack(ax,"bottom"); %uistack mueve el objeto eje debajo de otros ejes, es decir, lo pone de fondo.
fondo=imread("pasto.jpg"); %La función imread regresa los datos de la imagen de fondo en una matriz A.
im=imagesc(fondo); %La función imagesc imprime los datos de la matriz A como una imagen que usa el rango completo de colores. 
set(ax, "handlevisibility", "off", "visible", "off") %Desactiva la visibilidad de handle y también hace los ejes invisibles.




plot(x,y,'or','MarkerSize',10,'MarkerEdgeColor','black','MarkerFaceColor','black')
hold on
plot(x,y,'LineWidth',0.5,'Color','r','LineStyle','--')

axis([100 2400 300 3000])

title('\color{white}Simulación de pista de carreras de F1','FontSize',15);

str = {'    '};
dim = [.2 .22 0 0];
annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor','red');
drawnow;

str = {'    '};
dim = [.63 .8 0 0];
annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor','red');
drawnow;

i=1;
while deltax(i)<2400

    r(i)=ra(round(deltax(i))-99);
    if (r(i)>100 && r(i)<250) 
        per = 5.75;
        velocidad_maxima = sqrt((masa*gravedad/(cosd(per)-coeficiente_friccion_s*sind(per)))*(sind(per)+coeficiente_friccion_s*cosd(per)) / (((masa/r(i))+constante_sustentacion*cosd(per))*(1-(sind(per)/(cosd(per)-coeficiente_friccion_s*sind(per)))-(coeficiente_friccion_s*cosd(per)/(cosd(per)-coeficiente_friccion_s*sind(per))))) )*-sqrt(-1);
        velocidad_minima = sqrt((masa*gravedad/(cosd(per)-coeficiente_friccion_s*sind(per)))*(sind(per)-coeficiente_friccion_s*cosd(per)) / (((masa/r(i))+constante_sustentacion*cosd(per))*(1-(sind(per)/(cosd(per)-coeficiente_friccion_s*sind(per)))+(coeficiente_friccion_s*cosd(per)/(cosd(per)-coeficiente_friccion_s*sind(per))))) )*-sqrt(-1);
        if velocidadInstantanea(i-1)>velocidad_maxima
            pendiente = 3*c(1)*deltax(i-1)^2+2*c(2)*deltax(i-1)+c(3);
            X=deltax(i-1):1:deltax(i-1)+200;
            hold on
            perdidaEnergia(final) = perdidaEnergia(final) + coeficiente_friccion_s*((masa*gravedad+constante_sustentacion*velocidadInstantanea(i-1)*cosd(per))/(cosd(per)-coeficiente_friccion_s*sind(per)))*sqrt(5^2+(deltay(i-1)-(pendiente*(deltax(i-1)+5-deltax(i-1))+deltay(i-1))).^2);
            plot(X,pendiente*(X-deltax(i-1))+deltay(i-1),'<b','MarkerSize',4,'MarkerFaceColor','b') 
            final=i-2;
            
            perdidaEnergia(final) = perdidaEnergia(final) + 100*potenciaAuto(final)/80;
            str = {'\color{white}El auto salió de los límites '};
            dim = [0.25 0.35 .3 .3];
            annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor','red');
            drawnow;
            
            break
        elseif (velocidadInstantanea(i-1)<velocidad_minima)
            X=deltax(i-1):1:deltax(i-1)+200;
            hold on
            plot(X,.004*(X-deltax(i-1)).^2+deltay(i-1),'<b','MarkerSize',4,'MarkerFaceColor','b');
            final=i-2;
            potenciaAuto(i-2)= potenciaAuto(i-2)*(-1);
            potenciaAutoCaballos(i-2)= potenciaAuto(i-2)./745.7;
            
            perdidaEnergia(final) = perdidaEnergia(final) + 100*potenciaAuto(final)/80;
            
            str = {'\color{white}El auto salió de los límites '};
            dim = [0.25 0.35 .3 .3];
            annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor','red');
            drawnow;
            break
        end
    end
    
    if (r(i)>1000)
        
        diferencial = diff(u,t) == (potenciaAuto(i)/u -k*u^2)/masa;
        velocidad=simplify(dsolve(diferencial));
        t=1;
        velocidadInstantanea(i+1) = eval(velocidad(1));
        
        delta = eval(solve(h^2-velocidadInstantanea(i)*h==(velocidadInstantanea(i+1)^2-velocidadInstantanea(i)^2)/2));
        aceleracionLineal(i+1) = (velocidadInstantanea(i+1)^2-velocidadInstantanea(i)^2)/(2*delta(2));
        fuerza(i+1) = (masa*aceleracionLineal(i+1)+k*velocidadInstantanea(i).^2);
        potenciaAuto(i+1) = fuerza(i)*velocidadInstantanea(i+1);
        potenciaAutoCaballos(i+1) = potenciaAuto(i+1)./745.7;
        
        if potenciaAuto(i+1) >= 360000 
            F=i;
            potenciaAuto(i+1)=potenciaAuto(F);
            potenciaAutoCaballos(i+1) = potenciaAuto(i+1)/745.7;
            velocidadInstantanea(i+1) = velocidadInstantanea(i);
            aceleracionLineal(i+1) = 0;
        end
    end
    
    if velocidadInstantanea(i)>60
        ace=3.0;
        desa=2.5;
    elseif velocidadInstantanea(i)<30
        desa=1.5;
        ace=2.5;
    else
        ace = 2.5;
        desa = 1.5;
    end
    
    if (r(i)>=140 && r(i)<1000)
      
        if (deltax(i)<=614 ||  (deltax(i)<1959&&deltax(i)>1300))

            aceleracionLineal(i+1)=-desa;
            velocidadInstantanea(i+1)= aceleracionLineal(i+1)*t+velocidadInstantanea(i);
            fuerza(i+1)=(masa*aceleracionLineal(i+1)+k*velocidadInstantanea(i).^2);
            potenciaAuto(i+1) = fuerza(i+1)*velocidadInstantanea(i+1);
            potenciaAutoCaballos(i+1) = potenciaAuto(i+1)./745.7;
        elseif (deltax(i)>614 || deltax(i)>1959)

            aceleracionLineal(i+1) = ace;
            velocidadInstantanea(i+1)= aceleracionLineal(i)*t+velocidadInstantanea(i);
            fuerza(i+1)=(masa*aceleracionLineal(i+1)+k*velocidadInstantanea(i).^2);
            
            potenciaAuto(i+1) = fuerza(i+1)*velocidadInstantanea(i+1);
            potenciaAutoCaballos(i+1) = potenciaAuto(i+1)./745.7;
        end
        
        
    end
    
    deltax(i+1) = deltax(i) + velocidadInstantanea(i)*t+(1/2)*aceleracionLineal(i)*t^2;
    deltay(i+1)=c(1)*deltax(i+1).^3+c(2)*deltax(i+1).^2+c(3)*deltax(i+1)+c(4);
    velocidadInstantaneaKM(i+1) = velocidadInstantanea(i+1).*(3.6);
    velocidadMedia(i+1) = ((deltax(i)-deltax(1))/i)*(3.6);
    
    plot(deltax(i),deltay(i),'<b','MarkerSize',6,'MarkerFaceColor','b')
    
    str = {'\color{white}Potencia (HP)' potenciaAutoCaballos(i), '\color{white}Velocidad instántanea (km/h)', velocidadInstantaneaKM(i),'\color{white}Aceleración lineal' aceleracionLineal(i),'\color{white}Velocidad Media (km/h)' velocidadMedia(i)};
    dim = [0.6 0.15 .3 .3];
    a=annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor','black');
    drawnow;
    grid off
    axis off
    delete(a)
    i = i+1;
    final=i-1;
end
perdidaEnergia(final) = perdidaEnergia(final) + 100*potenciaAuto(final)/80;
str = {'\color{white}Potencia (HP)' potenciaAutoCaballos(final), '\color{white}Velocidad instántanea (km/h)', velocidadInstantaneaKM(final),'\color{white}Aceleración lineal' aceleracionLineal(final),'\color{white}Velocidad Media (km/h)' velocidadMedia(final),'\color{white}Pérdida de energía (J)' perdidaEnergia(final), '\color{white}Velocidad inicial (km/h)' velocidadInstantaneaKM(1), '\color{white}Potencia inicial (HP)' potenciaAutoCaballos(1)};
dim = [0.6 0.2 .3 .3];
a=annotation('textbox',dim,'String',str,'FitBoxToText','on', 'BackgroundColor','#0072BD');
drawnow;

function [m,y]=polinomio(v)
   m=(100:0.1:2400);
   y=v(1)*m.^3+v(2)*m.^2+v(3)*m+v(4);
end
function [MA,MI]=MAXMIN(a,b,c)
   syms x
   eqn=3*a*x.^2+2*b*x+c==0;
   O = solve(eqn,x);
   if O(1)>O(2)
       MA=O(1);
       MI=O(2);
   else
       MA=O(2);
       MI=O(1);
   end
end
function [MIN,r]=radio(a,b,c,d)
   x=(100:1:2400);   
   f=zeros(1,length(x)-1);
   r=zeros(1,length(x)-1);
   d1=zeros(1,length(x)-1);
   d2=zeros(1,length(x)-1);
   for i=1:length(x)
       f(i)=a*x(i).^3+b*x(i).^2+c*x(i)+d;
       d1(i)=3*a*x(i).^2+2*b*x(i)+c;
       d2(i)=6*a*x(i)+2*b;
       r(i)=((1+d1(i).^2).^(3/2))/abs(d2(i));
   end
   MIN=min(r);
end
function [largo]=largofun(a,b,c)
   syms x
   largo=integral(@(x)(sqrt(1+(3*a*x.^2+2*b*x+c).^2)),100,2400);
end