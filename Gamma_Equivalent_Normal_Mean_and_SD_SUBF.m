function [Mean_Equivalent,SD_Equivalent] = Gamma_Equivalent_Normal_Mean_and_SD_SUBF(Design_Point,Alpha,Beta)
%Finds the Equivalent Normal Mean and Standard Deviation for the Gamma
%Distribution

%User Inputs:
%Design_Point = The design point (X*)
%Alpha = Shape Parameter
%Beta = Scale Parameter


X_Star = Design_Point; %Define the design point (Not Required for Gamma Distribution)


SD_Equivalent = sqrt(Alpha)*Beta; %Equivelent Normal Standard Deviation

Mean_Equivalent = Alpha*Beta; %Equivelent Normal Mean

end