%%%%%%%%%%
% Ethan Payne Programer
% June 28, 2025
% Determine if it is safe to cross a bridge with given UAV measurements
%%%%%%%%%%
%Input Files
%"aisc-shapes-database-v16.0.xlsx","Database v16.0"

%Subfunctions
%AISC_Beam_Moment_and_Shear_Capacity_For_Tool_SUBF.m - Determine Shear and Moment Capacity
%Girder_Size_Predictions_Flange_Width_SUBF.m - Determine List of Possible W Shapes
%Single_Span_Demand_Prediction_SUBF.m - Determine the Shear and Moment Demand For Single Span Bridges
%Multi_Span_Demand_Prediction_SUBF.m - Determine the Shear and Moment Demand For Multi Span Bridges


%Results Units
%Moment is in Kip Ft
%Shear is in Kips


%Limit State Function
%Test to see if R-Q<0 (Failure)
%R = Phi*Lambda_R*Lambda_UAV*(Vn or Mn)
%Q = Lambda_DL*Gamma_DL*(V_DL or M_DL) + Lambda_LL*Gamma_LL*(V_LL or M_LL)


%Errors interpritation
%If -1 error shows up in row 1 or row 3, then there is a critical high bound error
%If -2 error shows up in row 2 or row 4, then there is a critical low bound error

%Modified Version of Capacity Subfuntion is used so that only Plastic
%Moment capcity is concidered for moment capacity
clear all;
close all;
clc

%%
%Inputs

%UAV Measurement Data
Length = 60; %Total Bridge Length (ft)
Spans = 3; %Total Number of Spans
Width = 16; %Out to Out Width of Bridge (ft)
Slab_Depth = 4; %Depth of Concrete Slab (in)
Numb_Girders = 3; %Total Number of Girders
Girder_Depth = 36; %Depth of Girders (in)
Flange_Width = 12; %Flange Thickness (in)


%Girder Condition
%Enter a value of 1 for New Girder Condition
%Enter a value of 2 for Partially Corroded Girder
%Enter a value of 3 for Severely Corroded Girder
Girder_Condition = 1;


%Estimate Material Properties
F_y_For_Input = 50; %Input Yield Strength (ksi)


%Estamate UAV Measurement Error
Depth_Percent_Error_For_Input = 3; %The % Error in measuring girder depth (= 3 from literature)
Flange_Width_Percent_Error_For_Input = 5; %The % Error in measuring flange width (=5 from literature)




%%
%Preprocessing

%Import Steel Shapes Database 
[AISC_Data,AISC_Labels] = xlsread("aisc-shapes-database-v16.0.xlsx","Database v16.0"); %Import AISC Steel Shapes database

AISC_W_Shape_Data_For_Input = AISC_Data(1:289,:); %Store W Shape Data Seprately
AISC_W_Shape_Labels_For_Input = AISC_Labels(2:290,:); %Store W SHape Labels

AISC_W_Shape_List = strtrim(AISC_W_Shape_Labels_For_Input(:,3)); %Remove any spaces in front or behind the W Shape Label List



%Variable Creation for the Determination Shear and Moment for all Potential W Shapes
for i = 1:length(AISC_W_Shape_List) %For each Predicted Value
    W_Shape_String_Inputs = regexp(AISC_W_Shape_List{i},'W(\d+)','tokens'); %Find Number after W in String format
    W_Shape_Doubles_Inputs(i,1) = str2double(W_Shape_String_Inputs{1}); %Convert String to Double (Number)

    plf_String_Inputs = regexp(AISC_W_Shape_List{i},'X([\d\.]+)','tokens'); %Find Number after X in String Format
    plf_Doubles_Inputs(i,1) = str2double(plf_String_Inputs{1}); %Convert String to Double
end


%Inputs of AISC Shapes
Girder_Depth_For_Input = Girder_Depth; %Girder depth (in) 
Flange_Width_For_Input = Flange_Width; %Flange Width (in) 

Girder_W_Shape_W_For_Input = W_Shape_Doubles_Inputs; %Input of W Shape Category of steel girder
Girder_W_Shape_plf_For_Input = plf_Doubles_Inputs; %Input of plf of steel girder


%Girder Condition Bias Values
Girder_Condition_Bias = [1.1;   %New Girder
                         1.05;  %Partially Corroded Girder
                          1.0]; %Severely Corroded Girder


%%

%Run Capacity Subfuction
for j = 1:length(Girder_W_Shape_W_For_Input) %For each required input for capacity
    [All_M_n(j,1), All_V_n(j,1)] = AISC_Beam_Moment_and_Shear_Capacity_For_Tool_SUBF(Girder_W_Shape_W_For_Input(j),Girder_W_Shape_plf_For_Input(j),F_y_For_Input,AISC_W_Shape_Data_For_Input,AISC_W_Shape_Labels_For_Input); %Run Subfunction to Find Moment and Shear capacities
end

%%
%Run Girder Prediction Subfunction 

[All_Predicted_W_Shapes, Girder_Error_Check, Girder_High_and_Low_Bounds] = Girder_Size_Predictions_Flange_Width_SUBF(Girder_Depth_For_Input,Flange_Width_For_Input,Depth_Percent_Error_For_Input,Flange_Width_Percent_Error_For_Input,AISC_W_Shape_Data_For_Input,AISC_W_Shape_Labels_For_Input); %Run Through Subfuction for selection


%%
%Controling Capacity

cell_length = length(All_Predicted_W_Shapes); %Total number of predicted shapes

Controlling_Shape = All_Predicted_W_Shapes(cell_length); %The smallest predicted W Shape


%Find the Index Number In Full AISC Shape List
Current_W_Shape_Index_Location = find(strcmp(AISC_W_Shape_List,Controlling_Shape)); %Create an array that puts a 1 at the index the same string is found and 0 elsewhere, Then finds the index location of the 1

M_n = All_M_n(Current_W_Shape_Index_Location); %Store Predicted Moment Capacity (Ft-Kips)
V_n = All_V_n(Current_W_Shape_Index_Location); %Store Predicted Shear Capacity (Kips)


%%
%Predicted Demand


if Spans == 1 %If single Span Bridge
    [DL_Pos_Shear, DL_Neg_Shear, DL_Pos_Moment, DL_Neg_Moment, LL_Pos_Shear, LL_Neg_Shear, LL_Pos_Moment, LL_Neg_Moment] = Single_Span_Demand_Prediction_SUBF(Length, Width, Slab_Depth, Numb_Girders, Girder_Depth); %Neural Network Prediction Formula Results For Single Span Bridges
else %It is a Multi Span Bridge
    [DL_Pos_Shear, DL_Neg_Shear, DL_Pos_Moment, DL_Neg_Moment, LL_Pos_Shear, LL_Neg_Shear, LL_Pos_Moment, LL_Neg_Moment] = Multi_Span_Demand_Prediction_SUBF(Length, Spans, Width, Slab_Depth, Numb_Girders, Girder_Depth); %Neural Network Prediction Formula Results For Multi Span Bridges
end

Demand_Prediction_Results = [DL_Pos_Shear; DL_Neg_Shear; DL_Pos_Moment; DL_Neg_Moment; LL_Pos_Shear; LL_Neg_Shear; LL_Pos_Moment; LL_Neg_Moment]; %List of NN Prediction Demand Results

Demand_Prediction_Results_DL = [DL_Pos_Shear; DL_Neg_Shear; DL_Pos_Moment; DL_Neg_Moment]; %List of NN Prediction Demand Results of Only Dead Load

Demand_Prediction_Results_LL = [LL_Pos_Shear; LL_Neg_Shear; LL_Pos_Moment; LL_Neg_Moment]; %List of NN Prediction Demand Results of Only Live Load

%%
%LSF Variable Preperation

%Bias values are taken as the mean value found from their distribution
%Strength I Load State is Used



%Bias of Resistance (Capacity) - From Literature
Lambda_R = [Girder_Condition_Bias(Girder_Condition); %Pos Shear
            Girder_Condition_Bias(Girder_Condition); %Neg Shear
            Girder_Condition_Bias(Girder_Condition); %Pos Moment
            Girder_Condition_Bias(Girder_Condition)];%Neg Moment


%Bias of UAV Measurement - From UAV Bias JMP Analysis
Lambda_UAV = [1.0353607; %Pos Shear
              1.0353607; %Neg Shear
              1.0372327; %Pos Moment
              1.0372327];%Neg Moment


%Bias of Dead Load - From DL Bias JMP Analysis
%Single Span Cases
SS_Lambda_DL = [1.0300432; %Pos Shear
                1.0364057; %Neg Shear
                0.999958;  %Pos Moment
                NaN];      %Neg Moment
%Multi Span Cases
MS_Lambda_DL = [0.9972429; %Pos Shear
                0.9981304; %Neg Shear
                1.0085227; %Pos Moment
                1.0518228];%Neg Moment


%Bias of Live Load - From LL Bias JMP Analysis
%Single Span Cases
SS_Lambda_LL = [1.0028395; %Pos Shear
                0.999884;  %Neg Shear
                1.0013809; %Pos Moment
                NaN];      %Neg Moment
%Multi Span Cases
MS_Lambda_LL = [1.0014684; %Pos Shear
                1.0096187; %Neg Shear
                1.0025271; %Pos Moment
                0.9964963];%Neg Moment


%Select DL and LL Bias Values
if Spans == 1 %If Signle Span
    Lambda_DL = SS_Lambda_DL; %Use Single Span DL Bias Values
    Lambda_LL = SS_Lambda_LL; %Use Single Span LL Bias Values
else %Then it is Multi Span
    Lambda_DL = MS_Lambda_DL; %Use Multi Span DL Bias Values
    Lambda_LL = MS_Lambda_LL; %Use Multi Span LL Bias Values
end


%Resistance Factor
Phi = [0.9; %Pos Shear
       0.9; %Neg Shear
       0.9;  %Pos Moment
       0.9]; %Neg Moment


%Dead Load Factor
Gamma_DL = 1.25; %Same for all cases


%Live Load Factor
Gamma_LL = 1.75; %Same for all cases


%Shear and Moment Capacity
Vn_and_Mn = [V_n;  %Pos Shear (Kips)
             V_n;  %Neg Shear (Kips)
             M_n;  %Pos Moment (Ft-Kip)
             M_n]; %Neg Moment (Ft-Kip)

%%
%Determine If Failure Ocurrs

%Solve Limit State Function For Each Shear and Moment Case


%Find Magnitude Values of Predicted Demand
Demand_Magnitude_DL = abs(Demand_Prediction_Results_DL);
Demand_Magnitude_LL = abs(Demand_Prediction_Results_LL);


Test_Values = NaN(length(Vn_and_Mn),1); %Initalize Test Value Vector
R_Values = Test_Values; %Initalize R Value Storage
Q_Values = Test_Values; %Initalize R Value Storage

Test_Check = zeros(22,1); %Inital Variable Set, If Changed then the test failed


for k = 1:length(Vn_and_Mn) %For each Shear and Moment Case
    %Variables for the specific case
    Lambda_R_Used = Lambda_R(k);
    Lambda_UAV_Used = Lambda_UAV(k);
    Lambda_DL_Used = Lambda_DL(k);
    Lambda_LL_Used = Lambda_LL(k);
    Phi_Used = Phi(k);
    Vn_or_Mn_Used = Vn_and_Mn(k);
    DL_Used = Demand_Magnitude_DL(k);
    LL_Used = Demand_Magnitude_LL(k);

    R = Phi_Used*Lambda_R_Used*Lambda_UAV_Used*Vn_or_Mn_Used; %Calculate Capacity
    R_Values(k) = R; %Store Value

    Q = (Lambda_DL_Used*Gamma_DL*DL_Used)+(Lambda_LL_Used*Gamma_LL*LL_Used); %Calculate Demand
    Q_Values(k) = Q; %Store Value
    
    Test_Value = R - Q; %Test for Failure (Solve for g)
    Test_Values(k) = Test_Value; %Store Value

    if Test_Value < 0 %If Demand is Greater Than Capacity
        if k == 1 %Pos Shear
            Test_Check(k) = -1; %Test has failed in Pos Shear Case
        elseif k == 2 %Neg Shear
            Test_Check(k) = -2; %Test has failed in Neg Shear Case
        elseif k == 3 %Pos Moment
            Test_Check(k) = -3; %Test has failed in Pos Moment Case
        elseif k == 4 %Neg Moment
            Test_Check(k) = -4; %Test has failed in Neg Moment Case
        end
    end
end




%%
%Check for any input errors that would invalidate the results

%Girder Prediction Errors
%If any of the following occur, it is considered critical and the
%test is invalid.
%From Girder_Error_Check
%[-1; %High Bound Shape Smaller Than Avalable Shapes for Girder Depth 
% -2; %Low Bound Shape Larger Than Avalable Shapes for Girder Depth
% -1; %High bound Shape Smaller Than Avalable Shapes for Flange Width
% -2];%Low Bound Shape Larger Than Avalable Shapes for Flange Width

if Girder_Error_Check(1) == -1
    Test_Check(5) = -5;
end

if Girder_Error_Check(2) == -2
    Test_Check(6) = -6;
end

if Girder_Error_Check(3) == -1
    Test_Check(7) = -7;
end

if Girder_Error_Check(4) == -2
    Test_Check(8) = -8;
end



%Neural Network Inputs Check
%Bounds

if Length > 200 %Test if input length is higher than 200ft
    Test_Check(9) = -9;
elseif Length < 40 %Test if input length is lower than 40ft
    Test_Check(10) = -10;
end

if Spans > 3 %Test if input number of spans is higher than 3
    Test_Check(11) = -11;
elseif Spans < 1 %Test if input number of spans is lower than 1
    Test_Check(12) = -12;
end

if Width > 42 %Test if input width is higher than 42ft
    Test_Check(13) = -13;
elseif Width < 16 %Test if input width is lower than 16ft
    Test_Check(14) = -14;
end

if Slab_Depth > 8 %Test if input slab depth is higher than 8in
    Test_Check(15) = -15;
elseif Slab_Depth < 4 %Test if input slab depth is lower than 4in
    Test_Check(16) = -16;
end

if Numb_Girders > 6 %Test if input number of girders is higher than 6
    Test_Check(17) = -17;
elseif Numb_Girders < 3 %Test if input number of girders is lower than 3
    Test_Check(18) = -18;
end

if Girder_Depth > 43.1 %Test if input girder depth is higher than 43.1in (Largest Depth of W36 Shape)
    Test_Check(19) = -19;
elseif Girder_Depth < 17.7 %Test if input girder depth is lower than 17.7 (Smallest Depth of W18 Shape)
    Test_Check(20) = -20;
end


%Filters

%The Girder Spacing Is Controled by the Number of Girders Allowed
%Bridges are limited to 6ft girder spacing with 3ft overhang
%with exception in cases where the bridge width is below 28ft and in that
%case, the overhang is reduced to 2ft

if Width >= 28 %If width is larger than or equal to 28ft
    Max_Girder_Check = floor((Width-6)/6)+1; %Calculate the Max Number of Girders Allowed With 6ft Girder Spaceing Requirement
else %If width is less than 28ft
    Max_Girder_Check = floor((Width-4)/6)+1; %Calculate the Max Number of Girders Allowed With 6ft Girder Spaceing Requirement
end

if Numb_Girders > Max_Girder_Check %If input number of girders is greater than the maximum number of girders allowed
    Test_Check(21) = -21;
end


%Length and Span Filter
%Bridges of length less than 60ft are not allowed to have 3 spans

if Length < 60 & Spans == 3
    Test_Check(22) = -22;
end


%%
%Present Results

if any(Test_Check < 0) %If Error
    disp('Errors Have Occurred With Prediction')
    
    if Test_Check(1) < 0
        disp('Test Has Failed In Pos Shear Case')
    end

    if Test_Check(2) < 0
        disp('Test Has Failed In Neg Shear Case')
    end

    if Test_Check(3) < 0
        disp('Test Has Failed In Pos Moment Case')
    end

    if Test_Check(4) < 0
        disp('Test Has Failed In Neg Moment Case')
    end

    if Test_Check(5) < 0
        disp('Girder Prediction Code Error Due To Depth High Bound Shape Being Smaller Than Avalable Shapes')
    end

    if Test_Check(6) < 0
        disp('Girder Prediction Code Error Due To Depth Low Bound Shape Being Larger Than Avalable Shapes')
    end

    if Test_Check(7) < 0
        disp('Girder Prediction Code Error Due To Flange High Bound Shape Being Smaller Than Avalable Shapes')
    end

    if Test_Check(8) < 0
        disp('Girder Prediction Code Error Due To Flange Low Bound Shape Being Larger Than Avalable Shapes')
    end

    if Test_Check(9) < 0
        disp('Input Length Is Larger Than 200ft Allowed')
    end

    if Test_Check(10) < 0
        disp('Input Length Is Smaller Than 40ft Allowed')
    end

    if Test_Check(11) < 0
        disp('Input Number Of Spans Is Larger Than 3 Allowed')
    end

    if Test_Check(12) < 0
        disp('Input Number Of Spans Is Smaller Than 1 Allowed')
    end

    if Test_Check(13) < 0
        disp('Input Width Is Larger Than 42ft Allowed')
    end

    if Test_Check(14) < 0
        disp('Input Width Is Smaller Than 16ft Allowed')
    end

    if Test_Check(15) < 0
        disp('Input Slab Depth Is Larger Than 8in Allowed')
    end

    if Test_Check(16) < 0
        disp('Input Slab Depth Is Smaller Than 4in Allowed')
    end

    if Test_Check(17) < 0
        disp('Input Number Of Girders Is Larger Than 6 Allowed')
    end

    if Test_Check(18) < 0
        disp('Input Number Of Girders Is Smaller Than 3 Allowed')
    end

    if Test_Check(19) < 0
        disp('Input Girder Depth Is Larger Than 43.1in Allowed')
    end

    if Test_Check(20) < 0
        disp('Input Girder Depth Is Smaller Than 17.7in Allowed')
    end

    if Test_Check(21) < 0
        disp('Input Number Of Girders Exceedes Max Ammount Allowed By 6ft Girder Spacing')
    end

    if Test_Check(22) < 0
        disp('Input Length Is Too Small For The Same Input Number Of Spans Input')
    end

else %No Errors, Give User The Results
    disp('Test Passed Successfully')
    fprintf('Positive Shear Case Passed With Test Value(g) Of %.2f kN\n', Test_Values(1))
    fprintf('Negative Shear Case Passed With Test Value(g) Of %.2f kN\n', Test_Values(2))
    fprintf('Positive Moment Case Passed With Test Value(g) Of %.2f kN-m\n', Test_Values(3))
    fprintf('Negative Moment Case Passed With Test Value(g) Of %.2f kN-m\n', Test_Values(4))
end


