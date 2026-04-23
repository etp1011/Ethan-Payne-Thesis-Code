function [M_n, V_n] = AISC_Beam_Moment_and_Shear_Capacity_For_Tool_SUBF(Girder_W_Shape_W_Input,Girder_W_Shape_plf_Input,F_y_Input,AISC_W_Shape_Data_Input,AISC_W_Shape_Labels_Input)
%%%%%%%%%%
% Ethan Payne Programer
% June 28, 2025
% Determine Moment and Shear Capacity for Controling W Shape
%%%%%%%%%%
%This Code Determines the controling shear and moment capacity of an input
%ASIC Shape

%Modified so that Only Plastic Moment Capacity Is considered

%Controling shear capacity is calculated as 0.6*F_y*A_web*C_v
    
    %%
    
    
    %Inputs
    
    Girder_W_Shape_W = Girder_W_Shape_W_Input; %Input of W Shape Category of steel girder
    Girder_W_Shape_plf = Girder_W_Shape_plf_Input; %Input of plf of steel girder
    
    F_y = F_y_Input; %Input Yield strength in ksi
    
    
    
    %%
    %Import AISC Shapes
    
    AISC_W_Shape_Data = AISC_W_Shape_Data_Input; %Store W Shape Data Seprately
    AISC_W_Shape_Labels = AISC_W_Shape_Labels_Input; %Store W Shape Labels
    
    
    
    AISC_W_Shape_List = strtrim(AISC_W_Shape_Labels(:,3)); %Remove any spaces in front or behind the W Shape Label List
    
    %Combine Inputs into String Variable
    W_Shape_Input_String = ['W' num2str(Girder_W_Shape_W) 'X' num2str(Girder_W_Shape_plf)]; %Convert User Inputs into W##X### format
    
    W_Shape_Index_Location = find(strcmp(AISC_W_Shape_List,W_Shape_Input_String)); %Create an array that puts a 1 at the index the same string is found and 0 elsewhere, Then finds the index location of the 1 
    
    
    %%
    %Girder Data Variables used for Calculation
    Selected_Girder_Data = AISC_W_Shape_Data(W_Shape_Index_Location,:); %Save Girder Data
   
    
    Z_x = Selected_Girder_Data(36); %in^3
    D = Selected_Girder_Data(3); %in
    T_w = Selected_Girder_Data(13); %in
    
    
    %%
    %Moment Capacity Calculations
    
    %Plastic Moment
    M_p = F_y*Z_x/12; %Plastic Moment in Ft Kips (EQ F2-1)
    

    M_n = M_p; %Find the controling Moment capacity
    

    
    %%
    %Shear Capacity Calculations
    C_v = 1;
    A_web = D*T_w; %Area of the Web in in 
    
    V_n = 0.6*F_y*A_web*C_v; %Find Controling Shear Capacity in Kips (EQ G2-1)
    


end