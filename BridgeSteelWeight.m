function [SteelWeight_All,SteelWeight_Spacing_1,SteelWeight_Spacing_2] = BridgeSteelWeight(GirderSpacing,SpanLength,SpacingGraph7_9,SpacingGraph9_11,SpacingGraph11plus,SpacingGraphAll)
%BridgeSteelWeight Summary

%This function is used to calculate the total amount of steel that is rquired
%per square foot of bridge surface. It interpolates steel weight value
%using graph data from the NSBA Steel Span Weight Curves. The NSBA Steel
%Span Weight Curves lines were digitized using the Get Data Graph Digitizer
%software. This code determines the steel weight using interpolation of the 
%found datapoints in the input excel files.

%There are a total of 12 NSBA graphs. There are 4 graphs for single span
%bridges, 4 graphs for two span bridges, and 4 graphs for three or more
%span bridges. Each of the 4 graphs include graphs for 7ft-9ft girder
%spacing, 9ft-11ft spacing, 11ft+ spacing, and a graph for all spacings. 

%This code will either have 2 or 3 outputs depending on girder spacing.
%There will always be an output for the caluclated value based on the
%bridges individual spacing and an output based off of the all spacing
%data. If the spacing falls on an overlaping interval then it outputs data
%based on both of the graphs it covers.
%EX/ If girder spacing is 8 ft: It reports steel weight from interpolation
%of 7-9 graph and All graph.
%EX/ If girder spacing is 9ft: It report steel weight from interpiolation
%of 7-9 graph, 9-11 graph, and All Grpah

%This code assumes spans of equal length


%Input Variables

%GirderSpceing = Spacing betwen girders from center to center (ft)
%SpanLength = Length of Max Span of the bridge (ft)
%SpacingGraph7_9 = Excel of found datapints for 7ft-9ft spacing graph 
%SpacingGraph9_11 = Excel of found datapints for 9ft-11ft spacing graph 
%SpacingGraph11plus = Excel of found datapints for 11ft+ spacing graph 
%SpacingGraphAll = Excel of found datapints for All spacing graph 


%Output Variables

%SteelWeight_All = Calculated steel weight per square ft of bridge deck
%surface for All spacing graph (psf)
% - Value of -1 if input span length is outside bleow graph use range limit
% - Value of -2 if input span length is outside above graph use range limit

%SteelWeight_Spacing_1 = Calculated steel weight per square ft of bridge deck
%surface for Specifed spacing graph (psf) 
% - Value from the lower spacing graph if there is an overlaping interval
% - Value of -1 if input span length is outside bleow graph use range limit
% - Value of -2 if input span length is outside above graph use range limit
% - Value of -3 if input girder spacing is outside of graph use range (has
% lower limit value of 7, no upper limit value)

%SteelWeight_Spacing_2 = Calculated steel weight per square ft of bridge deck
%surface for Specifed spacing graph (psf) 
% - Value from the higher spacing graph if there is an overlaping interval 
% - is 0 if there is no interlaping interval
% - Value of -1 if input span length is outside bleow graph use range limit
% - Value of -2 if input span length is outside above graph use range limit




%Code 

%Obtain Graph data
[Data7_9,Labels7_9] = xlsread(SpacingGraph7_9); %7ft - 9ft spacing graph data
[Data9_11,Labels9_11] = xlsread(SpacingGraph9_11); %9ft - 11ft spacing graph data
[Data11plus,Labels11plus] = xlsread(SpacingGraph11plus); %11ft plus spacing graph data
[DataAll,LabelsAll] = xlsread(SpacingGraphAll); %All spacing graph data

%Determine span length input limits
LowerSpanLimit7_9 = min(Data7_9(:,1)); %Minimum allowed span length input value for 7-9 graph
UpperSpanLimit7_9 = max(Data7_9(:,1)); %Minimum allowed span length input value for 7-9 graph

LowerSpanLimit9_11 = min(Data9_11(:,1)); %Minimum allowed span length input value for 9-11 graph
UpperSpanLimit9_11 = max(Data9_11(:,1)); %Minimum allowed span length input value for 9-11 graph

LowerSpanLimit11plus = min(Data11plus(:,1)); %Minimum allowed span length input value for 11+ graph
UpperSpanLimit11plus = max(Data11plus(:,1)); %Minimum allowed span length input value for 11+ graph

LowerSpanLimitAll = min(DataAll(:,1)); %Minimum allowed span length input value for All spacing graph
UpperSpanLimitAll = max(DataAll(:,1)); %Minimum allowed span length input value for All spacing graph



%Calculate interpolated values for All spacing
%Check for Errors
if SpanLength < LowerSpanLimitAll %if below allowed lower span limit
    SteelWeight_All = -1; %show error value of -1
elseif SpanLength > UpperSpanLimitAll %if above allowed upper span limit
    SteelWeight_All = -2; %show error value of -2
else %No errors, continue calculation
    SteelWeight_All = interp1(DataAll(:,1),DataAll(:,2),SpanLength); %calculate interpolated value for All spacing graph
end



%Calculate interpolated vlaues for specified spacing
if GirderSpacing < 7 %if girder spacing is less than 7
    SteelWeight_Spacing_1 = -3; %show error value of -3
    SteelWeight_Spacing_2 = 0; %show value of 0

elseif GirderSpacing < 9 %if girder spaceing is between 7 and 9 
    %Check for Errors
    if SpanLength < LowerSpanLimit7_9 %if below allowed lower span limit
        SteelWeight_Spacing_1 = -1; %show error value of -1
    elseif SpanLength > UpperSpanLimit7_9 %if above allowed upper span limit
        SteelWeight_Spacing_1 = -2; %show error value of -2
    else %No errors, continue calculation
        SteelWeight_Spacing_1 = interp1(Data7_9(:,1),Data7_9(:,2),SpanLength); %calculate interpolated value for 7-9 graph
    end
    SteelWeight_Spacing_2 = 0; %show value of 0
    
elseif GirderSpacing == 9 %if girder spacing is equal to 9 
    %7-9 Graph
    %Check for Errors
    if SpanLength < LowerSpanLimit7_9 %if below allowed lower span limit
        SteelWeight_Spacing_1 = -1; %show error value of -1
    elseif SpanLength > UpperSpanLimit7_9 %if above allowed upper span limit
        SteelWeight_Spacing_1 = -2; %show error value of -2
    else %No errors, continue calculation
        SteelWeight_Spacing_1 = interp1(Data7_9(:,1),Data7_9(:,2),SpanLength); %calculate interpolated value for 7-9 graph
    end
    %9-11 Graph
    %Check for Errors
    if SpanLength < LowerSpanLimit9_11 %if below allowed lower span limit
        SteelWeight_Spacing_2 = -1; %show error value of -1
    elseif SpanLength > UpperSpanLimit9_11 %if above allowed upper span limit
        SteelWeight_Spacing_2 = -2; %show error value of -2
    else %No errors, continue calculation
        SteelWeight_Spacing_2 = interp1(Data9_11(:,1),Data9_11(:,2),SpanLength); %calculate interpolated value for 9-11 graph
    end

elseif GirderSpacing < 11 %if girder spacing is between 9 and 11
    %Check for Errors
    if SpanLength < LowerSpanLimit9_11 %if below allowed lower span limit
        SteelWeight_Spacing_1 = -1; %show error value of -1
    elseif SpanLength > UpperSpanLimit9_11 %if above allowed upper span limit
        SteelWeight_Spacing_1 = -2; %show error value of -2
    else %No errors, continue calculation
        SteelWeight_Spacing_1 = interp1(Data9_11(:,1),Data9_11(:,2),SpanLength); %calculate interpolated value for 9-11 graph
    end
    SteelWeight_Spacing_2 = 0; %show value of 0

elseif GirderSpacing == 11 %if girder spacing is 11
    %9-11 Graph
    %Check for Errors
    if SpanLength < LowerSpanLimit9_11 %if below allowed lower span limit
        SteelWeight_Spacing_1 = -1; %show error value of -1
    elseif SpanLength > UpperSpanLimit9_11 %if above allowed upper span limit
        SteelWeight_Spacing_1 = -2; %show error value of -2
    else %No errors, continue calculation
        SteelWeight_Spacing_1 = interp1(Data9_11(:,1),Data9_11(:,2),SpanLength); %calculate interpolated value for 9-11 graph
    end
    %11+ Graph
    %Check for Errors
    if SpanLength < LowerSpanLimit11plus %if below allowed lower span limit
        SteelWeight_Spacing_2 = -1; %show error value of -1
    elseif SpanLength > UpperSpanLimit11plus %if above allowed upper span limit
        SteelWeight_Spacing_2 = -2; %show error value of -2
    else %No errors, continue calculation
        SteelWeight_Spacing_2 = interp1(Data11plus(:,1),Data11plus(:,2),SpanLength); %calculate interpolated value for 11+ graph
    end

else %if girder spacing is grater than 11
    %Check for Errors
    if SpanLength < LowerSpanLimit11plus %if below allowed lower span limit
        SteelWeight_Spacing_1 = -1; %show error value of -1
    elseif SpanLength > UpperSpanLimit11plus %if above allowed upper span limit
        SteelWeight_Spacing_1 = -2; %show error value of -2
    else %No errors, continue calculation
        SteelWeight_Spacing_1 = interp1(Data11plus(:,1),Data11plus(:,2),SpanLength); %calculate interpolated value for 11+ graph
    end 
    SteelWeight_Spacing_2 = 0; %show value of 0
end

end