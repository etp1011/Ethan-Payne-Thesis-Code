function [Predicted_W_Shapes, Error_Check, High_and_Low_Bounds] = Girder_Size_Predictions_Flange_Width_SUBF(Girder_Depth_Input,Flange_Width_Input,Depth_Percent_Error_Input,Flange_Width_Percent_Error_Input,AISC_W_Shape_Data_Input,AISC_W_Shape_Labels_Input )
%%%%%%%%%%
% Ethan Payne Programer
% September 22, 2024
%Determine AISC W Shape of girder using Depth and Width of flange
%Subfunction
%%%%%%%%%%
%Input Files
%"aisc-shapes-database-v16.0.xlsx","Database v16.0"


%Uses Girder Depth and Width of flange to predict AISC W Shape
%Output provides list of possible predicted values depending an error input

%Errors
%The Variable Error_Check will print if there is a error in prediction
%Error_Check is is the form of [#; 
%                               #;
%                               #; 
%                               #];
%The top two rows contains depth errors while the bottom two row contains 
%flange errors. For each pair of rows, the top of the two numbers contain
%High bound Errors while the bottom of the two numbers contains Low Bound 
%Errors


%High bound and Low Bound Output
%The variable High_and_Low_Bounds contains data on the high bound value and
%low bound value for both depth and flange width. 
%High_and Low Bounds is is the form of [#; 
%                                       #;
%                                       #; 
%                                       #];
%The top two rows contains depth bounds while the bottom two row contains 
%flange bounds. For each pair of rows, the top of the two numbers contain
%the High bound value while the bottom of the two numbers contains the Low 
%Bound value


%Error Values
% 1 Value Means No Error.
% -1 Value Means that either the high bound or low bound shape was not 
% found in any itteration of the loop, therefore the last shape in list is 
% used for that value instead. Error is critical for high bound, but non 
% critical for low bound.
% -2 Value Means that either the high bound or low bound shape was selected
% on the first itteration of the loop, therefore the first shape in list is
% used for that value instead. Error is critical for low bound, but non
% critical for high bound.



    %%
    
    
    %Inputs
    
    Girder_Depth = Girder_Depth_Input; %Girder depth in in (36)
    Flange_Width = Flange_Width_Input; %Flange Width in in (12)
    
    Depth_Percent_Error = Depth_Percent_Error_Input; %The % Error in measuring girder depth (= 3 from literature)
    Flange_Width_Percent_Error = Flange_Width_Percent_Error_Input; %The % Error in measuring flange width (=5 from literature)
    
    
    
    %%
    %Import Steel Shapes Database 
    %Import from main code to speed up code
    %[AISC_Data,AISC_Labels] = xlsread("aisc-shapes-database-v16.0.xlsx","Database v16.0"); %Import AISC Steel Shapes database
    
    
    %Seperate W Shapes from Rest of Data
    % AISC_W_Shape_Data = AISC_Data(1:289,:); %Store W Shape Data Seprately
    % AISC_W_Shape_Labels = AISC_Labels(2:290,:); %Store W SHape Labels
    
    AISC_W_Shape_Data = AISC_W_Shape_Data_Input; %Store W Shape Data Seprately
    AISC_W_Shape_Labels = AISC_W_Shape_Labels_Input; %Store W SHape Labels
    
    
    %Sort W Shape Data and Labels by Depth or Flange Width
    Depth_of_Girder_Column_Number = 3; %Column number where Depth infromation is contained in AISC_Data
    Width_of_Flange_Column_Number = 8; %Column number where Flange Width infromation is contained in AISC_Data
    
    
    [AISC_Girder_Depth_Sorted, Depth_Sorting_Index] = sort(AISC_W_Shape_Data(:,Depth_of_Girder_Column_Number),'descend'); %Sort AISC Girder Depths
    AISC_Data_Sorted_by_Girder_Depth = AISC_W_Shape_Data(Depth_Sorting_Index,:); %All AISC Data sorted by Depth of Girder
    AISC_Labels_Sorted_by_Girder_Depth =  AISC_W_Shape_Labels(Depth_Sorting_Index,:); %All AISC Labels sorted by Depth of Girder
    
    
    %Code Calculations
    Depth_Percent_Error_Decimal = Depth_Percent_Error/100; %Convert Input % error into decimal form
    Flange_Width_Percent_Error_Decimal = Flange_Width_Percent_Error/100; %Convert Input % error into decimal form
    
    %%
    %Depth Calculations
    Depth_Error_Range = Girder_Depth*Depth_Percent_Error_Decimal; %Range of error for Girder Depth
    Depth_Error_High = Girder_Depth + Depth_Error_Range; %High value for Girder Depth Error
    Depth_Error_Low = Girder_Depth - Depth_Error_Range; %Low Value for Girder Depth Error
    
    
    Depth_High_Found = 0; %Value used to determine High bound Shape has been found
    Depth_Low_Found = 0; %Value used to determine if Low bound Shape has been found
    
    for d = 1:length(AISC_Girder_Depth_Sorted) %For each girder depth value
        if Depth_High_Found == 0 %If High bound Girder Not Yet found
            if d == length(AISC_Girder_Depth_Sorted) %If on last itteration of loop and High value still has not been found
                if Depth_Error_High >= AISC_Girder_Depth_Sorted(d) %If High Bound Is Larger Than the Depth of Last Value
                    if d == 1 %If on first itteration of the loop
                        Depth_High_Found = -2; %Store Error Value
                    else
                        Depth_High_Found = 1; %Depth High Bound Shape Has Been Found
                    end
                else %High Bound Shape has not been found
                    Depth_High_Found = -1; %Store Error Value
                end
                Depth_High_Value = AISC_Girder_Depth_Sorted(d); %Store the Depth High value
                Depth_High_Value_Row_Index = d; %Store High Value Row Index Value
            elseif AISC_Girder_Depth_Sorted(d) > Depth_Error_High %If depth of shape is larger than High error depth
                Throw_Away = 0; %Nothing Happens
            else %Then It is first girder that is below the High Depth Error
                if d == 1 %If on first itteration of the loop
                    Depth_High_Found = -2; %Store Error Value
                else
                    Depth_High_Found = 1; %Depth High Bound Shape Has Been Found
                end
                Depth_High_Value = AISC_Girder_Depth_Sorted(d); %Store the Depth High value
                Depth_High_Value_Row_Index = d; %Store High Value Row Index Value
            end
        end
       
        if Depth_Low_Found == 0 %If Low bound Girder Not Yet Found
            if d == length(AISC_Girder_Depth_Sorted) %If on last itteration of loop and Low value still has not been found
                if d == 1 %If on first itteration of the loop
                    if AISC_Girder_Depth_Sorted(d) < Depth_Error_Low %If Low Bound Depth is Smaller than selected Depth
                        Depth_Low_Found = -2; %Store Error Value
                        Depth_Low_Value = AISC_Girder_Depth_Sorted(d); %Store Current Depth as Low Value
                        Depth_Low_Value_Row_Index = d; %Store Low Value Row Index Value
                    else %Selected Depth is larger than Low Bound
                        Depth_Low_Found = -1; %Store Error Value
                        Depth_Low_Value = AISC_Girder_Depth_Sorted(d); %Store Current Depth as Low Value
                        Depth_Low_Value_Row_Index = d; %Store Low Value Row Index Value
                    end
                else
                    if AISC_Girder_Depth_Sorted(d) < Depth_Error_Low %If Low Bound Depth is Larger than selected Depth
                        Depth_Low_Found = 1; %Value found on last itteration of the loop
                        Depth_Low_Value = Previous_d_Depth;  %Store Depth Low Value
                        Depth_Low_Value_Row_Index = d-1; %Store Low Value Row Index Value
                    else %Selected Flange Width is larger than Low Bound
                        Depth_Low_Found = -1; %Store Error Value
                        Depth_Low_Value = AISC_Girder_Depth_Sorted(d); %Store Current Depth as Low Value
                        Depth_Low_Value_Row_Index = d; %Store Low Value Row Index Value
                    end
                end
            elseif AISC_Girder_Depth_Sorted(d) > Depth_Error_Low %If Depth of shape is larger than Low error Depth
                Throw_Away = 0; %Nothing Happens
            else %Then it is the first gierder that is below the Low Depth Error
                %Previous Itteration of loop is the Low Depth Value
                if d == 1 %If on first itteration of the loop
                    Depth_Low_Found = -2; %Store Error Value
                    Depth_Low_Value = AISC_Girder_Depth_Sorted(d); %Store Depth Low Value
                    Depth_Low_Value_Row_Index = d; %Store Low Value Row Index Value
                else
                    Depth_Low_Found = 1; %Depth Low Bound Shape Has Been Found
                    Depth_Low_Value = Previous_d_Depth; %Store Depth Low Value
                    Depth_Low_Value_Row_Index = d-1; %Store Low Value Row Index Value
                end 
            end
            Previous_d_Depth = AISC_Girder_Depth_Sorted(d); %Store Previous Depth Value
        end
    end
    
    %Prediction options Based on depth
    Depth_Prediction_Values = AISC_Girder_Depth_Sorted(Depth_High_Value_Row_Index:Depth_Low_Value_Row_Index); %Store Range of Depth Values
    Depth_W_Shape_Predictions_Data = AISC_Data_Sorted_by_Girder_Depth(Depth_High_Value_Row_Index:Depth_Low_Value_Row_Index,:); %Store Predicted W Shape Data Based on Depth
    Depth_W_Shape_Predictions_Labels = AISC_Labels_Sorted_by_Girder_Depth(Depth_High_Value_Row_Index:Depth_Low_Value_Row_Index,:); %Store Predicted W Shape Labels Based on Depth
    
    
    %%
    %Flange Width Calculations
    [AISC_Girder_Flange_Width_Sorted, Flange_Width_Sorting_Index] = sort(Depth_W_Shape_Predictions_Data(:,Width_of_Flange_Column_Number),'descend'); %Sort Remaining AISC W Shapes by Flange Width
    AISC_Data_Sorted_by_Flange_Width = Depth_W_Shape_Predictions_Data(Flange_Width_Sorting_Index,:); %Remaining AISC Data sorted by Flange_Width
    AISC_Labels_Sorted_by_Flange_Width =  Depth_W_Shape_Predictions_Labels(Flange_Width_Sorting_Index,:); %Remaining AISC Labels sorted Flange_Width
    
    
    Flange_Width_Error_Range = Flange_Width*Flange_Width_Percent_Error_Decimal; %Range of error for Girder Depth
    Flange_Width_Error_High = Flange_Width + Flange_Width_Error_Range; %High value for Girder Depth Error
    Flange_Width_Error_Low = Flange_Width - Flange_Width_Error_Range; %Low Value for Girder Depth Error
    
    Flange_Width_High_Found = 0; %Value used to determine High bound Shape has been found
    Flange_Width_Low_Found = 0; %Value used to determine if Low bound Shape has been found
    
    for f_w = 1:length(AISC_Girder_Flange_Width_Sorted) %For each girder from predicted depth
        if Flange_Width_High_Found == 0 %If High bound Girder Not Yet found
            if f_w == length(AISC_Girder_Flange_Width_Sorted) %If on last itteration of loop and High value still has not been found
                if Flange_Width_Error_High >= AISC_Girder_Flange_Width_Sorted(f_w) %If High Bound Is Larger Than the Flange_Width of Last Value
                    if f_w == 1 %If on first itteration of the loop
                        Flange_Width_High_Found = -2; %Store Error Value
                    else
                        Flange_Width_High_Found = 1; %Flange_Width High Bound Shape Has Been Found
                    end
                else %High Bound Shape has not been found
                    Flange_Width_High_Found = -1; %Store Error Value
                end
                Flange_Width_High_Value = AISC_Girder_Flange_Width_Sorted(f_w); %Store the Flange Width High value
                Flange_Width_High_Value_Row_Index = f_w; %Store High Value Row Index Value
            elseif AISC_Girder_Flange_Width_Sorted(f_w) > Flange_Width_Error_High %If depth of shape is larger than High error depth
                Throw_Away = 0; %Nothing Happens
            else %Then It is first girder that is below the High Flange_Width Error
                if f_w == 1 %If on first itteration of the loop
                    Flange_Width_High_Found = -2; %Store Error Value
                else
                    Flange_Width_High_Found = 1; %Flange_Width High Bound Shape Has Been Found
                end
                Flange_Width_High_Value = AISC_Girder_Flange_Width_Sorted(f_w); %Store the Flange_Width High value
                Flange_Width_High_Value_Row_Index = f_w; %Store High Value Row Index Value
            end
        end
       
        if Flange_Width_Low_Found == 0 %If Low bound Girder Not Yet Found
            if f_w == length(AISC_Girder_Flange_Width_Sorted) %If on last itteration of loop and Low value still has not been found
                if f_w == 1 %If on first itteration of the loop
                    if AISC_Girder_Flange_Width_Sorted(f_w) < Flange_Width_Error_Low %If Low Bound Flange Width is Larger than selected Flange Width
                        Flange_Width_Low_Found = -2; %Store Error Value
                        Flange_Width_Low_Value = AISC_Girder_Flange_Width_Sorted(f_w); %Store Current Flange_Width as Low Value
                        Flange_Width_Low_Value_Row_Index = f_w; %Store Low Value Row Index Value
                    else %Selected Flange Width is larger than Low Bound
                        Flange_Width_Low_Found = -1; %Store Error Value
                        Flange_Width_Low_Value = AISC_Girder_Flange_Width_Sorted(f_w); %Store Current Flange_Width as Low Value
                        Flange_Width_Low_Value_Row_Index = f_w; %Store Low Value Row Index Value
                    end
                else
                    if AISC_Girder_Flange_Width_Sorted(f_w) < Flange_Width_Error_Low %If Low Bound Flange Width is Smaller than selected Flange Width
                        Flange_Width_Low_Found = 1; %Value found on last itteration of the loop
                        Flange_Width_Low_Value = Previous_f_w_Depth;  %Store Flange_Width Low Value
                        Flange_Width_Low_Value_Row_Index = f_w-1; %Store Low Value Row Index Value
                    else %Selected Flange Width is larger than Low Bound
                        Flange_Width_Low_Found = -1; %Store Error Value
                        Flange_Width_Low_Value = AISC_Girder_Flange_Width_Sorted(f_w); %Store Current Flange_Width as Low Value
                        Flange_Width_Low_Value_Row_Index = f_w; %Store Low Value Row Index Value
                    end
                end
            elseif AISC_Girder_Flange_Width_Sorted(f_w) > Flange_Width_Error_Low %If Flange_Width of shape is larger than Low error Flange_Width
                Throw_Away = 0; %Nothing Happens
            else %Then it is the first gierder that is below the Low Flange_Width Error
                %Previous Itteration of loop is the Low Flange_Width Value
                if f_w == 1 %If on first itteration of the loop
                    Flange_Width_Low_Found = -2; %Store Error Value
                    Flange_Width_Low_Value = AISC_Girder_Flange_Width_Sorted(f_w); %Store Flange_Width Low Value
                    Flange_Width_Low_Value_Row_Index = f_w; %Store Low Value Row Index Value
                else
                    Flange_Width_Low_Found = 1; %Flange_Width Low Bound Shape Has Been Found
                    Flange_Width_Low_Value = Previous_f_w_Depth; %Store Flange_Width Low Value
                    Flange_Width_Low_Value_Row_Index = f_w-1; %Store Low Value Row Index Value
                end 
            end
            Previous_f_w_Depth = AISC_Girder_Flange_Width_Sorted(f_w); %Store Previous Depth Value
        end
    end
    
    
    %Prediction options Based on depth and flange width
    Flange_Width_Prediction_Values = AISC_Girder_Flange_Width_Sorted(Flange_Width_High_Value_Row_Index:Flange_Width_Low_Value_Row_Index); %Store Range of Flange_Width Values
    Flange_Width_W_Shape_Predictions_Data = AISC_Data_Sorted_by_Flange_Width(Flange_Width_High_Value_Row_Index:Flange_Width_Low_Value_Row_Index,:); %Store Predicted W Shape Data Based on Flange_Width
    Flange_Width_W_Shape_Predictions_Labels = AISC_Labels_Sorted_by_Flange_Width(Flange_Width_High_Value_Row_Index:Flange_Width_Low_Value_Row_Index,:); %Store Predicted W Shape Labels Based on Flange_Width
    
    %%
    %Show Pridiction Shapes Sorted Based on WShape Size
    Unsorted_Predicted_Shapes = Flange_Width_W_Shape_Predictions_Labels(:,3); %Store Unsorted Predicted Shape Values
    
    for i = 1:length(Unsorted_Predicted_Shapes) %For each Predicted Value
        W_Shape_String = regexp(Unsorted_Predicted_Shapes{i},'W(\d+)','tokens'); %Find Number after W in String format
        W_Shape_Doubles(i,1) = str2double(W_Shape_String{1}); %Convert String to Double (Number)
    
        plf_String = regexp(Unsorted_Predicted_Shapes{i},'X([\d\.]+)','tokens'); %Find Number after X in String Format
        plf_Doubles(i,1) = str2double(plf_String{1}); %Convert String to Double
    end
    
    [Predicted_W_Shapes_Matrix, Predicted_W_Shapes_Index] = sortrows([W_Shape_Doubles,plf_Doubles], [1, 2],"descend"); %Sort the W Shapes in Decending Order
    
    Predicted_W_Shapes = Unsorted_Predicted_Shapes(Predicted_W_Shapes_Index,:); %Sort List of W shapes
    Prediction_Data_Sorted = Flange_Width_W_Shape_Predictions_Data(Predicted_W_Shapes_Index,:); %Sort Predicted Data by W Shape
    Prediction_Labels_Sorted = Flange_Width_W_Shape_Predictions_Labels(Predicted_W_Shapes_Index,:); %Sort Predicted Data by W Shape
    
    % Predicted_W_Shapes %Print to user the range of possible W Shapes
    
    
    %%
    %Errors and other
    
    Error_Check = [Depth_High_Found; Depth_Low_Found; Flange_Width_High_Found; Flange_Width_Low_Found];

    High_and_Low_Bounds = [Depth_Error_High; Depth_Error_Low; Flange_Width_Error_High; Flange_Width_Error_Low];
    
    
    
    % if any(Error_Check(:) ~= 1); %If any error values exist (Not equal to 1)
    %     Error_Check %Print the Error for the user
    % end

end
