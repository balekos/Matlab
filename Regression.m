function []=Regression(SyncedR)
%% Data Analysis
%Statistics
n=size(SyncedR,1);
% Central Moments
RvxxMean=sum(SyncedR(:,2))/n; RvxxVar=var(SyncedR(:,2));
RspyMean=sum(SyncedR(:,3))/n; RspyVar=var(SyncedR(:,3));
Stdvxx=sqrt(RvxxVar); Stdspy=sqrt(RspyVar);
Skew1=skewness(SyncedR(:,3)); Skew2=skewness(SyncedR(:,2));
Kurt1=kurtosis(SyncedR(:,3)); Kurt2=kurtosis(SyncedR(:,2)); 
%Diasthmata Empistosynhs
%
Covariance=cov(SyncedR(:,3),SyncedR(:,2));
% Covariance=sum((SyncedR(:,3)-RspyMean)'*(SyncedR(:,2)-RvxxMean)./n);
Correlation=corrcoef(SyncedR(:,3),SyncedR(:,2)); %with 500ms lag we have a better correl
% Correlation=Covariance/Stdvxx*Stdspy;
%% Regression
% Me8odos pou mhdenizei tis merikes paragwgous gia nabrei oliko elaxisto
Sx=sum(SyncedR(:,3)); Sy=sum(SyncedR(:,2));
Sxx=sum(SyncedR(:,3).^2); Syy=sum(SyncedR(:,2).^2);
Sxy=sum(SyncedR(:,3).*SyncedR(:,2));
Slope=(n*Sxy-Sx*Sy)/(n*Sxx-Sx^2);
Yintercept=RvxxMean-Slope*RspyMean;
SE=(1/n*(n-2))*(n*Syy-Sy^2-Slope^2*(n*Sxx-Sx^2));
y=Yintercept+Slope.*SyncedR(:,3);
%% Plotting
scatter(SyncedR(:,3),SyncedR(:,2))
hold on
grid on
plot(SyncedR(:,3),y)
% plot(SyncedR(:,1),SyncedR(:,2))
% plot(SyncedR(:,1),y)
hold off
%% Residuals
Residuals=SyncedR(:,2)-y; %Are they homoscedastic?
ErVar=var(Residuals); ErMean=mean(Residuals);
%% Goodness of fit (Rsq)
%TotalSumofSquares
TSS=sum((SyncedR(:,2)-RvxxMean).^2);
%RegSS=sum((y-RvxxMean).^2);%Regression Sumofsquares
ResSS=sum((SyncedR(:,2)-y).^2);%Residual Sumofsquares
Rsq1=1-ResSS/TSS; %Rsq1 = 1 - sum(Residuals.^2)/sum((SyncedR(:,2) - RvxxMean).^2);
%Weighted Rsq // k=> Number of random variables
k=2;
WRsq1=1-((1-Rsq1^2)*(n-1)/(n-k-1));


%% Deleted Code
% xy=sum(SyncedR(:,3).*SyncedR(:,2))/n;
% xsq=(sum(SyncedR(:,3).^2))/n;
%Slope=xy-RvxxMean*RspyMean/xsq-(RvxxMean^2);
% Slope=Covariance(2,1)/RspyVar;
%% Methodos Matlab
%Spy=[ones([n,1]), syncR(:,3)];
%RSpy=ReturnsSpy(:,2);
%Th=[0;0];
%Th=RVxx\Spy; %--> Solution for Min SE
%y=Spy*Th;
% Alpha=Th(1);
% Beta=Th(2);
%y=Spy*Th; %Our Linear Model