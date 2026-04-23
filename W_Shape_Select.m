function [High_Bound_WShape,Low_Bound_WShape,plf_High_Bound_Girder,plf_Low_Bound_Girder] = W_Shape_Select(W_Data,W_Labels,plf_Girder)
%W_Shape_Select Summary

%This function is used to determine the AISC W shapes that bound the plf of
%the girder. The input information includes data from the AISC Database
%regarding W shapes.


%Inputs
%W_Data = AISC Database W# Data
%W_Labels = AISC Database W# Labels
%plf_Girder = Calculated girder plf used to find AISC beams

%Ex/ Want to find plf for W36 shape. Have plf calculated to be 288. 
% Find High bound to be W36X318
% FInd Low bound to be W36X282


%Outputs
%High_Bound_WShape = High Bound W Shape Found
%Low_Bound_WShape = Low Bound W Shape Found
%plf_High_Bound_Girder = plf for High Bound Shape 
%plf_Low_Bound_Girder = plf for Low Bound Shape

%Errors
%-6 = calculated girder size too small for specified W shape
%-7 = calculated girder size too big for specified W shape


%Code
    error = 1; %Specify No errors
    SearchValue=1; %Specify Search Value
    for i = 1:length(W_Data(:,1)) %for each W shape ****
        temp_plf = W_Data(i,1); %Get Temporary plf value ****
        if temp_plf > plf_Girder %if W section is larger than found plf value !!!!
            %Search value is = 1, still looking for low bound 
            high_bound = temp_plf; %save value as potential high bound W shape
            %Check for error
            if i == length(W_Data(:,1)) %if on last iteration of loop ****
                low_bound = -6; %give error code of -6
                error = -6; %Error exists with this code
            end

        elseif SearchValue == 1 %if smaller W size and the search value is still 1, then you found the chosen section
            SearchValue = 0; %change search value to 0 becuase the shape has been found
            %Check for error
            if i == 1 %if on first run of loop
                high_bound = -7; %give error code of -7
                low_bound = temp_plf; %save found low bound W shape
                error = -7; %Error exists with this code
            else
                low_bound = temp_plf; %save found low bound W shape
            end
        
        elseif SearchValue == 0 %Value has been found
            SearchValue = 0; %Keep Search value the same
        end
    end
    
    
   %Filter out Error Values
    if error < 0 %if error

        if error == -6 %if the -6 error
            plf_High_Bound_Girder = high_bound; %store last found high bound for graph type !!!!
            plf_Low_Bound_Girder = low_bound; %store low bound value for graph type !!!!
        
            High_Bound_WShape_index = find(W_Data(:,1) == high_bound); %Find index location for high bound W shape !!!! ****

            High_Bound_WShape =  W_Labels(High_Bound_WShape_index,2); %Find high bound W shape name !!!! ****
            Low_Bound_WShape = low_bound; %Input error value !!!!
        else %if the -7 error
            plf_High_Bound_Girder = high_bound; %store low bound value for graph type (High bound has same error as low bound)!!!!
            plf_Low_Bound_Girder = low_bound; %store low bound value for graph type !!!!
            
            Low_Bound_WShape_index = find(W_Data(:,1) == low_bound); %Find index location for low bound W shape !!!! ****

            High_Bound_WShape =  high_bound; %Input error value !!!!
            Low_Bound_WShape = W_Labels(Low_Bound_WShape_index,2); %Find high bound W shape name !!!! ****; %Input error value !!!!
        end

    else %if no errors

        plf_High_Bound_Girder = high_bound; %store high bound value for graph type !!!!
        plf_Low_Bound_Girder = low_bound; %store low bound value for graph type !!!!

        High_Bound_WShape_index = find(W_Data(:,1) == high_bound); %Find index location for high bound W shape !!!! ****
        Low_Bound_WShape_index = find(W_Data(:,1) == low_bound); %Find index location for low bound W shape !!!! ****
    
        High_Bound_WShape = W_Labels(High_Bound_WShape_index,2); %Find high bound W shape name !!!! ****
        Low_Bound_WShape = W_Labels(Low_Bound_WShape_index,2); %Find low bound W shape name !!!! ****
    end
end