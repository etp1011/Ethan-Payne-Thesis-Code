function [Mean_Equivalent,SD_Equivalent] = Johnson_Su_Equivalent_Normal_Mean_and_SD_SUBF(Design_Point,Theta,Sigma,Gamma,Delta)
%Finds the Equivalent Normal Mean and Standard Deviation for the Johnson Su
%Distribution

%User Inputs:
%Design_Point = The design point (X*)
%Theta = Location Parameter
%Sigma = Scale Parameter
%Gamma = Skewness parameter
%Delta = Kurtosis Parameter



X_Star = Design_Point; %Define the design point


SD_Equivalent = (Sigma*sqrt(1+((X_Star-Theta)/Delta)^2))/Delta; %Equivelent Normal Standard Deviation

Mean_Equivalent = X_Star-(SD_Equivalent*(Gamma+(Delta*asinh((X_Star-Theta)/Sigma)))); %Equivelent Normal Mean

end