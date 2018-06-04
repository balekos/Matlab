function [Dall]=read_file(symbol,date)
%% Reading File
tic;
filename=strcat('C:\Users\USER\MATLAB\DALL_',symbol,'_',date);
gunzip(strcat(filename,'.gz'));%Unzip
fid=fopen(filename,'rb');%open file

Elements=dir(filename);
Bytes=Elements.bytes; %file is 756mb 756980368bytes large
Lines=Bytes/764; % DALL's number of rows 764=bytes/line
DALL=zeros(Lines,127);%Initializing
MatTimeOffset=datenum('01-Jan-1970'); %719529 matlab offset time

    for i=1:Lines
    DALL(i,1) =fread(fid,1,'int32');
    DALL(i,2)=fread(fid,1,'uint64');
    DALL(i,3:4)=MatTimeOffset+(fread(fid,2,'uint64'))/86400000000000;
    DALL(i,5)=fread(fid,1,'uint32');
    DALL(i,6)=fread(fid,1,'double',29*8);
    DALL(i,7)=fread(fid,1,'uint32',29*4);
    DALL(i,8)=fread(fid,1,'double',29*8);
    DALL(i,9)=fread(fid,1,'uint32',29*4);
    DALL(i,10)=fread(fid,1,'double');
    DALL(i,11)=fread(fid,1,'uint32');
    end
fclose(fid);
%% Clearing Data
%Reg Trading Hours 9:30-16:00 EST /-5UTC / Local was +2UTC
[offset,dst]=tzoffset(datetime(date,'InputFormat','yyyyMMdd','TimeZone','America/New_York'));
Offset=abs(offset)+abs(dst);
TSopen=datenum(datetime(strcat(date,' 09:30:00'),'InputFormat','yyyyMMdd HH:mm:SS')+Offset);
TSclose=datenum(datetime(strcat(date,' 16:00:00'),'InputFormat','yyyyMMdd HH:mm:SS')+Offset);
% TSopen=datenum(strcat(date,' 14:30:00'),' yyyymmdd HH:MM:SS');
% TSclose=datenum(strcat(date,' 21:00:00'),' yyyymmdd HH:MM:SS');
toDlt=DALL(:,3)<TSopen | DALL(:,3)>TSclose;
DALL(toDlt, :)=[];
%% Call the OPRS function feeding DALL
[Timestamps,MidPr,~]=OPRS_MakeCubePlotMin_02(DALL(:,3),DALL(:,8),DALL(:,6));
Dall=cat(2,Timestamps,MidPr); %Concatenate the 2 vectors
toc;