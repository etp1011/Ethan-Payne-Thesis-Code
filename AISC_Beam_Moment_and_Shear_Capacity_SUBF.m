function [M_n, V_n] = AISC_Beam_Moment_and_Shear_Capacity_SUBF(Girder_W_Shape_W_Input,Girder_W_Shape_plf_Input,F_y_Input,E_Input,L_b_Input,C_b_Input,AISC_W_Shape_Data_Input,AISC_W_Shape_Labels_Input)
%%%%%%%%%%
% Ethan Payne Programer
% September 23, 2024
% Determine Moment and Shear Capacity for multiple inputs of Steel Beams 
% by AISC Code
%%%%%%%%%%
%This Code Determines the controling shear and moment capacity of an input
%ASIC Shape

%Modified so that Only Plastic Moment Capacity Is considered

%Controling moment capicity is the minimum of the capacity fround from the
%Plastic moment, Moment due to Local Buckling of the flange, Moment due
%to Local Buckling of the web, and Latteral Torsional Buckling. No
%Reduction Factor Is applied to contriling moment capacity.

%Controling shear capacity is calculated as 0.6*F_y*A_web*C_v
    
    %%
    
    
    %Inputs
    
    Girder_W_Shape_W = Girder_W_Shape_W_Input; %Input of W Shape Category of steel girder
    Girder_W_Shape_plf = Girder_W_Shape_plf_Input; %Input of plf of steel girder
    
    F_y = F_y_Input; %Input Yield strength in ksi
    E = E_Input; %Modulus of Elasticity in ksi
    L_b = L_b_Input; %Unbraced Length in ft
    C_b = C_b_Input; %See AISC Table 3-1 (Keep 1.14 for distributed Load Simple Span)
    
    
    
    %%
    %Import AISC Shapes
    %[AISC_Data,AISC_Labels] = xlsread("aisc-shapes-database-v16.0.xlsx","Database v16.0"); %Import AISC Steel Shapes database
    
    
    %Seperate W Shapes from Rest of Data
    % AISC_W_Shape_Data = AISC_Data(1:289,:); %Store W Shape Data Seprately
    % AISC_W_Shape_Labels = AISC_Labels(2:290,:); %Store W Shape Labels
    
    AISC_W_Shape_Data = AISC_W_Shape_Data_Input; %Store W Shape Data Seprately
    AISC_W_Shape_Labels = AISC_W_Shape_Labels_Input; %Store W Shape Labels
    
    
    
    AISC_W_Shape_List = strtrim(AISC_W_Shape_Labels(:,3)); %Remove any spaces in front or behind the W Shape Label List
    
    %Combine Inputs into String Variable
    W_Shape_Input_String = ['W' num2str(Girder_W_Shape_W) 'X' num2str(Girder_W_Shape_plf)]; %Convert User Inputs into W##X### format
    
    W_Shape_Index_Location = find(strcmp(AISC_W_Shape_List,W_Shape_Input_String)); %Create an array that puts a 1 at the index the same string is found and 0 elsewhere, Then finds the index location of the 1 
    
    
    %%
    %Girder Data Variables used for Calculation
    Selected_Girder_Data = AISC_W_Shape_Data(W_Shape_Index_Location,:); %Save Girder Data
    Selected_Girder_Labels = AISC_W_Shape_Labels(W_Shape_Index_Location,:); %Save Girder Labels
    
    Z_x = Selected_Girder_Data(36); %in^3
    I_x = Selected_Girder_Data(35); %in^4
    bf_over_2tf =Selected_Girder_Data(29);
    h_over_tw = Selected_Girder_Data(32);
    S_x = Selected_Girder_Data(37); %in^3
    r_ts = Selected_Girder_Data(71); %in
    h_o = Selected_Girder_Data(72); %in
    J = Selected_Girder_Data(46); %in^4
    c = 1; %EQ F2-8a
    D = Selected_Girder_Data(3); %in
    T_w = Selected_Girder_Data(13); %in
    T_f = Selected_Girder_Data(16); %in
    r_y = Selected_Girder_Data(42); %in
    
    L_p =1.76*r_y*sqrt(E/F_y)/12; %Spec EQ F2-5 divided by 12 to convert from in to ft
    
    L_r = 1.95*r_ts*(E/(0.7*F_y))*sqrt(((J*c)/(S_x*h_o))+sqrt((((J*c)/(S_x*h_o))^2)+6.76*((0.7*F_y)/E)^2))/12; %Spec EQ F2-6 divided by 12 to convert from in to ft
    
    Lamda_p_Flange = 0.36*sqrt(E/F_y); %Table B4.1b Case 10
    Lamda_r_Flange =  1*sqrt(E/F_y); %Table B4.1b Case 10
    
    Lamda_p_Web = 3.76*sqrt(E/F_y); %Table B4.1b Case 15
    Lamda_r_Web =  5.7*sqrt(E/F_y); %Table B4.1b Case 15
    
    k_c = 4/sqrt(h_over_tw);
    
    F_cr = ((C_b*(pi^2)*E)/(((L_b*12)/r_ts)^2))*sqrt(1+(((0.078*J*c)/(S_x*h_o))*(((L_b*12)/r_ts)^2))); %Critical Yield Strength in ksi (EQ F2-3)
    
    %%
    %Moment Capacity Calculations
    
    %Plastic Moment
    M_p = F_y*Z_x/12; %Plastic Moment in Ft Kips (EQ F2-1)
    
    % %Moment Capacity from Flange Local Buckling
    % if bf_over_2tf < Lamda_p_Flange %If Compact
    %     M_LB_Flange = M_p; %No Moment from Local Buckling, Input Plastic Moment Instead
    % elseif Lamda_p_Flange <= bf_over_2tf & bf_over_2tf <= Lamda_r_Flange %If Non Compact
    %     M_LB_Flange = (M_p-(M_p-((0.7*F_y*S_x)/12))*((bf_over_2tf-Lamda_p_Flange)/(Lamda_r_Flange-Lamda_p_Flange))); %Moment Capacity in Ft Kips
    % else %If Slender (Lambda_r_Flange < bf_over_2tf is what remains)
    %     M_LB_Flange = (0.9*E*k_c*S_x/12)/(bf_over_2tf^2); %Moment Capacity in Ft Kips
    % end
    % 
    % 
    % %Moment Capacity from Web Local Buckling
    % if h_over_tw < Lamda_p_Web %If Compact
    %     M_LB_Web = M_p; %No Moment from Local Buckling, Input Plastic Moment Instead
    % elseif Lamda_p_Web <= h_over_tw & h_over_tw <= Lamda_r_Web %If Non Compact
    %     M_LB_Web = (M_p-(M_p-((0.7*F_y*S_x)/12))*((h_over_tw-Lamda_p_Web)/(Lamda_r_Web-Lamda_p_Web))); %Moment Capacity in Ft Kips
    % else %If Slender (Lambda_r_Web < h_over_tw is what remains)
    %     M_LB_Web =  (0.9*E*k_c*S_x/12)/(h_over_tw^2); %Moment Capacity in Ft Kips
    % end
    % 
    % %Moment Capacity from Latteral Torsional Buckling
    % if L_b < L_p %If No LTB
    %     M_LTB = M_p; %No Moment from LTB, Input Plastic Moment Instead
    % elseif L_p <= L_b & L_b <= L_r %If Inelatic LTB
    %     M_LTB = C_b*(M_p-(M_p-((0.7*F_y*S_x)/12))*((L_b-L_p)/(L_r-L_p)));%Moment Capacity in Ft Kips (EQ F2-2)
    % else %If Elastic LTB (L_r < L_b is what remains)
    %     M_LTB = F_cr*S_x/12; %Moment Capacity in Ft Kips (EQ F2-3)
    % end
    
    %M_n = min([M_p,M_LB_Flange,M_LB_Web,M_LTB]); %Find the controling Moment capacity
    M_n = M_p; %Find the controling Moment capacity
    

    
    %%
    %Shear Capacity Calculations
    C_v = 1;
    A_web = D*T_w; %Area of the Web in in 
    
    V_n = 0.6*F_y*A_web*C_v; %Find Controling Shear Capacity in Kips (EQ G2-1)
    


end