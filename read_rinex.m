function [Obs,Nav,date,rcvpos,Year,Doy]=read_rinex(PathName,FileName)
Nav=read_rinex_nav(FileName);
[Obs,date,rcvpos]=read_rinex_obs(PathName);
D1  = date(1:3); % obs.date
D2  = D1; 
D2(:,2:3) = 0;
ydoy = cat(2, D1(:,1), datenum(D1) - datenum(D2));
Year = num2str(ydoy(1,1));
Doy  = num2str(ydoy(1,2),'%.3d');
end