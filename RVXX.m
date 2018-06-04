function [Rvxx]=RVXX(Dall)
%% Initializing
[rows,~]=size(Dall);
Rvxx=zeros(rows,1);
Matmilisec=1/(24*60*60*1000);
Mat500milisec=Matmilisec*500;
%% Increasing Accuracy by spliting the TS integer/fract 
%edges = [-Inf, mean([Dall(2:end,1); Dall(1:end-1,1)]), +Inf];
partTS=Dall(:,1);
integTS=floor(partTS);
fractTimeStamps(:,1)=partTS-integTS;
edges = [-Inf, mean([fractTimeStamps(2:end,1); fractTimeStamps(1:end-1,1)]), +Inf];
%% Reading Timestamps
for i=1:rows
MidPrNow=Dall(i,2);
TimeST500=fractTimeStamps(i,1)+Mat500milisec;%Current fractTS+0.5milisec
%Methods:
%Find (with reduced search range)
if i+10000<rows
    yy =find(abs(fractTimeStamps(i+1:i+10000,1)-TimeST500)<0.000000000001);%or by using the tolerance: <(fractTimeStamps(1,1)+TimeST500)*eps - Adjust to the range of the numbers
else
    yy =find(abs(fractTimeStamps(i+1:end,1)-TimeST500)<0.000000000001);
end
%Indexing:
%A=fractTimeStamps(:,1)<TimeST500+0.000000001
%B=fractTimeStamps(:,1)>TimeST500;
%C=or(A,B);
%yy=find(C(i+1:i+10000)==0); %so we find the index
%ismember
%C=ismembertol(fractTimeStamps,TimeST500, 10^-15, 'DataScale', 1);
Check=isempty(yy); %checks if the element exists %Check isempty
if Check==0 %if it does
    MidPr500=Dall(yy(1),2); %assign the corresponding MidPrice Value
else %if it doesnt -> Searches the next 1000 TStamps and finds the closest element with a value equal to TimeST500
%max(A(A<TS500));    
    I=discretize(TimeST500,edges);
    %[~,idy]=min(abs(fractTimeStamps(:,1)-TimeST500));
    MidPr500=Dall(I(1),2); %then assigns the corresponding MidPrice value
end
%We now assign the 2 MidPrice Values to the Rvxx vertical vector
Rvxx(i,1)=((MidPrNow+MidPr500)/MidPrNow);
end
