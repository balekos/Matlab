function [syncR]=sync(Returns1,Returns2)
%% sync 2 timeserries
tic;
%m=length(Returns1(:,1)); n=length(Returns2(:,1));
Returns1((Returns1(:,2)==0),2)=100;%Secure 0 returns
Returns2((Returns2(:,2)==0),2)=100;
[Tb,~]=sortrows([Returns1;Returns2],1);%cat & sort the 2 Return Tbls
[~,~,id1] = intersect(Returns1(:,1),Tb(:,1));
[~,~,id2] = intersect(Returns2(:,1),Tb(:,1));
Tb1=zeros(size(Tb)); Tb2=zeros(size(Tb));
Tb1(:,1)=Tb(:,1); Tb1(id1,2)=Tb(id1,2);
Tb2(:,1)=Tb(:,1); Tb2(id2,2)=Tb(id2,2);
%% Assigning Prices to empty lines
C1=Tb1(:,2);
C2=Tb2(:,2);
MidPrices1=interp1(1:nnz(C1), C1(C1~=0), cumsum(C1 ~= 0), 'previous');
MidPrices1(MidPrices1==100)=0;
MidPrices2=interp1(1:nnz(C2), C2(C2~=0), cumsum(C2 ~= 0), 'previous');
MidPrices2(MidPrices2==100)=0;
Tb1(:,2)=MidPrices1;
Tb2(:,2)=MidPrices2;
syncR=cat(2,Tb1,Tb2);
syncR(1,2)=0; %eleminate NaN
syncR(:,3)=[];
toc;
