PathName="output.txt";
FileName="ABMF00GLP_R_20210010000_01D_MN.rnx";
[Obs,Nav,date,rcvpos,Year,Doy]=read_rinex(PathName,FileName);
year  = num2str(date(1));
month = num2str(date(2));
day  = num2str(date(3));
positioning(Obs,Nav,rcvpos,Doy);
