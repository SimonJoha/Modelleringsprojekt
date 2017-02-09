%% Translation & Rotation


close all
values = 8001;
tid = linspace(0,1,values);
%time = linspace(0, values);
mass = 5; %kg
langd = 1; %Meter
bredd = 1; %Meter
frictionStill = 0.5;
frictionMove = 0.2;
gravity = 9.82; % m/s^2
radie = 0.8; %Meter
CoR = 0.5;% bara ett tal mellan 0-1, studskoefficient

% Impulskraft
force = zeros(values,1);
force(1) = 100; %newton
forceAngle = 1;%radian

% Translation x-led
velx = zeros(values,1);
posx = zeros(values,1);
accx = zeros(values,1);

% Translation y-led
vely = zeros(values,1);
posy = zeros(values,1);
posy(1) = 0.2; %start position on y-axis
accy = zeros(values,1);

%Rotation runt z-axeln
acce = zeros(1, values);
hastighet = zeros(1, values);
vinkel = zeros(1, values);

vinkel(1) = pi/2; % Startvinkel, radian
% Om radie < Hmin -> tippar bak�t, Om radie > Hmax -> tippar fram�t 
Hmin = (((force(1)*langd)/2) - ((mass*gravity*bredd)/2) - ((frictionStill * langd)/2)) / force(1); %Meter
Hmax = (((force(1)*langd)/2) + ((mass*gravity*bredd)/2) - ((frictionStill * langd)/2)) / force(1); %Meter


troghet = mass/3*(langd^2+bredd^2); %kg/m^2
step = 1/1000; %Step size
ifsats = 0;

for index = 1:values-1
   % Translation i x-led
    if ( cos(forceAngle) * force(1) >= frictionStill)
    accx(index) = 1/mass * (cos(forceAngle) * force(index) - frictionMove * velx(index));
    velx(index+1) = velx(index) + step * accx(index);
    posx(index+1) = posx(index) + step * velx(index);
   else
       accx(index) = 0;
       velx(index+1) = 0;
       posx(index+1) = 0;    
   end
    % Translation i y-led
   if posy(index) > 0
       accy(index) = 1/mass * (sin(forceAngle) * (force(index) - gravity));
       vely(index+1) = vely(index) + step * accy(index);
       posy(index+1) = posy(index) + step * vely(index);
   else
       accy(index) = 0;
       vely(index+1) = 0;
       posy(index+1) = 0;  
   end
   
   % Rotation runt z-axeln
   if radie < Hmin % Faller bak�t
        
        acce(1,index+1) = ((1/troghet)*(force(index)*radie) + gravity*mass*cos(vinkel(index)));
        hastighet(1,index+1) = hastighet(index) + step*acce(index);
        vinkel(1,index+1) = (vinkel(index) + (step*hastighet(index)));
        
        if vinkel(1,index) > pi 
            vinkel(1,index+1) = pi;
            hastighet(1,index+1) = -hastighet(index)*CoR;
            ifsats = 1;
        end
        loop = 1; 
        
    elseif radie > Hmax % Faller fram�t
          
            acce(1,index) = (1/troghet)*(force(index)*radie) + gravity*mass*cos(vinkel(index));
            hastighet(1,index+1) = hastighet(index) + step*acce(index);
            vinkel(1,index+1) = (vinkel(index) - (step*hastighet(index)));
        
            if vinkel(1,index) < 0
                vinkel(1,index+1) = 0;
                hastighet(1,index+1) = -hastighet(index)*CoR;
            end
            loop = 2;
    else % Translateras endast
        vinkel(1,index) = 0;
        hastighet(1,index) = 0;
        acce(1, index) = 0;  
        loop = 3;
   end
end


subplot(4,3,1)
plot(tid,accx);
title('Acceleration x-led')
subplot(4,3,2)
plot(tid,velx);
title('Hastighet x-led')
subplot(4,3,3)
plot(tid,posx);
title('Position x-led')
subplot(4,3,4)
plot(tid,accy);
title('Acceleration y-led')
subplot(4,3,5)
plot(tid,vely);
title('Hastighet y-led')
subplot(4,3,6)
plot(tid,posy);
title('Position z-led')
subplot(4,3,7)
plot(tid,acce);
title('Vinkelacceleration')
subplot(4,3,8)
plot(tid, hastighet);
title('Vinkelhastighet')
subplot(4,3,9)
plot(tid, vinkel);
title('Vinkel')

