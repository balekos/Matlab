function [Returns]=returns(Dall)
%% Calculates Returns
%Assigns Prices of existing TSs
tic;
% [offset,dst]=tzoffset(datetime(date,'InputFormat','yyyyMMdd','TimeZone','America/New_York'));
% Offset=abs(offset)+abs(dst);
% TSclose=datenum(datetime(strcat(date,' 16:00:00'),'InputFormat','yyyyMMdd HH:mm:SS')+Offset);
Mat500ms=500*(1/(24*60*60*1000)); %Serial Mtlb time 500ms
TSper500=(Dall(1,1):Mat500ms:Dall(end,1))'; %TSs per 500ms
% while TSper500(end,1)>TSclose
%     TSper500(end,1)=[];
% end
[~,idall,its] = intersect(Dall(:,1),TSper500(:,1)); %finds common TSs
TSper500(its,2)=Dall(idall,2); %Assigns Corresponding MidPrs
%% Assigns Prices of non existing TSs
 [k,~]=sortrows([Dall;TSper500],1);%Creates a joined matrix
 MPr=k(:,2); %creates Vector with midprices
%assigns the previous available price to the zero elements
 Prices=interp1(1:nnz(MPr), MPr(MPr~=0), cumsum(MPr~= 0), 'previous');
 k(:,2)=Prices;%fills the prices
 [~,ik,itimes] = intersect(k(:,1),TSper500(:,1)); %finds the common TSs
 TSper500(itimes,2)=k(ik,2);%creates the full TS,MidPr table
 %% Calculates Returns
Subz=diff(TSper500(:,2));
Vector=circshift(TSper500(:,2),1); %creates the shifted MidPr vector
Vector(1)=[]; %1st price is unknown(0)
Returns(:,1)=TSper500(2:end,1);
Returns(:,2)=(Subz./Vector); %element/element for returns
toc;
