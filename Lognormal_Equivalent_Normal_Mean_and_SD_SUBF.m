function [Mean_Equivalent,SD_Equivalent] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Design_Point,Mew,Sigma)
%Finds the Equivalent Normal Mean and Standard Deviation for the Lognormal
%Distribution

%User Inputs:
%Design_Point = The design point (X*)
%Mew = Location Parameter
%Sigma = Scale Parameter


X_Star = Design_Point; %Define the design point


SD_Equivalent = X_Star*Sigma; %Equivelent Normal Standard Deviation

Mean_Equivalent = X_Star*(1-log(X_Star)+Mew); %Equivelent Normal Mean, Note: log() in matlab is the same as ln()

end