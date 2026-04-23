%%%%%%%%%%
% Ethan Payne Programer
% April 14, 2024
%Determine plf of steel girder for AISC Girder beam clasification for CSI
%Bridge inputs for Multi Span Bridges
%%%%%%%%%%

%Uses Girder_Size_Select.m subfucntion to determine W Shapes for all trials
%Uses Error_8_Girder_Size_Select.m subfucntion to determine W Shapes for -8
%error trials

clear all
close all
clc


[Multi_Span_Raw_Factors, Multi_Span_Labels] = xlsread("DOE #4 Multi Span Realistic Design #3.xlsx");

Multi_Span_Factors = Multi_Span_Raw_Factors(:,1:6); %Only Trial Factors

for i = 1:length(Multi_Span_Factors) %For each of the 100 trials
    Temp_Span_Length = Multi_Span_Factors(i,1); %Span length for trial i
    Temp_Numb_Spans = Multi_Span_Factors(i,2); %Always = 1 due to being Multi span bridges
    Temp_Numb_Girders = Multi_Span_Factors(i,3); %# of Girders for trial i
    Temp_Width = Multi_Span_Factors(i,4); %Bridge width for trial i
    Temp_Depth_of_Slab= Multi_Span_Factors(i,5); %Slab Depth for trial i
    Temp_Girder_Depth = Multi_Span_Factors(i,6); %Girder Depth for trial i

    %Find Controling values from subfunction
    %Number of spans input = 1 because all are Multi span bridges
    [Temp_Controling_Graph,Temp_plf_Controling,Temp_WShape_High_Bound_Controling,Temp_WShape_Controling] = Girder_Size_Select(Temp_Span_Length,Temp_Numb_Spans,Temp_Numb_Girders,Temp_Width,Temp_Girder_Depth);

    %Store contoling values for trial i
    Multi_Span_Data{i,1} = i; %Trial #
    Multi_Span_Data{i,2} = Temp_Controling_Graph; %Controling graph for trial i
    Multi_Span_Data{i,3} = Temp_plf_Controling; %Controling plf value for trial i
    Multi_Span_Data{i,4} = Temp_WShape_High_Bound_Controling; %Controling High Bound for trial i
    Multi_Span_Data{i,5} = Temp_WShape_Controling; %Controling W Shape for trial
    
    %Store error values
    Multi_Span_Data_Errors(i,1) = i; %Trial #
    Multi_Span_Data_Errors(i,2) = double(Temp_Controling_Graph); %Controling graph for trial i
    Multi_Span_Data_Errors(i,3) = double(Temp_plf_Controling); %Controling plf value for trial i
    if iscell(Temp_WShape_High_Bound_Controling) == 1 %If there is no error for high bound
        Multi_Span_Data_Errors(i,4) = NaN; %No Input Value
    else %There is an error
        Multi_Span_Data_Errors(i,4) = double(Temp_WShape_High_Bound_Controling); %Controling High Bound error
    end

    if iscell(Temp_WShape_Controling) == 1 %If there is no error for low bound
        Multi_Span_Data_Errors(i,5) = NaN; %No Input Value
    else
        Multi_Span_Data_Errors(i,5) = double(Temp_WShape_Controling); %Controling Low Bound error
    end
    
    i %Used to tell proccesing time

end



%%

%Create Error list for each trial
for j = 1:length(Multi_Span_Data_Errors) %For each trial
    Multi_Span_Data_Error_List(j,1) = max(Multi_Span_Data_Errors(j,4),Multi_Span_Data_Errors(j,5)); %Find controling error value for trial
end


%Controling shape list
for k = 1:length(Multi_Span_Data_Error_List) %For each trial
    Multi_Span_WShape_List{k,1} = k; %Store trial number
    Multi_Span_WShape_List{k,2} = Multi_Span_Data_Error_List(k); %Store error code
    if Multi_Span_Data_Error_List(k) == -6 %if -6 error code
        Multi_Span_WShape_List{k,3} = Multi_Span_Data{k,2}; %Store controling graph
        Multi_Span_WShape_List{k,4} = Multi_Span_Data{k,3}; %Store use plf value
        Multi_Span_WShape_List{k,5} = Multi_Span_Data{k,4}; %Store High bound W Shape
        Multi_Span_WShape_List{k,6} = 'None'; %No errors for redone calcuation
    elseif Multi_Span_Data_Error_List(k) == -7 %if -7 error code
        Multi_Span_WShape_List{k,3} = Multi_Span_Data{k,2}; %Store controling graph
        Multi_Span_WShape_List{k,4} = Multi_Span_Data{k,3}; %Store use plf value
        Multi_Span_WShape_List{k,5} = Multi_Span_Data{k,5}; %Store W Shape
        Multi_Span_WShape_List{k,6} = 'None'; %No errors for redone calcuation

    elseif Multi_Span_Data_Error_List(k) == -8 %if -8 error code
        Error_Trial_Factors = Multi_Span_Factors(k,:);
        [Error_Controling_Graph,Error_plf_Controling,Error_WShape_High_Bound_Controling,Error_WShape_Controling] = Error_8_Girder_Size_Select(Error_Trial_Factors(1),Error_Trial_Factors(2),Error_Trial_Factors(3),Error_Trial_Factors(4),Error_Trial_Factors(6));
        Multi_Span_WShape_List{k,3} = Error_Controling_Graph; %Store controling graph
        Multi_Span_WShape_List{k,4} = Error_plf_Controling; %Store used plf value
        if iscell(Error_WShape_Controling{1}) == 1 %There is no -6 error for recount
            Multi_Span_WShape_List{k,5} = Error_WShape_Controling{1}; %Store W Shape
            Multi_Span_WShape_List{k,6} = 'None';
        else %There is a -6 error
            Multi_Span_WShape_List{k,5} = Error_WShape_High_Bound_Controling{1}; %Store High Bound W Shape
            Multi_Span_WShape_List{k,6} = Error_WShape_Controling{1}; %Store error code
        end
    else %if no errors
        Multi_Span_WShape_List{k,3} = Multi_Span_Data{k,2}; %Store controling graph
        Multi_Span_WShape_List{k,4} = Multi_Span_Data{k,3}; %Store use plf value
        Multi_Span_WShape_List{k,5} = Multi_Span_Data{k,5}; %Store W Shape
        Multi_Span_WShape_List{k,6} = 'None'; %No errors for redone calcuation
    end
    k %Used to tell processing time
end


