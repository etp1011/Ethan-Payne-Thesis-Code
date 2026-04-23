%%%%%%%%%%
% Ethan Payne Programer
% Dec 19, 2024
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
syms Lambda_R Lambda_DL Lambda_LL %Define random variables of limit state function ****

DL_LL_Ratio = 0.6; %DL/LL Ratio to solve Limit State function for

g = Lambda_R*((1.25*DL_LL_Ratio+1.75)/0.9)-(Lambda_DL*DL_LL_Ratio+Lambda_LL); %Limit state function ****

Variables_For_Input = [Lambda_DL; Lambda_LL; Lambda_R]; %Random Variable Vector of Limit State Function (Last variable is does not require a Initial Design Point[x*])****

Number_of_Variables = length(Variables_For_Input); %Determine how many variables there are


%Initial Design Points (x*)

%Define Initial Design Points for all but 1 variable (Use Mean Values) ****
Initial_Design_Point_Lambda_DL = 1.0300432;
Initial_Design_Point_Lambda_LL = 1.0028395;


Initial_Design_Points_For_Input = [Initial_Design_Point_Lambda_DL; Initial_Design_Point_Lambda_LL]; %Vector of Initial Design Points (x*) [None required for last variable listed if Variables vector] ****

Design_Points_Storage(:,1) = [Initial_Design_Points_For_Input; 0]; %Begin Storage of Design Point Values

%Equivelent Means and Standard Deviations **** (Need to change within loop as well)
Lambda_DL_Mew_Input = 0.0232824;
Lambda_DL_Sigma_Input = 0.1108549;
[Equivalent_Mean_Lambda_DL, Equivalent_SD_Lambda_DL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(1), Lambda_DL_Mew_Input, Lambda_DL_Sigma_Input); %First Equivalent inital values for Lambda_DL


Lambda_LL_Mew_Input = 0.0011308;
Lambda_LL_Sigma_Input = 0.0604254;
[Equivalent_Mean_Lambda_LL, Equivalent_SD_Lambda_LL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Points_For_Input(2), Lambda_LL_Mew_Input, Lambda_LL_Sigma_Input); %First Equivalent inital values for Lambda_LL





%Last variable input values (Subfunction is in the a=1 part of loop) 
Lambda_R_Mew_Input = 0.036151;
Lambda_R_Sigma_Input = 0.158990;



%All Equivelent values except for the ones not yet calculated 
Equivelent_Means_For_Input = [Equivalent_Mean_Lambda_DL; Equivalent_Mean_Lambda_LL]; %Vector of equivelent Means ****
Equivelent_SDs_For_Input = [Equivalent_SD_Lambda_DL; Equivalent_SD_Lambda_LL]; %Vector of equivelent Standard Deviations ****


%Define number of itterations to run loop ****
Number_of_Itterations = 1000; 

%Define acceptable convergance value
Convergance_Test_Value = 0.001; %What acceptable level of error allowed when calculating convergance (Compared to the difference between First and Second Reliability Index values and First and Second Design Point Values) ****

%%
for a = 1:Number_of_Itterations+1
    if a == Number_of_Itterations+1 %If not found on any itteration
        'Not Converged'
    elseif a == 1 %If on first itteration of the loop
        %Find last x* value for Design point storage (Calculation already done in subfunction but having this value makes the design points easier to understand)
        g_equal_to_0_equation_For_Storage = solve(g == 0, Variables_For_Input(Number_of_Variables)); %Solve for remaining x* when g = 0
        
        Limit_State_Variables_For_x_Star_Remaining_For_Storage = Variables_For_Input; %initalize Variable
        Limit_State_Variables_For_x_Star_Remaining_For_Storage(Number_of_Variables,:) = []; %Remove last variable for x* Calc

        x_star_remaining_sym_For_Storage = subs(g_equal_to_0_equation_For_Storage, Limit_State_Variables_For_x_Star_Remaining_For_Storage, Initial_Design_Points_For_Input); %Input known x* values into equation to solve for remaining x*
        x_star_remaining_For_Storage = double(x_star_remaining_sym_For_Storage); %Convert to double from sym value
    
        Design_Points_Storage(Number_of_Variables,a) = x_star_remaining_For_Storage; %Add first calculation of last random variable to data stroage so there is not just a 0

        Initial_Design_Point_For_Final_Variable = x_star_remaining_For_Storage; %Add first calculation of last random variabe as the final design point for initial input

        
        %Find first itteration of equivelent values for remaining variable. ****


        [Equivalent_Mean_Lambda_R, Equivalent_SD_Lambda_R] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Initial_Design_Point_For_Final_Variable,Lambda_R_Mew_Input,Lambda_R_Sigma_Input); %First Equivalent inital values for Lambda_R

        

        %set up Storage variables for changing Means and SD ****
        Equivelent_Mean_Storage(1,a) = Equivalent_Mean_Lambda_DL; %Store Lambda_DL Equivelent Mean
        Equivelent_SD_Storage(1,a) = Equivalent_SD_Lambda_DL; %Store Lambda_DL Equivelent SD

        Equivelent_Mean_Storage(2,a) = Equivalent_Mean_Lambda_LL; %Store Lambda_LL Equivelent Mean
        Equivelent_SD_Storage(2,a) = Equivalent_SD_Lambda_LL; %Store Lambda_LL Equivelent SD

        Equivelent_Mean_Storage(3,a) = Equivalent_Mean_Lambda_R; %Store Lambda_R Equivelent Mean
        Equivelent_SD_Storage(3,a) = Equivalent_SD_Lambda_R; %Store Lambda_R Equivelent SD
        

        %Add Calculated Equivelent Mean and SD to Input Vector ****
        Equivelent_Means_For_Input(Number_of_Variables,1) = Equivalent_Mean_Lambda_R; %Add calculated equivelent Mean ****
        Equivelent_SDs_For_Input(Number_of_Variables,1) =  Equivalent_SD_Lambda_R; %Add calculated equivelent SD ****

        

        %Calculate first reliability index and Design Points
        [Reliability_Index_Estimate, New_Design_Point_Values] = Reliability_Index_Code_SUBF(g,Variables_For_Input,Initial_Design_Points_For_Input,Equivelent_Means_For_Input,Equivelent_SDs_For_Input); %Calculate First Reliability Index
        Reliability_Index_Storage(:,a) = Reliability_Index_Estimate; %Store value to list of reliability index values
        Design_Points_Storage(:,a+1) = New_Design_Point_Values; %Store values to list of design points 

    else %For all other itterations

        %Save previous calculated values as the old values
        Old_Reliability_Index = Reliability_Index_Estimate; %Store reliability index value from previous run
        Old_Design_Points = New_Design_Point_Values; %Store Design point values from previous run

        Design_Points_For_Input = Old_Design_Points; %Initalize Design points for input vector
        Design_Points_For_Input(Number_of_Variables,:) = []; %Remove last variable design point so that it can be calculated by g = 0 again

        %Update Equivelent Means and SDs****
        
        [Equivalent_Mean_Lambda_DL, Equivalent_SD_Lambda_DL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(1), Lambda_DL_Mew_Input, Lambda_DL_Sigma_Input); %Equivalent values for Lambda_DL
        Equivelent_Mean_Storage(1,a) = Equivalent_Mean_Lambda_DL; %Store Lambda_DL Equivelent Mean
        Equivelent_SD_Storage(1,a) = Equivalent_SD_Lambda_DL; %Store Lambda_DL Equivelent SD

        
        [Equivalent_Mean_Lambda_LL, Equivalent_SD_Lambda_LL] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(2), Lambda_LL_Mew_Input, Lambda_LL_Sigma_Input); %Equivalent values for Lambda_LL
        Equivelent_Mean_Storage(2,a) = Equivalent_Mean_Lambda_LL; %Store Lambda_LL Equivelent Mean
        Equivelent_SD_Storage(2,a) = Equivalent_SD_Lambda_LL; %Store Lambda_LL Equivelent SD

        
        [Equivalent_Mean_Lambda_R, Equivalent_SD_Lambda_R] = Lognormal_Equivalent_Normal_Mean_and_SD_SUBF(Old_Design_Points(3), Lambda_R_Mew_Input, Lambda_R_Sigma_Input); %Equivalent values for Lambda_R
        Equivelent_Mean_Storage(3,a) = Equivalent_Mean_Lambda_R; %Store Lambda_R Equivelent Mean
        Equivelent_SD_Storage(3,a) = Equivalent_SD_Lambda_R; %Store Lambda_R Equivelent SD


 
        %Combine into input vectors ****
        Equivelent_Means_For_Input = [Equivalent_Mean_Lambda_DL; Equivalent_Mean_Lambda_LL; Equivalent_Mean_Lambda_R]; %Vector of equivelent Means ****
        Equivelent_SDs_For_Input = [Equivalent_SD_Lambda_DL; Equivalent_SD_Lambda_LL; Equivalent_SD_Lambda_R]; %Vector of equivelent Standard Deviations ****
        
        %Calculate New Reliability Index and Design Points
        [Reliability_Index_Estimate, New_Design_Point_Values] = Reliability_Index_Code_SUBF(g,Variables_For_Input,Design_Points_For_Input,Equivelent_Means_For_Input,Equivelent_SDs_For_Input); %Calculate Reliability Index for next run with updated design points
        
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

