function [Mean_Equivalent,SD_Equivalent] = Extreme_Type_1_Equivalent_Normal_Mean_and_SD_SUBF(Design_Point,Mew,Sigma)
%Finds the Equivalent Normal Mean and Standard Deviation for the Extreme
%Type 1 Distribution

%User Inputs:
%Design_Point = The design point (X*)
%Mew = Location Parameter
%Sigma = Scale Parameter


X_Star = Design_Point; %Define the design point




%Calculate a
a = sqrt((pi^2)/(6*(Sigma^2)));

%Calculate u
u = Mew-(0.5772/a);

CDF = exp(-exp(-a*(X_Star-u))); %CDF of Extreme Type 1 Distribution

PDF = a*(exp(-a*(X_Star-u)))*exp(-exp(-a*(X_Star-u))); %PDF of Extreme Type 1 Distribuiton

SD_Equivalent = (1/PDF)*normpdf(norminv(CDF)); %Equivelent Normal Standard Deviation

Mean_Equivalent = X_Star-(SD_Equivalent*(norminv(CDF))); %Equivelent Normal Mean, Note: log() in matlab is the same as ln()

end