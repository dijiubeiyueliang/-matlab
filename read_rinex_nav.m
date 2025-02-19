function Nav=read_rinex_nav(FileName)
clear global;
format long
fid=fopen(strcat(FileName),'rt');
if fid==-1
    msgbox("输入地址错误","警告")
    return
end
 while(1)
     line1=fgets(fid);
     if line1==-1
         break
     end
%     if findstr(line1,"RINEX VERSION / TYPE")
%         NAVHead.version=str2num(line1(6:10));
%     end
%     if findstr(line1,"PGM / RUN BY / DATE")
%         NAVHead.PGM=line1(1:18);
%         NAVHead.RUNBY=line1(21:23);
%         NAVHead.DATE=line1(41:56);
%     end
%     if findstr(line1,"ION ALPHA")
%         NAVHead.alpha(1)=str2num(line1(5:14));
%         NAVHead.alpha(2)=str2num(line1(17:26));
%         NAVHead.alpha(3)=str2num(line1(28:38));
%         NAVHead.alpha(4)=str2num(line1(40:50));
%     end
%     if findstr(line1,"ION BETA")
%         NAVHead.beta(1)=str2num(line1(5:14));
%         NAVHead.beta(2)=str2num(line1(17:26));
%         NAVHead.beta(3)=str2num(line1(28:38));
%         NAVHead.beta(4)=str2num(line1(41:50));
%     end
%     if findstr(line1,"DELTA-UTC: A0,A1,T,W")
%         NAVHead.utc(1)=str2num(line1(5:22));
%         NAVHead.utc(2)=str2num(line1(24:41));
%         NAVHead.utc(3)=str2num(line1(45:50));
%         NAVHead.utc(4)=str2num(line1(56:59));
%     end
     if (strfind(line1,'END OF HEADER')~= 0)
        break;
     end
 end
    %读内部数据
    i=0;
    j=0;
    while(feof(fid)==0)
        NumPRN1 = 0 ;   
        NumPRN2 = 0 ;
        line1=char(fgetl(fid));
        if (strfind(line1,'G')~= 0)
        i=i+1;
        NumPRN1 = NumPRN1 + 1 ;
        Nav.GPS(i).Constellation='G';
        Nav.GPS(i).prn(NumPRN1)=str2num(line1(2:3));
        Nav.GPS(i).Year(NumPRN1)=str2num(line1(5:8));
        Nav.GPS(i).Month(NumPRN1)=str2num(line1(10:11));
        Nav.GPS(i).Day(NumPRN1)=str2num(line1(13:14));
        Nav.GPS(i).Hour(NumPRN1)=str2num(line1(16:17));
        Nav.GPS(i).Minute(NumPRN1)=str2num(line1(19:20));
        Nav.GPS(i).Second(NumPRN1)=str2num(line1(22:23));
   %     Time=[Year,Month,Day,Hour,Minute,Second];
    %    NAV(i).Time=Time;
        Nav.GPS(i).deviate(NumPRN1)=str2num(line1(24:42));
        Nav.GPS(i).drift(NumPRN1)=str2num(line1(43:61));
        Nav.GPS(i).rate(NumPRN1)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.GPS(i).IODE(NumPRN1)=str2num(line1(5:23));
        Nav.GPS(i).Crs(NumPRN1)=str2num(line1(24:42));
        Nav.GPS(i).dn(NumPRN1)=str2num(line1(43:61));
        Nav.GPS(i).M0(NumPRN1)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.GPS(i).Cuc(NumPRN1)=str2num(line1(5:23));
        Nav.GPS(i).e(NumPRN1)=str2num(line1(24:42));
        Nav.GPS(i).Cus(NumPRN1)=str2num(line1(43:61));
        Nav.GPS(i).sqrtA(NumPRN1)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.GPS(i).TOE(NumPRN1)=str2num(line1(5:23));
        Nav.GPS(i).Cic(NumPRN1)=str2num(line1(24:42));
        Nav.GPS(i).OMU(NumPRN1)=str2num(line1(43:61));
        Nav.GPS(i).Cis(NumPRN1)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.GPS(i).i0(NumPRN1)=str2num(line1(5:23));
        Nav.GPS(i).Crc(NumPRN1)=str2num(line1(24:42));
        Nav.GPS(i).omega(NumPRN1)=str2num(line1(43:61));
        Nav.GPS(i).OMEGAdot(NumPRN1)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.GPS(i).idt(NumPRN1)=str2num(line1(5:23));
        Nav.GPS(i).cflgl2(NumPRN1)=str2num(line1(24:42));
        Nav.GPS(i).weekno(NumPRN1)=str2num(line1(43:61));
        Nav.GPS(i).pflgl2(NumPRN1)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.GPS(i).svacc(NumPRN1)=str2num(line1(5:23));
        Nav.GPS(i).svhlth(NumPRN1)=str2num(line1(24:42));
        Nav.GPS(i).tgd(NumPRN1)=str2num(line1(43:61));
        Nav.GPS(i).iodc(NumPRN1)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.GPS(i).transmit(NumPRN1)=str2num(line1(5:23));
        try
        Nav.GPS(i).fitint(NumPRN1)=str2num(line1(24:42));
        catch
        Nav.GPS(i).transmit(NumPRN1)=0;
        end
        end
        if (strfind(line1,'C')~= 0)
        j=j+1;
        NumPRN2 = NumPRN2 + 1 ;
        Nav.BDS(j).Constellation='C';
        Nav.BDS(j).prn(NumPRN2)=str2num(line1(2:3));
        Nav.BDS(j).Year(NumPRN2)=str2num(line1(5:8));
        Nav.BDS(j).Month(NumPRN2)=str2num(line1(10:11));
        Nav.BDS(j).Day(NumPRN2)=str2num(line1(13:14));
        Nav.BDS(j).Hour(NumPRN2)=str2num(line1(16:17));
        Nav.BDS(j).Minute(NumPRN2)=str2num(line1(19:20));
        Nav.BDS(j).Second(NumPRN2)=str2num(line1(22:23));
   %     Time=[Year,Month,Day,Hour,Minute,Second];
    %    NAV(i).Time=Time;
        Nav.BDS(j).deviate(NumPRN2)=str2num(line1(24:42));
        Nav.BDS(j).drift(NumPRN2)=str2num(line1(43:61));
        Nav.BDS(j).rate(NumPRN2)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.BDS(j).IODE(NumPRN2)=str2num(line1(5:23));
        Nav.BDS(j).Crs(NumPRN2)=str2num(line1(24:42));
        Nav.BDS(j).dn(NumPRN2)=str2num(line1(43:61));
        Nav.BDS(j).M0(NumPRN2)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.BDS(j).Cuc(NumPRN2)=str2num(line1(5:23));
        Nav.BDS(j).e(NumPRN2)=str2num(line1(24:42));
        Nav.BDS(j).Cus(NumPRN2)=str2num(line1(43:61));
        Nav.BDS(j).sqrtA(NumPRN2)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.BDS(j).TOE(NumPRN2)=str2num(line1(5:23));
        Nav.BDS(j).Cic(NumPRN2)=str2num(line1(24:42));
        Nav.BDS(j).OMU(NumPRN2)=str2num(line1(43:61));
        Nav.BDS(j).Cis(NumPRN2)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.BDS(j).i0(NumPRN2)=str2num(line1(5:23));
        Nav.BDS(j).Crc(NumPRN2)=str2num(line1(24:42));
        Nav.BDS(j).omega(NumPRN2)=str2num(line1(43:61));
        Nav.BDS(j).OMEGAdot(NumPRN2)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.BDS(j).idt(NumPRN2)=str2num(line1(5:23));
        Nav.BDS(j).cflgl2(NumPRN2)=str2num(line1(24:42));
        Nav.BDS(j).weekno(NumPRN2)=str2num(line1(43:61));
        try
        Nav.BDS(j).pflgl2(NumPRN2)=str2num(line1(62:80));
        catch
            Nav.BDS(j).pflgl2(NumPRN2)=0;
        end
        line1=fgetl(fid);
        Nav.BDS(j).svacc(NumPRN2)=str2num(line1(5:23));
        Nav.BDS(j).svhlth(NumPRN2)=str2num(line1(24:42));
        Nav.BDS(j).tgd(NumPRN2)=str2num(line1(43:61));
        Nav.BDS(j).iodc(NumPRN2)=str2num(line1(62:80));
        line1=fgetl(fid);
        Nav.BDS(j).transmit(NumPRN2)=str2num(line1(5:23));
        Nav.BDS(j).fitint(NumPRN2)=str2num(line1(24:42));
        end
    end
end
    


