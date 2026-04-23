%%%%%%%%%%
% Ethan Payne Programer
% March 20, 2024
%Determine CSI Bridge inputs for POI and Diaphragm locations
%%%%%%%%%%
%Determine the CSI Bridge input values for the points of interest and
%diaphragm locations
%Works for bridges with 1, 2, or 3 spans with equal span lengths
%Formulas for max moment and shear come from AISC Beam tables

%Specified distance output is distance from whatever is closest to the left,
%either the left support ar a pier

clear all;
close all;
clc

%Inputs 
Numb_Spans = 2; %Number of bridge spans
Bridge_Span = 150; %Length of total bridge span in ft

Diphragm_Spacing = 20; %Diaphragm spacing in ft


%Running Code (Do Not Change)

%Deterime Diaphragm location vector
if rem(Bridge_Span,Diphragm_Spacing) == 0 %if span length is divisable by diaphragm spacing
    Diaphragm_Locations = 0:Diphragm_Spacing:Bridge_Span; %Create list of diaphragm locations starting from 0 and going to end of bridge span in specified intervals
else
    remainder = rem(Bridge_Span,Diphragm_Spacing); %find the remainder of span lenth devided by diaphragm spacing (How much length that needs to be corrected for)
    Starting_Diaphragm_Location = remainder/2; %Distance to first diaphragm location
    End_Diaphragm_Location = Bridge_Span - (remainder/2); %Distance to last diaphragm location
    Diaphragm_Locations = Starting_Diaphragm_Location:Diphragm_Spacing:End_Diaphragm_Location; %Create list of diaphragm locations from found starting diaphragm and end diaphragm
end


%Points of interest and diaphragm inputs calculations
if Numb_Spans == 1 %if number of spans is 1
    POI_Pos_Moment_Input = Bridge_Span/2; %Positive moment at midspan
    %Neg Moment at support, do not need to specify location
    %Pos Shear at support, do not need to specify location
    %Neg Shear at support, do not need to specify location

    Diaphragm_Inputs = Diaphragm_Locations; %Diaphragm CSI bridge inputs
    
    %Print in command window
    POI_Pos_Moment_Input 
    Diaphragm_Inputs

elseif Numb_Spans == 2 %if number of spans is 2
    Pier_Location = Bridge_Span/2; %Determine Pier Location
    
    POI_Pos_Moment_Input_Span1 = (3/8)*Pier_Location; %POI for Pos moment in left span (Span 1)
    POI_Pos_Moment_Input_Span2 = Bridge_Span-POI_Pos_Moment_Input_Span1-Pier_Location; %POI for Pos moment in right span (Span 2)
    %Neg Moment at pier, do not need to specify location
    %Pos Shear at pier, do not need to specify location
    %Neg Shear at pier, do not need to specify location

    for i = 1:length(Diaphragm_Locations) %for each of the diaphragms
        Temp_Diaphragm_Location = Diaphragm_Locations(:,i); %For this diaphragm location
        if Temp_Diaphragm_Location <= Pier_Location %If located in left span (Span 1)
            Span1_Diaphragm_Locations(:,i) = Temp_Diaphragm_Location; %Determine Diaphragm location in span 1
        else
            Span2_Diaphragm_Locations(:,i-length(Span1_Diaphragm_Locations)) = Temp_Diaphragm_Location - Pier_Location; %Determine Diaphragm location in span 2
            %i-length(Span1_Diaphpragm_Locations) is used to place the
            %calculated values at the start of the vector, otherwise it
            %would be filled with 0s
        end
    end
    
    %Print in command window
    Pier_Location
    POI_Pos_Moment_Input_Span1
    POI_Pos_Moment_Input_Span2
    Span1_Diaphragm_Locations
    Span2_Diaphragm_Locations


elseif Numb_Spans == 3 %if number of spans is 3
    Pier_1_Location = Bridge_Span/3; %Determine Pier 1 Location (Left)
    Pier_2_Location = (2*Bridge_Span)/3; %Determine Pier 2 Location (Right)
    
    POI_Pos_Moment_Input_Span1 = 0.4*Pier_1_Location; %POI for Pos moment in left end span (Span 1)
    POI_Pos_Moment_Input_Span3 = Bridge_Span-POI_Pos_Moment_Input_Span1-Pier_2_Location; %POI for Pos moment in right end span (Span 3)
    %Neg Moment at pier, do not need to specify location
    %Pos Shear at pier, do not need to specify location
    %Neg Shear at pier, do not need to specify location

    for j = 1:length(Diaphragm_Locations) %for each of the diaphragms
        Temp_Diaphragm_Location = Diaphragm_Locations(:,j); %For this diaphragm location
        if Temp_Diaphragm_Location <= Pier_1_Location %If located in left end span (Span 1)
            Span1_Diaphragm_Locations(:,j) = Temp_Diaphragm_Location; %Determine Diaphragm location in span 1
        elseif Temp_Diaphragm_Location <= Pier_2_Location %If located in mid span (Span 2)
            Span2_Diaphragm_Locations(:,j-length(Span1_Diaphragm_Locations)) = Temp_Diaphragm_Location - Pier_1_Location; %Determine Diaphragm location in span 2
            %j-length(Span1_Diaphpragm_Locations) is used to place the
            %calculated values at the start of the vector, otherwise it
            %would be filled with 0s
        else %if located in right end span (Span 3)
            Span3_Diaphragm_Locations(:,j-length(Span1_Diaphragm_Locations)-length(Span2_Diaphragm_Locations)) = Temp_Diaphragm_Location - Pier_2_Location; %Determine Diaphragm location in span 3
            %j-length(Span1_Diaphpragm_Locations)-length(Span2_Diaphragm_Locations) 
            %is used to place the calculated values at the start of the 
            %vector, otherwise it would be filled with 0s
        end
    end
    
    %Print in command window
    Pier_1_Location
    Pier_2_Location
    POI_Pos_Moment_Input_Span1
    POI_Pos_Moment_Input_Span3
    Span1_Diaphragm_Locations
    Span2_Diaphragm_Locations
    Span3_Diaphragm_Locations

end