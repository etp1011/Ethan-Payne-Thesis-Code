%%%%%%%%%%
% Ethan Payne Programer
% September 23, 2024
% Determine Bias of Girders using Flange width Prediction subfuction and
% Girder Capacity Subfuction
%%%%%%%%%%
%Input Files
%"aisc-shapes-database-v16.0.xlsx","Database v16.0"

%Subfunctions
%AISC_Beam_Moment_and_Shear_Capacity_SUBF.m - Determine Shear and Moment
%Capacity
%Girder_Size_Predictions_Flange_Width_SUBF.m - Determine List of Possible W
%Shapes

%Results Units
%Moment is in Kip Ft
%Shear is in Kips
%Bias is Actual/Predicted

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

W_Shapes_To_Calculate_W = 18; %What List of W Shapes to go through  

Depth_Percent_Error_For_Input = 3; %The % Error in measuring girder depth (= 3 from literature)
Flange_Width_Percent_Error_For_Input = 5; %The % Error in measuring flange width (=5 from literature)


F_y_For_Input = 50; %Input Yield strength in ksi
E_For_Input = 29000; %Modulus of Elasticity in ksi
L_b_For_Input = 30; %Unbraced Length in ft
C_b_For_Input = 1.14; %See AISC Table 3-1 (Keep 1.14 for distributed Load Simple Span)


%Import Steel Shapes Database 
[AISC_Data,AISC_Labels] = xlsread("aisc-shapes-database-v16.0.xlsx","Database v16.0"); %Import AISC Steel Shapes database

AISC_W_Shape_Data_For_Input = AISC_Data(1:289,:); %Store W Shape Data Seprately
AISC_W_Shape_Labels_For_Input = AISC_Labels(2:290,:); %Store W SHape Labels

AISC_W_Shape_List = strtrim(AISC_W_Shape_Labels_For_Input(:,3)); %Remove any spaces in front or behind the W Shape Label List

%Individual W Shape Data and Labels
if W_Shapes_To_Calculate_W == 44
    W_Data = AISC_Data(1:6,:); %Obtain W44 Shape Data
    W_Labels = AISC_Labels(2:7,:); %Obtain W44 Labels
end

if W_Shapes_To_Calculate_W == 40
    W_Data = AISC_Data(7:30,:); %Obtain W40 Shape Data
    W_Labels = AISC_Labels(8:31,:); %Obtain W40 Labels
end

if W_Shapes_To_Calculate_W == 36
    W_Data = AISC_Data(31:59,:); %Obtain W36 Shape Data
    W_Labels = AISC_Labels(32:60,:); %Obtain W36 Labels
end

if W_Shapes_To_Calculate_W == 33
    W_Data = AISC_Data(60:72,:); %Obtain W33 Shape Data
    W_Labels = AISC_Labels(61:73,:); %Obtain W33 Labels
end

if W_Shapes_To_Calculate_W == 30
    W_Data = AISC_Data(73:88,:); %Obtain W30 Shape Data
    W_Labels = AISC_Labels(74:89,:); %Obtain W30 Labels
end

if W_Shapes_To_Calculate_W == 27
    W_Data = AISC_Data(89:105,:); %Obtain W27 Shape Data
    W_Labels = AISC_Labels(90:106,:); %Obtain W27 Labels
end

if W_Shapes_To_Calculate_W == 24
    W_Data = AISC_Data(106:126,:); %Obtain W24 Shape Data
    W_Labels = AISC_Labels(107:127,:); %Obtain W24 Labels
end

if W_Shapes_To_Calculate_W == 21
    W_Data = AISC_Data(127:147,:); %Obtain W21 Shape Data
    W_Labels = AISC_Labels(128:148,:); %Obtain W21 Labels
end

if W_Shapes_To_Calculate_W == 18
    W_Data = AISC_Data(148:170,:); %Obtain W18 Shape Data
    W_Labels = AISC_Labels(149:171,:); %Obtain W18 Labels
end

if W_Shapes_To_Calculate_W == 16
    W_Data = AISC_Data(171:181,:); %Obtain W16 Shape Data
    W_Labels = AISC_Labels(172:182,:); %Obtain W16 Labels
end

if W_Shapes_To_Calculate_W == 14
    W_Data = AISC_Data(182:219,:); %Obtain W14 Shape Data
    W_Labels = AISC_Labels(183:220,:); %Obtain W14 Labels
end

if W_Shapes_To_Calculate_W == 12
    W_Data = AISC_Data(220:248,:); %Obtain W12 Shape Data
    W_Labels = AISC_Labels(221:249,:); %Obtain W12 Labels
end

if W_Shapes_To_Calculate_W == 10
    W_Data = AISC_Data(249:266,:); %Obtain W10 Shape Data
    W_Labels = AISC_Labels(250:267,:); %Obtain W10 Labels
end

if W_Shapes_To_Calculate_W == 8
    W_Data = AISC_Data(267:279,:); %Obtain W8 Shape Data
    W_Labels = AISC_Labels(268:280,:); %Obtain W8 Labels
end

if W_Shapes_To_Calculate_W == 6
    W_Data = AISC_Data(280:286,:); %Obtain W6 Shape Data
    W_Labels = AISC_Labels(281:287,:); %Obtain W6 Labels
end

if W_Shapes_To_Calculate_W == 5
    W_Data = AISC_Data(287:288,:); %Obtain W5 Shape Data
    W_Labels = AISC_Labels(288:289,:); %Obtain W5 Labels
end

if W_Shapes_To_Calculate_W == 4
    W_Data = AISC_Data(289,:); %Obtain W4 Shape Data
    W_Labels = AISC_Labels(290,:); %Obtain W4 Labels
end

%Determine Shear and Moment for all Potential W Shapes
for i = 1:length(AISC_W_Shape_List) %For each Predicted Value
    W_Shape_String_Inputs = regexp(AISC_W_Shape_List{i},'W(\d+)','tokens'); %Find Number after W in String format
    W_Shape_Doubles_Inputs(i,1) = str2double(W_Shape_String_Inputs{1}); %Convert String to Double (Number)

    plf_String_Inputs = regexp(AISC_W_Shape_List{i},'X([\d\.]+)','tokens'); %Find Number after X in String Format
    plf_Doubles_Inputs(i,1) = str2double(plf_String_Inputs{1}); %Convert String to Double
end


%Inputs of AISC Shapes
Girder_Depth_For_Input = W_Data(:,3); %Girder depth in in (36) [44,36,4.16]
Flange_Width_For_Input = W_Data(:,8); %Flange Width in in (12) [15.9,12,4.06]

Girder_W_Shape_W_For_Input = W_Shape_Doubles_Inputs; %Input of W Shape Category of steel girder
Girder_W_Shape_plf_For_Input = plf_Doubles_Inputs; %Input of plf of steel girder


%%

%Run Capacity Subfuction
for j = 1:length(Girder_W_Shape_W_For_Input) %For each required input for capacity
    [All_M_n(j,1), All_V_n(j,1)] = AISC_Beam_Moment_and_Shear_Capacity_SUBF(Girder_W_Shape_W_For_Input(j),Girder_W_Shape_plf_For_Input(j),F_y_For_Input,E_For_Input,L_b_For_Input,C_b_For_Input,AISC_W_Shape_Data_For_Input,AISC_W_Shape_Labels_For_Input); %Run Subfunction to Find Moment and Shear capacities
end

%%
%Run Girder Prediction Subfunction
max_length = 0; %Initalize max length variable for cell output maniputlation

%Run Subfuction 
for l = 1:length(Girder_Depth_For_Input) %For each required input
    [All_Predicted_W_Shapes_Cells{l}, All_Error_Check(:,l), All_High_and_Low_Bounds(:,l)] = Girder_Size_Predictions_Flange_Width_SUBF(Girder_Depth_For_Input(l),Flange_Width_For_Input(l),Depth_Percent_Error_For_Input,Flange_Width_Percent_Error_For_Input,AISC_W_Shape_Data_For_Input,AISC_W_Shape_Labels_For_Input); %Run Through Subfuction for selection
    %Each new column in output is for a new shape
    max_length = max(max_length,length(All_Predicted_W_Shapes_Cells{l})); %Save max length variable for final output matrix size
end

All_Predicted_W_Shapes = cell(max_length,length(Girder_Depth_For_Input)); %Create NaN Matrix for final output

for m = 1:length(Girder_Depth_For_Input) %For each run of subfunction
    List = All_Predicted_W_Shapes_Cells{m}; %Store Current list for itteration of loop

    for k = 1:max_length %for each possible output shape
        if k <= length(List) %if there is a shape to place
            All_Predicted_W_Shapes{k,m} = List{k}; %Place the shape
        else %If there is no shape left
            All_Predicted_W_Shapes{k,m} = '-'; %Place a dash
        end
    end
end

%%
%Calculate Bias

Count_For_All_Bias_Output = 0; %initalize Count Variable for all possible bias values

AISC_Specified_W_Shape_List = strtrim(W_Labels(:,3)); %Remove any spaces in front or behind the W Shape Label List

Bias_Of_Moments = cell(max_length,length(Girder_Depth_For_Input)); %Create NaN Matrix for final output of Moment Bias
Bias_Of_Shears = cell(max_length,length(Girder_Depth_For_Input)); %Create NaN Matrix for final output of Shear Bias

for n = 1:length(Girder_Depth_For_Input) %For each Girder Predicted
    W_Shape = AISC_Specified_W_Shape_List(n); %W Shape String for this itteration of the loop
    %Find the Index Number In Full AISC Shape List (Used to pull Capacity Values)
    W_Shape_Index_Location = find(strcmp(AISC_W_Shape_List,W_Shape)); %Create an array that puts a 1 at the index the same string is found and 0 elsewhere, Then finds the index location of the 1 

    Actual_M_n = All_M_n(W_Shape_Index_Location); %Store actual Moment Capacity
    Actual_V_n = All_V_n(W_Shape_Index_Location); %Store actual Shear Capacity

    List_2 = All_Predicted_W_Shapes_Cells{n}; %Store Current predictive list for itteration of loop

    Uniform_Distribution_Decimal(n) = 1/length(List_2); %Store the % chance for each bias to ocurr 

    for p = 1:max_length %For each Predicted Shape
        if p <= length(List_2) %If there is bias to calculate
            Current_Shape = List_2{p}; %Store the current W Shape
            %Find the Index Number In Full AISC Shape List
            Current_W_Shape_Index_Location = find(strcmp(AISC_W_Shape_List,Current_Shape)); %Create an array that puts a 1 at the index the same string is found and 0 elsewhere, Then finds the index location of the 1
    
            Predicted_M_n = All_M_n(Current_W_Shape_Index_Location); %Store Predicted Moment Capacity
            Predicted_V_n = All_V_n(Current_W_Shape_Index_Location); %Store Predicted Shear Capacity
    
            Bias_Of_Moments{p,n} = Actual_M_n/Predicted_M_n; %Calculate and Store Moment Bias
            Bias_Of_Shears{p,n} = Actual_V_n/Predicted_V_n; %Calculate and Store Shear Bias

            Count_For_All_Bias_Output = Count_For_All_Bias_Output + 1; %Update Count Variable
            
            All_Moment_Bias_Values(Count_For_All_Bias_Output,1) = Bias_Of_Moments{p,n}; %Store Moment Bias in Total Bias List
            All_Shear_Bias_Values(Count_For_All_Bias_Output,1) = Bias_Of_Shears{p,n}; %Store Shear Bias in Total Bias List


        else %If there is no bias to calculate
            Bias_Of_Moments{p,n} = '-'; %Calculate and Store Moment Bias
            Bias_Of_Shears{p,n} = '-'; %Calculate and Store Shear Bias
        end
    end
end

%%
%Final Output Tables
Output_Table = cell(max_length+2,length(Girder_Depth_For_Input)+1); %Initalze output Table Size (+2 for Uniform Distribution Decimal and Additianal Headers, *3 for three columns for each Shape)

%Labels in First Column
for r = 1:(max_length+2) %For each row of first column
    if r == 1
        Output_Table{r,1} = 'Actual Shape';
    elseif r == 2
        Output_Table{r,1} = 'Distribution Decimal';
    else
    Output_Table{r,1} = 'Bias'; 
    end
end


%Label Headers
Column_Headers = AISC_Specified_W_Shape_List'; %Actual Shape

for q = 1:length(Column_Headers); %For each Actual Shape
    Actual_Shape = Column_Headers(q); %Put in Headers into output Table
    Output_Table{1,q+1} = Actual_Shape; %Store Actual Shape into Table
end

%Distribution of Bias
for s = 1:length(Uniform_Distribution_Decimal) %For Each Distribution Decimal
    Distribution_Decimal_To_Place = Uniform_Distribution_Decimal(s); %Individual Distribution Decimal to Place
    Output_Table{2,s+1} = Distribution_Decimal_To_Place; %Store Distribution Decimal into Table
end

Moment_Output_Table = Output_Table; %Store Template into Final Variable
Shear_Output_Table = Output_Table; %Store Template into Final Variable

%Final Moment Table
[Number_of_Bias_Rows,Number_of_Bias_Columns] = size(Bias_Of_Moments); %Store the size of the bias datatable

for t = 1:Number_of_Bias_Rows %For each bias row
    for u = 1:Number_of_Bias_Columns %For each bias column
        Moment_Output_Table{t+2,u+1} = Bias_Of_Moments{t,u}; %Store Bias Values
    end
end

%Final Shear Table
for v = 1:Number_of_Bias_Rows %For each bias row
    for w = 1:Number_of_Bias_Columns %For each bias column
        Shear_Output_Table{v+2,w+1} = Bias_Of_Shears{v,w}; %Store Bias Values
    end
end

