function positioning(Obs,Nav,rcvpos,Doy)
stt     = 0;   
stp     = 24;
int     = 30;
len_matrix = (stp - stt) * 3600 - 1;
gpscons
userpos.llh          = nan(len_matrix,3);  % Lat Long height
userpos.xyz          = nan(len_matrix,3);  % ECEF X Y Z
userpos.xyz_ture     = nan(len_matrix,3);
userpos.bs           = nan(len_matrix,32); % Satellite clock bias
userpos.br           = nan(len_matrix,1);  % Receiver clock bias
userpos.elevation    = nan(len_matrix,32); % elevation angle
disterr.horizontal   = nan(len_matrix,1);  % Positioning error: Horizontal
disterr.EW           = nan(len_matrix,1);  % Positioning error: East-West
disterr.NS           = nan(len_matrix,1);  % Positioning error: North-South
disterr.height       = nan(len_matrix,1);  % Positioning error: Heigtht
model.tropo          = nan(len_matrix,32); % Tropospheric model
model.iono           = nan(len_matrix,32); % Ionospheric model
model.hdop           = nan(len_matrix,1); % HDOP
% Initial USER position
x0   = zeros(4,1);
xyz0 = x0(1:3);    % initial position
br   = x0(4);      % initial bias
for i=1:length(Obs.GPS)
    PRN   = Obs.GPS(i).PRN;             % Check satellite number (PRN)
    
    if length(PRN)< 4
        continue;
    end
    SOD=Obs.GPS(i).time(4)*3600+Obs.GPS(i).time(5)*60+Obs.GPS(i).time(6);
%     C1=Obs.GPS(i).C1W;
f1 = 1575.42 * 1e6;
f2 = 1227.60 * 1e6;
C1=f1^2/(f1^2-f2^2)*Obs.GPS(i).C1W-f2^2/(f1^2-f2^2)*Obs.GPS(i).C2W;
    Time=Obs.GPS(i).time;
    satpos        = nan(3,length(PRN));
    satclock      = nan(length(PRN),1);
    for ii = 1:length(PRN)
        [satpos(1:3,ii),satclock(ii)] = satpos_xyz_sbias(PRN(ii),Nav,Time,C1(ii));
    end
    
    if length(satclock(~isnan(satclock))) < 4
        continue;
    end % Check number of satellite
    delay.tropo   = ones(length(PRN),1);
     % initial dx
    dx   = x0 +inf; % initial differential xyz
    stop = 0;
    while norm(dx(1:3,1)) > 10^-3 % Difference of positioning
        stop = stop+1; if stop==245;break;end % iterative divergent
        [elev,~] = calculate_elevation(satpos,xyz0);
        userlla  = xyz2lla(xyz0(1),xyz0(2),xyz0(3));
        [d_hyd,d_wet] = EstimateTropDalay(userlla(1),userlla(3),str2double(Doy));
        delay.tropo = (d_hyd + d_wet).*(1.001./sqrt(0.002001 + sind(elev).^2));
%         for ii = 1:length(PRN)
%             dIon_klob(ii) = klobuchar_model(userlla(1),userlla(2),elev(ii),SOD); % nano sec  newklob nav.ionprm
%         end
%         delay.iono = c.*dIon_klob';  % delay from Klobuchar model
%         delay.tropo=Saastamoinen(userlla(1),userlla(3))*ones(length(PRN),1);
        if stop > 1
            elev_m          = elevcut(elev,elev,elev_mask);
            C1_m            = elevcut(C1',elev,elev_mask);
            satpos_m        = elevcut(satpos',elev,elev_mask);
            sclockbias_m    = elevcut(satclock,elev,elev_mask);
            d_tropo         = elevcut(delay.tropo,elev,elev_mask);
%             d_iono          = elevcut(delay.iono,elev,elev_mask);
            PRN_m           = elevcut(PRN',elev,elev_mask);
        else
            delay.tropo     = 0.*elev;
%             delay.iono      = 0.*elev;
            elev_m          = elevcut(elev,elev,0);
            C1_m            = elevcut(C1',elev',0);
            satpos_m        = elevcut(satpos',elev,0);
            sclockbias_m    = elevcut(satclock,elev,0);
            d_tropo         = elevcut(delay.tropo,elev,0);
%             d_iono          = elevcut(delay.iono,elev,0);
            PRN_m           = elevcut(PRN',elev,0);
        end
        cP1 =   nan(1,length(C1_m));     
        if length(cP1)~=length(sclockbias_m);break;end % Check number of satellite
        temp=c.*sclockbias_m;
        cP1 =   C1_m  +c.*sclockbias_m- d_tropo ;
        ctest = sqrt( sum((ones(length(satpos_m),1)*rcvpos - satpos_m).^2,2)); %Ref distance
        cError = cP1-ctest;
        cP1(abs(cError)>10^7) = [];
        satpos_m(abs(cError)>10^7,:) = [];
        bs=sclockbias_m;
        sclockbias_m(abs(cError)>10^7,:) = [];
        if length(satpos_m) < 4 || length(cP1) < 4 || length(cP1)~=length(satpos_m)
            break;
        end % Check number of satellite
        satpos_cor = nan(3,length(satpos_m));
         v1 = xyz0(:)*ones(1,length(satpos_m))-satpos_m';
        range1 = sqrt( sum(v1.^2) );%distance
        for iii = 1:length(satpos_m)
            dtflight = (range1(iii)-br)/c;
            satpos_cor(:,iii) = FlightTimeCorr(satpos_m(iii,:)',dtflight); % REF
        end
        % Calculate elevation angle
        % Calculate line of sight vectors and ranges from satellite to xo
        v = xyz0(:)*ones(1,length(satpos_cor),1)-satpos_cor;
        range = sqrt( sum(v.^2) );%distance
        v = v./(ones(3,1)*range); % line of sight unit vectors from sv to xo
        
        % Calculate the a-priori range residual
        prHat = range(:);
        L = cP1 - prHat+br;                    % matrix L
        B = [v',ones(length(satpos_cor),1)]; % matrix B
        
        % LSE solution
        dx = (inv(B'*B))*B'*L;
        xyz0 = xyz0(:)+dx(1:3);
        br   = dx(4);
        V=L-B*dx;
        omega0_2=V'*V/(length(PRN_m)-4);
        P=omega0_2./(B'*B);
        G = inv(B'*B);
    end
    HDOP(i) = sqrt(G(1,1) + G(2,2));
        
%         userpos.hdop(i)            = HDOP;            % USER HDOP
        userpos.xyz(i,1:3)         = xyz0';            % USER position in xyz
        userpos.xyz_ture(i,1:3)=xyz0'-rcvpos;
        userpos.llh(i,1:3)         = xyz2lla(xyz0(1),xyz0(2),xyz0(3)); % USER position in LLA
        userpos.bs(i,PRN_m)        = bs;    % Satellite clock bias (sec)
        userpos.br(i)              = br;              % Receiver clock bias (m)
        userpos.elevation(i,PRN_m) = elev_m;          % elevation angle (degree)
%         model.tropo(i,PRN_m)       = d_tropo;         % Tropo delay (m)
%         [disterr.horizontal(i),~]   = lldistm([userlla(1) userlla(2)],[refpos_lla(1) refpos_lla(2)]);           % Horizontal
%         [disterr.EW(i),~]           = lldistm([userlla(1) refpos_lla(2)],[refpos_lla(1) refpos_lla(2)]);        % EW
%         [disterr.NS(i),~]           = lldistm([refpos_lla(1) userlla(2)],[refpos_lla(1) refpos_lla(2)]);        % NS
%         disterr.height(i)           = userlla(3)-refpos_lla(3);                                                 % Vertical
end
end