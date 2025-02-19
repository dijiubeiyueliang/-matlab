function tropo=Saastamoinen(lat,height)
k1= 77.642;
Rdry=287.04;
gm= 9.784;
p0=1013.25;
Ddry=(10^-6)*k1*Rdry*p0/gm;
tropo=Ddry/(1-0.266*10^-2*cosd(2*lat)-0.288*(10^-3)*height);
end