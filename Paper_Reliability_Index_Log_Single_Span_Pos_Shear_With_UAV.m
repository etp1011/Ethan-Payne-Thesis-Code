%%%%%%%%%%
% Ethan Payne Programer
% Nov 4, 2024
% Calculate the Reliability Index of the perfrmace function for a given
% limit state function, Parent code for subfunction use
%%%%%%%%%%
%Code requires the Symbolic Math Toolbox
%Uses Reliability_Index_Code_SUBF Subfunction to calculate the reliability index and new design points 
%Uses Subfunctions to determine equivilent normal means and standard deviations

clear all
close all
clc

%%
%Variables/Sections with **** should be checked before every run
%Inputs

%Define Limit State Function
syms Lambda_R  DL LL Lambda_DL Lambda_LL Lambda_UAV %Define random variables of limit state function ****

g = Lambda_R*Lambda_UAV*((1.25*DL+1.75*LL)/0.9)-(Lambda_DL*DL+Lambda_LL*LL); %Limit state function ****

Variables_For_Input = [Lambda_R; Lambda_DL; Lambda_LL; DL; LL; Lambda_UAV]; %Random Variable Vector of Limit State Function (Last variable is does not require a Initial Design Point[x*])****

Number_of_Variables = length(Variables_For_Input); %Determine how many variables there are

syms U_Lambda_R U_Lambda_DL U_Lambda_LL U_DL U_LL U_Lambda_UAV %Define Limit State function in terms of U ****

U_Variables_For_Input = [U_Lambda_R; U_Lambda_DL; U_Lambda_LL; U_DL; U_LL; U_Lambda_UAV]; %U Random Variable Vector ****

%Initial Design Points (x*)

%Define Initial Design Points for all variables (Use Mean Values) ****
Initial_Design_Point_Lambda_R = 1.1;
Initial_Design_Point_Lambda_DL = 1.0300432;
Initial_Design_Point_Lambda_LL = 1.0028395;
Initial_Design_Point_DL = 57.59;
Initial_Design_Point_LL = 36.76;
Initial_Design_Point_Lambda_UAV = 1.0353607;

Initial_Design_Points_For_Input = [Initial_Design_Point_Lambda_R; Initial_Design_Point_Lambda_DL; Initial_Design_Point_Lambda_LL; Initial_Design_Point_DL; Initial_Design_Point_LL; Initial_Design_Point_Lambda_UAV]; %Vector of Initial Design Points (x*) [None required for last variable listed if Variables vector] ****

Design_Points_Storage(:,1) = [Initial_Design_Points_For_Input]; %Begin Storage of Design Point Values

%Equivelent Means and Standard Deviations **** (Need to change within loop as well)

Lambda_R_Mew_Input = 0.088162;
Lambda_R_Sigma_Input = 0.119571;
[Equivalent_Mean_Lambda_R, Equivalent_SD_Lambda_R] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(1),Lambda_R_Mew_Input,Lambda_R_Sigma_Input); %First Equivalent inital values for Lambda_R


Lambda_DL_Mew_Input = 0.0232824;
Lambda_DL_Sigma_Input = 0.1108549;
[Equivalent_Mean_Lambda_DL, Equivalent_SD_Lambda_DL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(2), Lambda_DL_Mew_Input, Lambda_DL_Sigma_Input); %First Equivalent inital values for Lambda_LL


Lambda_LL_Mew_Input = 0.0011308;
Lambda_LL_Sigma_Input = 0.0604254;
[Equivalent_Mean_Lambda_LL, Equivalent_SD_Lambda_LL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(3), Lambda_LL_Mew_Input, Lambda_LL_Sigma_Input); %First Equivalent inital values for Lambda_LL


DL_Mew_Input = 3.7806069;
DL_Sigma_Input = 0.7853971;
[Equivalent_Mean_DL, Equivalent_SD_DL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(4), DL_Mew_Input, DL_Sigma_Input); %First Equivalent inital values for DL


LL_Mew_Input = 3.5699196;
LL_Sigma_Input = 0.2559266;
[Equivalent_Mean_LL, Equivalent_SD_LL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(5), LL_Mew_Input, LL_Sigma_Input); %First Equivalent inital values for LL

Lambda_UAV_Mew_Input = 0.003154;
Lambda_UAV_Sigma_Input = 0.2497017;
[Equivalent_Mean_Lambda_UAV, Equivalent_SD_Lambda_UAV] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(6),Lambda_UAV_Mew_Input,Lambda_UAV_Sigma_Input); %First Equivalent inital values for Lambda_UAV


%All Equivelent values except for the ones not yet calculated 
Equivelent_Means_For_Input = [Equivalent_Mean_Lambda_R; Equivalent_Mean_Lambda_DL; Equivalent_Mean_Lambda_LL; Equivalent_Mean_DL; Equivalent_Mean_LL; Equivalent_Mean_Lambda_UAV]; %Vector of equivelent Means ****
Equivelent_SDs_For_Input = [Equivalent_SD_Lambda_R; Equivalent_SD_Lambda_DL; Equivalent_SD_Lambda_LL; Equivalent_SD_DL; Equivalent_SD_LL; Equivalent_SD_Lambda_UAV]; %Vector of equivelent Standard Deviations ****


%Convergence Paramaters 
Gamma = 0.9; %Adjusting Parameter (0<Gamma<1)
Theta = 0.1; %Step Parameter (0<Theta)


%Define number of itterations to run loop ****
Number_of_Itterations = 1000; 

%Define acceptable convergance value
Convergance_Test_Value = 0.001; %What acceptable level of error allowed when calculating convergance (Compared to the difference between First and Second Reliability Index values and First and Second Design Point Values) ****

%%
for a = 1:Number_of_Itterations+1
    if a == Number_of_Itterations+1 %If not found on any itteration
        'Not Converged'
    elseif a == 1 %If on first itteration of the loop
        

        %set up Storage variables for changing Means and SD ****
        Equivelent_Mean_Storage(1,a) = Equivalent_Mean_Lambda_R; %Store Lambda_R Equivelent Mean
        Equivelent_SD_Storage(1,a) = Equivalent_SD_Lambda_R; %Store Lambda_R Equivelent SD

        Equivelent_Mean_Storage(2,a) = Equivalent_Mean_Lambda_DL; %Store Lambda_DL Equivelent Mean
        Equivelent_SD_Storage(2,a) = Equivalent_SD_Lambda_DL; %Store Lambda_DL Equivelent SD

        Equivelent_Mean_Storage(3,a) = Equivalent_Mean_Lambda_LL; %Store Lambda_LL Equivelent Mean
        Equivelent_SD_Storage(3,a) = Equivalent_SD_Lambda_LL; %Store Lambda_LL Equivelent SD

        Equivelent_Mean_Storage(4,a) = Equivalent_Mean_DL; %Store DL Equivelent Mean
        Equivelent_SD_Storage(4,a) = Equivalent_SD_DL; %Store DL Equivelent SD
        
        Equivelent_Mean_Storage(5,a) = Equivalent_Mean_LL; %Store LL Equivelent Mean
        Equivelent_SD_Storage(5,a) = Equivalent_SD_LL; %Store LL Equivelent SD

        Equivelent_Mean_Storage(6,a) = Equivalent_Mean_Lambda_UAV; %Store Lambda_UAV Equivelent Mean
        Equivelent_SD_Storage(6,a) = Equivalent_SD_Lambda_UAV; %Store Lambda_UAV Equivelent SD
        
       
        

        %Calculate first reliability index and Design Points
        [Reliability_Index_Estimate, New_Design_Point_Values] = Reliability_Index_Code_Modified_SUBF(g,Variables_For_Input, U_Variables_For_Input,Initial_Design_Points_For_Input,Equivelent_Means_For_Input,Equivelent_SDs_For_Input,Gamma,Theta); %Calculate First Reliability Index
        Reliability_Index_Storage(:,a) = Reliability_Index_Estimate; %Store value to list of reliability index values
        Design_Points_Storage(:,a+1) = New_Design_Point_Values; %Store values to list of design points 

    else %For all other itterations

        %Save previous calculated values as the old values
        Old_Reliability_Index = Reliability_Index_Estimate; %Store reliability index value from previous run
        Old_Design_Points = New_Design_Point_Values; %Store Design point values from previous run

        Design_Points_For_Input = Old_Design_Points; %Initalize Design points for input vector


        %Update Equivelent Means and SDs****
        
        [Equivalent_Mean_Lambda_R, Equivalent_SD_Lambda_R] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(1), Lambda_R_Mew_Input, Lambda_R_Sigma_Input); %Equivalent values for Lambda_R
        Equivelent_Mean_Storage(1,a) = Equivalent_Mean_Lambda_R; %Store Lambda_R Equivelent Mean
        Equivelent_SD_Storage(1,a) = Equivalent_SD_Lambda_R; %Store Lambda_R Equivelent SD


        [Equivalent_Mean_Lambda_DL, Equivalent_SD_Lambda_DL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(2), Lambda_DL_Mew_Input, Lambda_DL_Sigma_Input); %Equivalent values for Lambda_DL
        Equivelent_Mean_Storage(2,a) = Equivalent_Mean_Lambda_DL; %Store Lambda_DL Equivelent Mean
        Equivelent_SD_Storage(2,a) = Equivalent_SD_Lambda_DL; %Store Lambda_DL Equivelent SD


        [Equivalent_Mean_Lambda_LL, Equivalent_SD_Lambda_LL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(3), Lambda_LL_Mew_Input, Lambda_LL_Sigma_Input); %Equivalent values for Lambda_LL
        Equivelent_Mean_Storage(3,a) = Equivalent_Mean_Lambda_LL; %Store Lambda_LL Equivelent Mean
        Equivelent_SD_Storage(3,a) = Equivalent_SD_Lambda_LL; %Store Lambda_LL Equivelent SD


        [Equivalent_Mean_DL, Equivalent_SD_DL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(4),DL_Mew_Input,DL_Sigma_Input); %Equivalent values for DL
        Equivelent_Mean_Storage(4,a) = Equivalent_Mean_DL; %Store DL Equivelent Mean
        Equivelent_SD_Storage(4,a) = Equivalent_SD_DL; %Store DL Equivelent SD
        

        [Equivalent_Mean_LL, Equivalent_SD_LL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(5), LL_Mew_Input, LL_Sigma_Input); %Equivalent values for LL
        Equivelent_Mean_Storage(5,a) = Equivalent_Mean_LL; %Store LL Equivelent Mean
        Equivelent_SD_Storage(5,a) = Equivalent_SD_LL; %Store LL Equivelent SD
   
        
        [Equivalent_Mean_Lambda_UAV, Equivalent_SD_Lambda_UAV] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(6), Lambda_UAV_Mew_Input, Lambda_UAV_Sigma_Input); %Equivalent values for Lambda_R
        Equivelent_Mean_Storage(6,a) = Equivalent_Mean_Lambda_UAV; %Store Lambda_R Equivelent Mean
        Equivelent_SD_Storage(6,a) = Equivalent_SD_Lambda_UAV; %Store Lambda_R Equivelent SD


 
        %Combine into input vectors ****
        Equivelent_Means_For_Input = [Equivalent_Mean_Lambda_R; Equivalent_Mean_Lambda_DL; Equivalent_Mean_Lambda_LL; Equivalent_Mean_DL; Equivalent_Mean_LL; Equivalent_Mean_Lambda_UAV]; %Vector of equivelent Means ****
        Equivelent_SDs_For_Input = [Equivalent_SD_Lambda_R; Equivalent_SD_Lambda_DL; Equivalent_SD_Lambda_LL; Equivalent_SD_DL; Equivalent_SD_LL; Equivalent_SD_Lambda_UAV]; %Vector of equivelent Standard Deviations ****
        
        %Calculate New Reliability Index and Design Points
        [Reliability_Index_Estimate, New_Design_Point_Values] = Reliability_Index_Code_Modified_SUBF(g,Variables_For_Input, U_Variables_For_Input, Design_Points_For_Input,Equivelent_Means_For_Input,Equivelent_SDs_For_Input,Gamma,Theta); %Calculate Reliability Index for next run with updated design points
        
        Reliability_Index_Storage(:,a) = Reliability_Index_Estimate; %Store value to list of reliability index values
        Design_Points_Storage(:,a+1) = New_Design_Point_Values; %Store values to list of design points 

        Reliability_Index_Convergance_Test = abs(Old_Reliability_Index-Reliability_Index_Estimate); %Test for convergence for reliability index
        Design_Points_Convergance_Test = abs(Old_Design_Points - New_Design_Point_Values); %Test for converfance for Design Points
        Controling_Design_Point_Convergance_Value = max(Design_Points_Convergance_Test); %Largest diffence possible for design points

        if Reliability_Index_Convergance_Test < Convergance_Test_Value & Controling_Design_Point_Convergance_Value < Convergance_Test_Value %If Converged
            'Has Converged'
            Itterations_Until_Convergance = a %Store the number of itterations it took to converge

            Reliability_Index_Final = Reliability_Index_Estimate; %Final Reliability Index Value
            Design_Points_Final = New_Design_Point_Values; %Final Design Points

            return
        end
    end
end

