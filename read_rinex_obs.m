function [Obs,date,rcvpos]=read_rinex_obs(PathName)
fid=fopen(strcat(PathName),'rt');
if fid==-1
    msgbox("输入地址错误","警告")
    return
end
while (1)
    line = fgets(fid);
    if (line == -1)   %读取一行数据
        break;
    end
    if contains(line, 'TIME OF FIRST OBS')
        % 提取日期信息
        dateStr = strtrim(line(1:41)); % 假设日期始终位于相同的位置
        
        date = str2num(dateStr);
    end
    if contains(line, 'APPROX POSITION XYZ')
        rcvpos = str2num(line(1:40));
    end
    if (strfind(line,'END OF HEADER')~= 0)
        break;
    end
end
 %% 读取观测数据  
 line_num = 0;                                          %行数
 while feof(fid)~= 1
        line_num = line_num+1;% 历元计数
        tline = fgetl(fid);  
        chartline = char(tline) ;
         %------------------数据观测时间----------------
        time = chartline(3:21);                         %存储时间
        UTC  = sscanf( time , '%d%d%d%d%d%d' , [1,6] ); %转换为双精度时间信息，UTC时间
        search_SatNum = str2double(chartline(34:35));   %搜索到的卫星总数
        NumPRN1 = 0 ;   
        NumPRN2 = 0 ;
        for Nr = 1:search_SatNum
            chartline = char(fgetl(fid));              %逐行读取
            if (strfind(chartline,'G')~= 0)            %找到GPS卫星星座
                NumPRN1 = NumPRN1 + 1 ;
                GPS_Constellation = 'G';                 
                satNr = str2double(chartline(2:3)) ;   %读取卫星号
                Obs.GPS(line_num) .Constellation = GPS_Constellation; %将星座存入结构数组
                Obs.GPS(line_num) .PRN(NumPRN1) = satNr;                   %将卫星号存入结构数组
                Obs.GPS(line_num) .C1C(NumPRN1) = str2double(chartline(6:17)); %将GPS C1C存入结构数组
                if(isnan(Obs.GPS(line_num) .C1C(NumPRN1)))
                    Obs.GPS(line_num) .C1C(NumPRN1)=0;
                end
                Obs.GPS(line_num) .L1C(NumPRN1) = str2double(chartline(21:35)); %将GPS L1C存入结构数组
                if(isnan(Obs.GPS(line_num) .L1C(NumPRN1)))
                    Obs.GPS(line_num) .L1C(NumPRN1)=0;
                end
                Obs.GPS(line_num) .D1C(NumPRN1) = str2double(chartline(41:49)); %将GPS S1C存入结构数组
                 if(isnan(Obs.GPS(line_num) .D1C(NumPRN1)))
                    Obs.GPS(line_num) .D1C(NumPRN1)=0;
                end
                Obs.GPS(line_num) .S1C(NumPRN1) = str2double(chartline(60:65));
                if(isnan(Obs.GPS(line_num) .S1C(NumPRN1)))
                    Obs.GPS(line_num) .S1C(NumPRN1)=0;
                end
                Obs.GPS(line_num) .C1W(NumPRN1) = str2double(chartline(70:81));
                if(isnan(Obs.GPS(line_num) .C1W(NumPRN1)))
                    Obs.GPS(line_num) .C1W(NumPRN1)=0;
                end
                Obs.GPS(line_num) .S1W(NumPRN1) = str2double(chartline(92:97));
                if(isnan(Obs.GPS(line_num) .S1W(NumPRN1)))
                    Obs.GPS(line_num) .S1W(NumPRN1)=0;
                end
                Obs.GPS(line_num) .C2W(NumPRN1) = str2double(chartline(100:113));
                if(isnan(Obs.GPS(line_num) .C2W(NumPRN1)))
                    Obs.GPS(line_num) .C2W(NumPRN1)=0;
                end
                Obs.GPS(line_num) .L2W(NumPRN1) = str2double(chartline(117:131));
                if(isnan(Obs.GPS(line_num) .L2W(NumPRN1)))
                    Obs.GPS(line_num) .L2W(NumPRN1)=0;
                end
                Obs.GPS(line_num) .D2W(NumPRN1) = str2double(chartline(137:145));
                if(isnan(Obs.GPS(line_num) .D2W(NumPRN1)))
                    Obs.GPS(line_num) .D2W(NumPRN1)=0;
                end
                Obs.GPS(line_num) .S2W(NumPRN1) = str2double(chartline(156:161));
                if(isnan(Obs.GPS(line_num) .S2W(NumPRN1)))
                    Obs.GPS(line_num) .S2W(NumPRN1)=0;
                end
                Obs.GPS(line_num) .C2L(NumPRN1) = str2double(chartline(166:177));
                if(isnan(Obs.GPS(line_num) .C2L(NumPRN1)))
                    Obs.GPS(line_num) .C2L(NumPRN1)=0;
                end
                Obs.GPS(line_num) .L2L(NumPRN1) = str2double(chartline(182:195));
                if(isnan(Obs.GPS(line_num) .L2L(NumPRN1)))
                    Obs.GPS(line_num) .L2L(NumPRN1)=0;
                end
                Obs.GPS(line_num) .D2L(NumPRN1) = str2double(chartline(201:209));
                if(isnan(Obs.GPS(line_num) .D2L(NumPRN1)))
                    Obs.GPS(line_num) .D2L(NumPRN1)=0;
                end
                Obs.GPS(line_num) .S2L(NumPRN1) = str2double(chartline(220:225));
                if(isnan(Obs.GPS(line_num) .S2L(NumPRN1)))
                    Obs.GPS(line_num) .S2L(NumPRN1)=0;
                end
                Obs.GPS(line_num) .C5Q(NumPRN1) = str2double(chartline(230:241));
                if(isnan(Obs.GPS(line_num) .C5Q(NumPRN1)))
                    Obs.GPS(line_num) .C5Q(NumPRN1)=0;
                end
                Obs.GPS(line_num) .L5Q(NumPRN1) = str2double(chartline(244:259));
                if(isnan(Obs.GPS(line_num) .L5Q(NumPRN1)))
                    Obs.GPS(line_num) .L5Q(NumPRN1)=0;
                end
                Obs.GPS(line_num) .D5Q(NumPRN1) = str2double(chartline(265:273));
                if(isnan(Obs.GPS(line_num) .D5Q(NumPRN1)))
                    Obs.GPS(line_num) .D5Q(NumPRN1)=0;
                end
                 Obs.GPS(line_num) .S5Q(NumPRN1) = str2double(chartline(284:289));
                if(isnan(Obs.GPS(line_num) .S5Q(NumPRN1)))
                    Obs.GPS(line_num) .S5Q(NumPRN1)=0;
                end
                Obs.GPS(line_num) .time=UTC;
                %fprintf(fid3,' G   %d   %12.3f   %13.3f   %5.3f   %2.3f   %12.3f   %12.3f   %5.3f   %2.3f   %12.3f   %12.3f   %5.3f   %2.3f   %12.3f   %12.3f   %5.3f   %5.3f %6d\n',[Obs.GPS(line_num).PRN(NumPRN1)', Obs.GPS(line_num).C1C(NumPRN1)', Obs.GPS(line_num).L1C(NumPRN1)', Obs.GPS(line_num).D1C(NumPRN1)', Obs.GPS(line_num).S1C(NumPRN1)', Obs.GPS(line_num).C2W(NumPRN1)', Obs.GPS(line_num).L2W(NumPRN1)', Obs.GPS(line_num).D2W(NumPRN1)', Obs.GPS(line_num).S2W(NumPRN1)', Obs.GPS(line_num).C2S(NumPRN1)', Obs.GPS(line_num).L2S(NumPRN1)', Obs.GPS(line_num).D2S(NumPRN1)', Obs.GPS(line_num).S2S(NumPRN1)', Obs.GPS(line_num).C5Q(NumPRN1)', Obs.GPS(line_num).L5Q(NumPRN1)', Obs.GPS(line_num).D5Q(NumPRN1)', Obs.GPS(line_num).S5Q(NumPRN1)',Obs.GPS(line_num) .time']');  %将结构数组输入到txt文本中
            end
             if (strfind(chartline,'C')~= 0)
                NumPRN2 = NumPRN2 + 1 ;
                BDS_Constellation = 'C';
                satNr = str2double(chartline(2:3)) ; 
                Obs.BDS(line_num). Constellation = BDS_Constellation;
                Obs.BDS(line_num). PRN(NumPRN2) = satNr;
                Obs.BDS(line_num). C2I(NumPRN2) = str2double(chartline(6:17)); %Beidou C1I
                if(isnan(Obs.BDS(line_num) .C2I(NumPRN2)))
                    Obs.BDS(line_num) .C2I(NumPRN2)=0;
                end
                Obs.BDS(line_num). L2I(NumPRN2) = str2double(chartline(21:35)); %Beidou L1I
                if(isnan(Obs.BDS(line_num) .L2I(NumPRN2)))
                    Obs.BDS(line_num) .L2I(NumPRN2)=0;
                end
                Obs.BDS(line_num). D2I(NumPRN2) = str2double(chartline(41:49));
                if(isnan(Obs.BDS(line_num) .D2I(NumPRN2)))
                    Obs.BDS(line_num) .D2I(NumPRN2)=0;
                end
                Obs.BDS(line_num). S2I(NumPRN2) = str2double(chartline(60:65));
                if(isnan(Obs.BDS(line_num) .S2I(NumPRN2)))
                    Obs.BDS(line_num) .S2I(NumPRN2)=0;
                end
                Obs.BDS(line_num). C7I(NumPRN2) = str2double(chartline(70:81));
                if(isnan(Obs.BDS(line_num) .C7I(NumPRN2)))
                    Obs.BDS(line_num) .C7I(NumPRN2)=0;
                end
                Obs.BDS(line_num). L7I(NumPRN2) = str2double(chartline(86:99));
                if(isnan(Obs.BDS(line_num) .L7I(NumPRN2)))
                    Obs.BDS(line_num) .L7I(NumPRN2)=0;
                end
                Obs.BDS(line_num). D7I(NumPRN2) = str2double(chartline(105:113));
                if(isnan(Obs.BDS(line_num) .D7I(NumPRN2)))
                    Obs.BDS(line_num) .D7I(NumPRN2)=0;
                end
                Obs.BDS(line_num). S7I(NumPRN2) = str2double(chartline(124:129));
                if(isnan(Obs.BDS(line_num) .S7I(NumPRN2)))
                    Obs.BDS(line_num) .S7I(NumPRN2)=0;
                end
                Obs.BDS(line_num). C6I(NumPRN2) = str2double(chartline(134:145));
                if(isnan(Obs.BDS(line_num) .C6I(NumPRN2)))
                    Obs.BDS(line_num) .C6I(NumPRN2)=0;
                end
                Obs.BDS(line_num). L6I(NumPRN2) = str2double(chartline(149:163));
                if(isnan(Obs.BDS(line_num) .L6I(NumPRN2)))
                    Obs.BDS(line_num) .L6I(NumPRN2)=0;
                end
                Obs.BDS(line_num). D6I(NumPRN2) = str2double(chartline(169:177));
                if(isnan(Obs.BDS(line_num) .D6I(NumPRN2)))
                    Obs.BDS(line_num) .D6I(NumPRN2)=0;
                end
                Obs.BDS(line_num). S6I(NumPRN2) = str2double(chartline(188:193));
                if(isnan(Obs.BDS(line_num) .S6I(NumPRN2)))
                    Obs.BDS(line_num) .S6I(NumPRN2)=0;
                end
                Obs.BDS(line_num) .time=UTC;
                %fprintf(fid3,' C   %d   %12.3f   %12.3f   %5.3f   %2.3f   %12.3f   %13.3f   %5.3f   %2.3f   %12.3f   %13.3f   %5.3f   %2.3f   %12.3f   %13.3f   %5.3f   %2.3f   %12.3f   %13.3f   %5.3f   %2.3f   %12.3f   %12.3f   %5.3f   %2.3f %6d\n',[Obs.BDS(line_num).PRN(NumPRN2)', Obs.BDS(line_num).C2I(NumPRN2)', Obs.BDS(line_num).L2I(NumPRN2)', Obs.BDS(line_num).D2I(NumPRN2)', Obs.BDS(line_num).S2I(NumPRN2)', Obs.BDS(line_num).C7I(NumPRN2)', Obs.BDS(line_num).L7I(NumPRN2)', Obs.BDS(line_num).D7I(NumPRN2)', Obs.BDS(line_num).S7I(NumPRN2)', Obs.BDS(line_num).C6I(NumPRN2)', Obs.BDS(line_num).L6I(NumPRN2)', Obs.BDS(line_num).D6I(NumPRN2)', Obs.BDS(line_num).S6I(NumPRN2)', Obs.BDS(line_num).C1P(NumPRN2)', Obs.BDS(line_num).L1P(NumPRN2)', Obs.BDS(line_num).D1P(NumPRN2)', Obs.BDS(line_num).S1P(NumPRN2)', Obs.BDS(line_num).C5P(NumPRN2)', Obs.BDS(line_num).L5P(NumPRN2)', Obs.BDS(line_num).D5P(NumPRN2)', Obs.BDS(line_num).S5P(NumPRN2)', Obs.BDS(line_num).C7D(NumPRN2)', Obs.BDS(line_num).L7D(NumPRN2)', Obs.BDS(line_num).D7D(NumPRN2)', Obs.BDS(line_num).S7D(NumPRN2)',Obs.BDS(line_num) .time']');
             end
        end
 end
 %% 关闭文件
fclose('all'); 
end