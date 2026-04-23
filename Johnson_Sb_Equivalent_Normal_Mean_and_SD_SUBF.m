function [Mean_Equivalent,SD_Equivalent] = Johnson_Sb_Equivalent_Normal_Mean_and_SD_SUBF(Design_Point,Theta,Sigma,Gamma,Delta)
%Finds the Equivalent Normal Mean and Standard Deviation for the Johnson Sb
%Distribution

%User Inputs:
%Design_Point = The design point (X*)
%Theta = Location Parameter
%Sigma = Scale Parameter
%Gamma = Skewness parameter
%Delta = Kurtosis Parameter


%If the design point is negative, shift it so that values of the equivilent means can still be calculated
%In order to produce all real numbers in output, Theta+Sigma>X_Star>Theta
epsilon = abs(Design_Point)+Theta+Sigma-0.0001; %Shift value

if Design_Point < 0
    X_Star = Design_Point+epsilon; %Shift so value can still be cauculated
else
    X_Star = Design_Point; %X_Star Defined as normal
end


SD_Equivalent = (Sigma*(X_Star-Theta)*(Theta+Sigma-X_Star))/Delta; %Equivelent Normal Standard Deviation

Mean_Equivalent = X_Star-(SD_Equivalent*(Gamma+(Delta*log((X_Star-Theta)/(Theta+Sigma-X_Star))))); %Equivelent Normal Mean

end