function [Mean_Equivalent,SD_Equivalent] = SHASH_Equivalent_Normal_Mean_and_SD_SUBF(Design_Point,Theta,Sigma,Gamma,Delta)
%Finds the Equivalent Normal Mean and Standard Deviation for the SHASH
%Distribution

%User Inputs:
%Design_Point = The design point (X*)
%Theta = Location Parameter
%Sigma = Scale Parameter
%Gamma = Skewness parameter
%Delta = Kurtosis Parameter



X_Star = Design_Point; %Define the design point

%Calculate y
y = asinh((X_Star-Theta)/Sigma); %asinh is the same as sinh^-1

SD_Equivalent = Sigma*(cosh(y)/cosh(y/Delta)); %Equivelent Normal Standard Deviation

Mean_Equivalent = X_Star-(Sigma*(cosh(y)/cosh(y/Delta))*((y/Delta)+Gamma)); %Equivelent Normal Mean

end