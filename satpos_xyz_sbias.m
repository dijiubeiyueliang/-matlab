function [satpos,satclock] = satpos_xyz_sbias(PRN,Nav,time,C1)
prn = [Nav.GPS.prn].';
sqrtA=[Nav.GPS.sqrtA].';
E_=[Nav.GPS.e].';
omega=[Nav.GPS.omega].';
OMU=[Nav.GPS.OMU].';
OMEGAdot=[Nav.GPS.OMEGAdot].';
I0=[Nav.GPS.i0].';
idt=[Nav.GPS.idt].';
M0=[Nav.GPS.M0].';
dn=[Nav.GPS.dn].';
Cuc=[Nav.GPS.Cuc].';
Cus=[Nav.GPS.Cus].';
Crc=[Nav.GPS.Crc].';
Crs=[Nav.GPS.Crs].';
Cic=[Nav.GPS.Cic].';
Cis=[Nav.GPS.Cis].';
TOE=[Nav.GPS.TOE].';
deviate=[Nav.GPS.deviate].';
drift=[Nav.GPS.drift].';
rate=[Nav.GPS.rate].';
tgd=[Nav.GPS.tgd].';
Sat = find(prn == PRN);
sqrta   = sqrtA(Sat);      % Semi-major axis                       (m)       
a       = sqrta.^2;
e       = E_(Sat);         % Eccentricity
w0      = omega(Sat);         % Argument of perigee                   (rad)
W0      = OMU(Sat);         % Right ascension of ascending node     (rad)
Wdot    = OMEGAdot(Sat);         % Rate of right ascension               (rad/sec)
i0      = I0(Sat);         % Inclination                           (rad)
idot    = idt(Sat);         % Rate of inclination                   (rad/sec)
M0      = M0(Sat);         % Mean anomaly                          (rad)
delta_n = dn(Sat);         % Mean motion rate                      (rad/sec)

% Correction coefficients
Cuc     = Cuc(Sat);         % Argument of perigee (cos)             (rad) 
Cus     = Cus(Sat);         % Argument of perigee (sine)            (rad)
Crc     = Crc(Sat);         % Orbit radius        (cos)             (m)
Crs     = Crs(Sat);         % Orbit radius        (sine)            (m)
Cic     = Cic(Sat);         % Inclination         (cos)             (rad) 
Cis     = Cis(Sat);         % Inclination         (sine)            (rad)

% Time
Toe     = TOE(Sat);         % Time of Ephemeris                     (SOW : sec of GPS week)
% Clock
T0_bias = deviate(Sat);          % Clock Bias                            (sec)
T0_drift= drift(Sat);          % Clock Drift                           (sec/sec)
T0_drate= rate(Sat);          % Clock Drift rate                      (sec/sec^2)
Tgd     = tgd(Sat);         % Time Group delay                      (sec)
% Constant
GM = 3.986005*10^14;        % Earth's universal gravitational parameter     (m^3/s^2)
We = 7.292115*10^-5;       % Earth rotation rate                           (rad/sec)
%  SOW=UTC_GPSsecond(time);
[JD] = GeLi2RuLue(time);
[~, SOW] = RuLue2GPST(JD);
[~,col] = min(abs(SOW-Toe));                     % Use closest Toe
satclock=0;
t=inf;
while(abs(satclock-t)>1e-12)
t=satclock;
c  = 299792458;
% TOS   = SOW-tr-satclock;                                           % Expected Time             (SOW : sec of GPS week)
% 
% Tk      = TOS - Toe(col);                                 % Time elaped since Toe     (SOW : sec of GPS week)
% 
% MA       = M0(col) + (sqrt(GM/a(col)^3)+delta_n(col))*Tk;    % Mean anomaly at Tk 
% 
% % Iterative solution for E 
% E_old = MA;
% dE = 1;
% while (dE > 10^-12)
%   EA = MA + e(col)*sin(E_old);                                % Eccentric anomaly
%   dE = abs(EA-E_old);
%   E_old = EA;
% end
% 
% TA = atan2(sqrt(1-e(col)^2)*sin(EA), cos(EA)-e(col));          % True anomaly
% 
% W = W0(col) + (Wdot(col)-We)*Tk - (We*Toe(col));            % Right ascension of ascending node
% 
% % Correction for orbital perturbations
% w = w0(col) + Cuc(col)*cos(2*(w0(col)+TA)) + Cus(col)*sin(2*(w0(col)+TA));                        % Argument of perigee
% r = a(col)*(1-e(col)*cos(EA)) + Crc(col)*cos(2*(w0(col)+TA)) + Crs(col)*sin(2*(w0(col)+TA));      % Radial distance
% i = i0(col) + idot(col)*Tk + Cic(col)*cos(2*(w0(col)+TA)) + Cis(col)*sin(2*(w0(col)+TA));         % Inclination
% 
% satpos_in = [r*cos(TA) r*sin(TA) 0]';                  % Satellite position vector (Earth's center in inertial frame)
% 
% % rotation matrix
% R = [cos(W)*cos(w)-sin(W)*sin(w)*cos(i) -cos(W)*sin(w)-sin(W)*cos(w)*cos(i)  sin(W)*sin(i);
%      sin(W)*cos(w)+cos(W)*sin(w)*cos(i) -sin(W)*sin(w)+cos(W)*cos(w)*cos(i) -cos(W)*sin(i);
%                sin(w)*sin(i)                    cos(w)*sin(i)                      cos(i)];
% 
% satpos = (R*satpos_in)';                               % Satellite position vector (ECEF)
% 
% %%%% Clock error computation %%%%
% F       = -4.442807633e-10; % constant        (sec/(meter)1/2)
% % 1. relative correction
% r_c = F*e(col)*sqrt(a(col))*sin(EA);
% % 2. SV clock correction
% t_sv = T0_bias(col) + T0_drift(col)*(Tk) + T0_drate(col)*(Tk^2) + r_c;
% % 3. Satellite clock bias
% satclock = t_sv-Tgd(col);
    % 计算平均角速度  
    TOS   = SOW-satclock;
    
    dt_tk = TOS - Toe(col);
    n0 = sqrt((GM) / (a(col)^3));  
    n = n0 + delta_n(col);  
      
    % 计算平近点角  
    M = M0(col) + n * dt_tk;  
      
    % 计算偏近点角  
%     E = M;  
%     Ek = 0.0;  
%     while abs(E - Ek) > 1e-14  
%         Ek = E;  
%         E = M + e(col)* sin(Ek);  
%     end  

    E0 = M;
    E1 = M + e(col) * sin(E0);
    while abs(E1 - E0) > 1e-14
        E0 = E1;
        E1 = M + e(col) * sin(E0);
    end
    E = E1;
    % 计算真近点角  
    ft = atan2(sqrt(1 - e(col) *e(col)) * sin(E), (cos(E) - e(col)));  
      
    % 计算升交距角（未经改正）  
    u = w0(col) + ft;  
      
    % 计算摄动改正项  
    r = a(col) * (1 - e(col) * cos(E));  
    i = i0(col) + idot(col) * dt_tk;  
      
    sin2u = sin(2 * u);  
    cos2u = cos(2 * u);  
    uk = u + Cus(col) * sin2u + Cuc(col) * cos2u;  
    rk = r + Crs(col) * sin2u + Crc(col) * cos2u;  
    ik = i + Cis(col) * sin2u + Cic(col) * cos2u;  
      
    % 计算卫星在轨道面坐标系中的坐标  
    x = rk * cos(uk);  
    y = rk * sin(uk);  
      
    % 计算发射时刻升交点的经度  
    L = W0(col) + (Wdot(col) - We) * dt_tk - We * Toe(col);  
      
    % 计算卫星在地固坐标系下的坐标  
    satpos(1,:) = x * cos(L) - y * cos(ik) * sin(L);  
    satpos(2,:) = x * sin(L) + y * cos(ik) * cos(L);  
    satpos(3,:) = y * sin(ik);  
    %%%% Clock error computation %%%%
    F       = -4.442807633e-10; % constant        (sec/(meter)1/2)
    % 1. relative correction
    r_c = F*e(col)*sqrt(a(col))*sin(E);
    % 2. SV clock correction
    t_sv = T0_bias(col) + T0_drift(col)*(dt_tk) + T0_drate(col)*(dt_tk^2) + r_c;
    % 3. Satellite clock bias
    satclock = t_sv-Tgd(col);
end
end