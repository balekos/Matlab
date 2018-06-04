function [x]=portOpt(site1,site2,site3,site4)
% 1st site
Skiti=xlsread(strcat(Skiti,'0316.xlsx')); %in kwh/kwp 99.875kwp
Nan1=isnan(Skiti); Skiti(Nan1)=0;
Skiti(:,[2,4])=[];
% 2nd site
Iwannina=xlsread(strcat(site2,'0316.xlsx')); %in kwh/kwp 99.6kwp
Nan2=isnan(Iwannina); Iwannina(Nan2)=0;
Iwannina(:,[2,4])=[];
% 3rd site
Gkorthna=xlsread(strcat(site3,'0316.xlsx'));
KwpGko=79.81;
Nan3=isnan(Gkorthna); Gkorthna(Nan3)=0;
GkoKwp=Gkorthna(:,[1, 3, 5])./KwpGko;
Gkorthna(:,1)=GkoKwp(:,1); Gkorthna(:,3)=GkoKwp(:,2); Gkorthna(:,5)=GkoKwp(:,3);
Gkorthna(:,[2,4])=[];
% 4rth site
Amfikleia=xlsread(strcat(site4,'0316.xlsx'));
KwpAmf=499.44;
Nan4=isnan(Amfikleia); Amfikleia(Nan4)=0;
Amfkwp=Amfikleia(:,[1,3,5])./KwpAmf;
Amfikleia(:,1)=Amfkwp(:,1); Amfikleia(:,3)=Amfkwp(:,2); Amfikleia(:,5)=Amfkwp(:,3);
Amfikleia(:,[2,4])=[];
%% Dealing with missing Data
%1st site
[x,y,~]=find((Skiti(:,:)==0));%for the 2nd and 3rd years
miss1=x(y==1); %for the 1st year
Skiti(miss1,1)=mean(Skiti(1:365,1)); %gia ton 1o xrono idsk=idsk'; LastY=x-365;
miss2=x(y==2); %for the 2nd year
Skiti(miss2,2)=(Skiti(miss2,1)+Skiti(miss2,3))./2;
miss3=x(y==3); %for the 3rd year
Skiti(miss3,3)=(Skiti(miss3,1)+Skiti(miss3,2))./2;
Skiti=[Skiti(:,1);Skiti(:,2);Skiti(:,3)];
RSkiti=price2ret(Skiti,[],'Periodic');
%2nd Site Iwannina
[k,o,~]=find((Iwannina(:,:)==0));%for the 2nd and 3rd years
missin1=k(o==1); %for the 1st year
Iwannina(missin1,1)=mean(Iwannina(1:365,1)); %gia ton 1o xrono idsk=idsk'; LastY=x-365;
missin2=k(o==2); %for the 2nd year
Iwannina(missin2,2)=(Iwannina(missin2,1)+Iwannina(missin2,3))./2;
missin3=k(o==3); %for the 3rd year
Iwannina(missin3,3)=(Iwannina(missin3,1)+Iwannina(missin3,2))./2;
Iwannina=[Iwannina(:,1);Iwannina(:,2);Iwannina(:,3)];
RIwannina=price2ret(Iwannina,[],'Periodic');
%3rth Site Gortyna
[e,r,~]=find((Gkorthna(:,:)==0));%for the 2nd and 3rd years
md1=e(r==1); %for the 1st year
Gkorthna(md1,1)=mean(Gkorthna(1:365,1)); %gia ton 1o xrono idsk=idsk'; LastY=x-365;
md2=e(r==2); %for the 2nd year
Gkorthna(md2,2)=(Gkorthna(md2,1)+Gkorthna(md2,3))./2;
md3=e(r==3); %for the 3rd year
Gkorthna(md3,3)=(Gkorthna(md3,1)+Gkorthna(md3,2))./2;
Gkorthna=[Gkorthna(:,1);Gkorthna(:,2); Gkorthna(:,3)];
RGkorthna=price2ret(Gkorthna,[],'Periodic');
%4rd Site Amfikleia-(Larisa)
[m,n,~]=find((Amfikleia(:,:)==0));%for the 2nd and 3rd years
mis1=m(n==1); %for the 1st year
Amfikleia(mis1,1)=mean(Amfikleia(1:365,1)); %gia ton 1o xrono idsk=idsk'; LastY=x-365;
mis2=m(n==2); %for the 2nd year
Amfikleia(mis2,2)=(Amfikleia(mis2,1)+Amfikleia(mis2,3))./2;
mis3=m(n==3); %for the 3rd year
Amfikleia(mis3,3)=(Amfikleia(mis3,1)+Amfikleia(mis3,2))./2;
Amfikleia=[Amfikleia(:,1);Amfikleia(:,2); Amfikleia(:,3)];
RAmfikleia=price2ret(Amfikleia,[],'Periodic');
%Removing outliers:
Q1Sk=quantile(Skiti,0.25); Q3Sk=quantile(Skiti,0.75);
InterQRSk=Q3Sk-Q1Sk;
RSkiti(RSkiti>1.5*InterQRSk)=mean(RSkiti);
Q1Iw=quantile(Iwannina,0.25); Q3Iw=quantile(Iwannina,0.75);
InterQRIw=Q3Iw-Q1Iw;
RIwannina(RIwannina>1.5*InterQRIw)=mean(RIwannina);
Q1Gko=quantile(Gkorthna,0.25); Q3Gko=quantile(Gkorthna,0.75);
InterQRGko=Q3Gko-Q1Gko;
RGkorthna(RGkorthna>1.5*InterQRGko)=mean(RGkorthna);
Q1Amf=quantile(Amfikleia,0.25); Q3Amf=quantile(Amfikleia,0.75);
InterQRAmf=Q3Amf-Q1Amf;
RAmfikleia(RAmfikleia>1.5*InterQRAmf)=mean(RAmfikleia);
%% Descriptive Statistics - 4 Central Moments
%Central Tendency
% ExcessReturns
SkitiExR=RSkiti(:,1)-mean(RSkiti(:,1));
IwanninaExR=RIwannina(:,1)-mean(RIwannina(:,1));
GkorthnaExR=RGkorthna(:,1)-mean(RGkorthna(:,1));
%exei 3 dedomena parapanw h amfikleia gia kapoio logo:/
RAmfikleia(1095:end)=[];
AmfikleiaExR=RAmfikleia(:,1)-mean(RAmfikleia(:,1));
%site 1 - Skiti 
%Metra Thesis
DiamesosSk=median(RSkiti(:,1)); EpikratousaTimSk=mode(RSkiti(:,1));
%Metra Diasporas
EurosSk=max(RSkiti(:,1))-min(RSkiti(:,1));
MeanRSk=sum(RSkiti(:,1))./length(RSkiti(:,1)-1); %Mean Annual Returns
VarSk=sum(RSkiti.^2)/length(RSkiti(:,1)-1); StdSk=sqrt(VarSk);
skewSk=skewness(RSkiti(:,1)); kurtSk=kurtosis(RSkiti(:,1));%na ta ypologisw me tous tupous tous

%site 2
EurosIw=max(RIwannina(:,1))-min(RIwannina(:,1));
MeanRIw=sum(RIwannina(:,1))./length(RIwannina(:,1)-1); %Mean Annual Returns
VarIw=sum(RIwannina.^2)/length(RIwannina(:,1)); StdIw=sqrt(VarIw);
skewIw=skewness(RIwannina(:,1)); kurtIw=kurtosis(RIwannina(:,1));

%site 3
EurosGko=max(RGkorthna(:,1))-min(RGkorthna(:,1));
MeanRGko=sum(RGkorthna(:,1))./length(RGkorthna(:,1)-1); %Mean Annual Returns
VarGko=sum(RGkorthna.^2)/length(RGkorthna(:,1)); StdGko=sqrt(VarGko);
skewGko=skewness(RGkorthna(:,1)); kurtGko=kurtosis(RGkorthna(:,1));

%site 4
EurosAmf=max(RAmfikleia(:,1))-min(RAmfikleia(:,1));
MeanRAmf=sum(RAmfikleia(:,1))./length(RAmfikleia(:,1)-1); %Mean Annual Returns
VarAmf=sum(RAmfikleia.^2)/length(RAmfikleia(:,1)-1); StdAmf=sqrt(VarAmf);
skewAmf=skewness(RAmfikleia(:,1)); kurtAmf=kurtosis(RAmfikleia(:,1));
DescriptiveStatistics=table([EurosSk; MeanRSk; StdSk; skewSk; kurtSk],[EurosIw; MeanRIw; StdIw; skewIw; kurtIw],[EurosGko; MeanRGko; StdGko; skewGko; kurtGko],[EurosAmf; MeanRAmf; StdAmf; skewAmf; kurtAmf],'VariableNames',{' Skiti','  Iwannina','  Gkorthna','  Amfikleia'},'RowNames',{'Euros','M.O.','StDev',' Skew','Kurtosis'})
% Xrhsima stoixeia gia thn Xrhmatooikonomikh Meleth
TotalOutputSk=sum(Skiti);
VarSk=var(Skiti); stdSk=sqrt(VarSk); ArithmosParSk=length(Skiti);
TotalOutputIw=sum(Iwannina);
VarIw=var(Iwannina); stdIw=sqrt(VarIw); ArithmosParIw=length(Iwannina);
TotalOutputGko=sum(Gkorthna);
VarGko=var(Gkorthna); stdGko=sqrt(VarGko); ArithmosParGko=length(Gkorthna);
TotalOutputAmf=sum(Amfikleia);
VarAmf=var(Amfikleia); stdAmf=sqrt(VarAmf); ArithmosParAmf=length(Amfikleia);
Statistics=table([TotalOutputSk; stdSk; ArithmosParSk],[TotalOutputIw; stdIw; ArithmosParIw],[TotalOutputGko; stdGko; ArithmosParGko],[TotalOutputAmf; stdAmf; ArithmosParAmf],'VariableNames',{' Skiti','  Iwannina','  Gkorthna','  Amfikleia'},'RowNames',{'T_Output','Variance',' NoObs'})

%% Sync Data
% Data are synced

%% VarCovar Matrix
% ExcessReturns//Sample Error
ExRMtr=[SkitiExR,IwanninaExR,GkorthnaExR,AmfikleiaExR];
CovarMtr=(ExRMtr'*ExRMtr)./length(ExRMtr);
fprintf(' O pinakas Diakumansewn einai:');
CovMtr=table(CovarMtr(:,1),CovarMtr(:,2),CovarMtr(:,3),CovarMtr(:,4),'VariableNames',{'Skiti','Iwannina','Gkorthna','Amfikleia'},'RowNames',{'Skiti','Iwannina','Gkorthna','Amfikleia'})
% Correlation Matrix
StdVect=[StdSk;StdIw;StdGko;StdAmf];
Stdvs=StdVect*StdVect';
CorMtr=CovarMtr./Stdvs;
fprintf(' O pinakas Susxetisewn einai:');
CorelMtr=table(CorMtr(:,1),CorMtr(:,2),CorMtr(:,3),CorMtr(:,4),'VariableNames',{'Skiti','Iwannina','Gkorthna','Amfikleia'},'RowNames',{'Skiti','Iwannina','Gkorthna','Amfikleia'})


%% Portfolio weights
% 1st case: Equally weighted port
wSk=1/3; wIw=1/3; wGko=1/3; wAmf=1/3;
%weights=wSk+wIw+wGko+wAmf;
Weights=[wSk,wIw,wGko,wAmf];
returns=[MeanRSk, MeanRIw, MeanRGko, MeanRAmf];
PortR=Weights*returns';
PortVar=sqrt(Weights*CovarMtr*Weights');
%% Optimization
%Min Var Port
% ObjFunction=sqrt([x1,x2,x3,x4]*CovarMtr*[x1,x2,x3,x4])';
x0=[0,0,1,0]; lb=[0 0 0 0]; ub=[1 1 1 1]; Aineq=[]; bineq=[]; %x=[w1,w2,w3,w4];
Aeq=[1 1 1 1]; beq=1;
MinVarWeights=fmincon(@(x) sqrt([x(1),x(2),x(3),x(4)]*CovarMtr*[x(1),x(2),x(3),x(4)]'),x0,Aineq,bineq,Aeq,beq,lb,ub);
%H apodosh kai h Diakumansh tou MinVariance Portfolio 8a einai
MinVarReturn=MinVarWeights*returns';
MinVarVariance=sqrt(MinVarWeights*CovarMtr*MinVarWeights');
fprintf('H apodosh tou Minimum Variance Xartofulakiou tha einai:'); fprintf('%d', MinVarReturn); fprintf(' ,enw h diakumansh: '); fprintf('%d', MinVarVariance);

%Max informationRatio Port
% ObjFun=PortR/PortVar; ([x(1),x(2),x(3),x(4)]*returns')/sqrt([x(1),x(2),x(3),x(4)]*CovarMtr*[x(1),x(2),x(3),x(4)]'
% MaxRatioWeights=fmincon(ObjFun,x0,Aineq,bineq,Aeq,beq,lb,ub);
MaxRatioWeights=fmincon(@(x) -(([x(1),x(2),x(3),x(4)]*returns')/sqrt([x(1),x(2),x(3),x(4)]*CovarMtr*[x(1),x(2),x(3),x(4)]')),x0,Aineq,bineq,Aeq,beq,lb,ub);
MaxRatioReturn=MaxRatioWeights*returns';
MaxRatioVariance=sqrt(MaxRatioWeights*CovarMtr*MaxRatioWeights');
fprintf('H apodosh kai h diakumansh tou Max Ratio Xartofulakiou tha einai:'); fprintf('%d','%d', MaxRatioReturn, MaxRatioVariance);
% Ti kataferame:
ReturnMtr=table([PortR;PortVar],[MinVarReturn;MinVarVariance],[MaxRatioReturn; MaxRatioVariance],'VariableNames',{'Eq_Weighted','MinVariance','MaxRatioPort'},'RowNames',{'Apodosh','Diakuman'})

fprintf('H apodosh enos xartofulakiou poy exoume isomeros katanhmei ta barh htan: ');
fprintf('%d',PortR); fprintf(' kai h diakumnash: '); fprintf('%d',PortVar);
fprintf('\n enw h apodosh tou xartofulakiou elaxisths diakumansh einai: '); fprintf('%d',MinVarReturn); fprintf(' Enw h diakumansh: '); fprintf('%d', MinVarVariance);
fprintf('\n Telos h apodosh tou xartofulakiou pou megistopoiei to logo apodoshs-diakumansh einai: '); fprintf('%d', MaxRatioReturn); fprintf(' Enw h diakumansh: '); fprintf('%d', MaxRatioVariance);

%% Efficient Frontier
%Gradient/Lagrange Multipliers/minimization:
% Unity vector..must have same length as zbar
unity = ones(length(returns),1);
A = unity'*CovarMtr^(-1)*unity;
B = unity'*CovarMtr^(-1)*returns';
C = returns*CovarMtr^(-1)*returns';
D = A*C-B^2;
% Efficient Frontier
mu = (1:300)/10;
% Plot Efficient Frontier
minvar = ((A*mu.^2)-2*B*mu+C)/D;
minstd = sqrt(minvar);
plot(minstd,mu,Stdvs,returns,'*')
title('Efficient Frontier with Individual Securities','fontsize',18)
ylabel('Expected Return (%)','fontsize',18)
xlabel('Standard Deviation (%)','fontsize',18)
