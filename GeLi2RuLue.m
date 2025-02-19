function [JD]=GeLi2RuLue(time)
 H=time(1,4)+time(1,5)/60+time(1,6)/3600;
if (time(1,2)<=2)
    y=time(1,1)-1;
    m=time(1,2)+12;
else
    y=time(1,1);
    m=time(1,2);
end
JD=floor(365.25*y)+floor(30.6001*(m+1))+time(1,3)+H/24+1720981.5;
end
