function [Controling_Graph,plf_Controling,WShape_High_Bound_Controling,WShape_Controling] = Girder_Size_Select(Total_Span_Length_Input,Numb_Spans_Input,Numb_Girders_Input,Bridge_Width_Input,Girder_Depth_Input)
%Subfunction Version of Girder_Size_Calculations_For_CSIBridge_Models.m

    %%%%%%%%%%
    % Ethan Payne Programer
    % April 9, 2024
    %Determine plf of steel girder for AISC Girder beam clasification for CSI Bridge inputs
    %%%%%%%%%%
    %Input Files
    %Single Span 7-9 Spacing Line.xlsx
    %Single Span 9-11 Spacing Line.xlsx
    %Single Span 11+ Spacing Line.xlsx
    %Single Span All Spacing Line.xlsx
    %Two Span 7-9 Spacing Line.xlsx
    %Two Span 9-11 Spacing Line.xlsx
    %Two Span 11+ Spacing Line.xlsx
    %Two Span All Spacing Line.xlsx
    %Three or More Spans 7-9 Spacing Line.xlsx
    %Three or More Spans 9-11 Spacing Line.xlsx
    %Three or More Spans 11+ Spacing Line.xlsx
    %Three or More Spans All Spacing Line.xlsx
    %"aisc-shapes-database-v16.0.xlsx","Database v16.0"
    
    %Subfunctions
    %BridgeSteelWeight.m - Used to interpolate Total Bridge Steel Weight data
    %from NSBA Steel Span Weight Curves
    %W_Shape_Select.m - Used to determine the High and Low bounds for W Shape
    
    %Error Values
    % 0 = no error, variable just does not exist
    %-1 = input span length is smaller than allowed values in use range
    %-2 = input span length is larger than allowed values in use reange
    %-3 = input girder spacing is smaller than allowed values in use range
    %-4 = input girder depth is smaller than allowed values in use range
    %-5 = input girder depth is larger than allowed values in use range
    %-6 = calculated girder size too small for specified W shape
    %-7 = calculated girder size too big for specified W shape
    %-8 = error in all grphs, use manual input code for more error
    %information
    
    %Uses Span length, number of spans, bridge width, # of girders, girder
    %spacing, and girder depth to caclulate the plf requred for steel I beam
    %girder
    
    %Uses the NSBA Steel Span Weight Curves to determine psf of required steel
    %for entire bridge
    
    %Calculates plf per girder from found psf
    
    %Uses depth of girder and calculated plf of the girder to find upper and
    %lower bound AISC W steel sections from AISC Shapes Database v16.0 Excel
    
    %Want to choose smaller of two Girder selection choices to be conservative
    %in analysis
    
    
    %Inputs
    Total_Span_Length = Total_Span_Length_Input ; %Span length of bridge in ft (120)
    Numb_Spans = Numb_Spans_Input; %Number of spans (1)
    Numb_Girders = Numb_Girders_Input; %Number of girders (5)
    Bridge_Width = Bridge_Width_Input; %Width of the bridge in ft (42)
    Girder_Depth = Girder_Depth_Input; %Girder depth in in (36)
    
    
    %d_e = 3; %Effective overhang one side, in ft
    
    if Bridge_Width == 16 %f the bridge width is 16ft
        %Required for 6ft min girder spaceing used for DOE Trials
        d_e = 2; %Effective overhang one side, in ft
    else %for all other span widths
        d_e = 3; %Effective overhang one side, in ft
    end
    
    %Not needed for subfucntion
    % Output_Type = 4; 
    % %Input Value of 1 for full analysis
    % %Input value of 2 for controling W Shapes and calculated plf values for all
    % %graphs
    % %Input Value of 3 for controling W Shapes for all graphs
    % %Input Value of 4 for High and Low Bound W Shapes of controling graph only
    % %Input Value of 5 for controling W Shape with calculated plf from
    % %controling graph only
    % %Input Vlaue of 6 for only controling W Shape from controling graph
    
    
    
    %Import Steel Shapes Database 
    [AISC_Data,AISC_Labels] = xlsread("aisc-shapes-database-v16.0.xlsx","Database v16.0"); %Import AISC Steel Shapes database
    
    W44_Data = AISC_Data(1:6,:); %Obtain W44 Shape Data
    W44_Labels = AISC_Labels(2:7,:); %Obtain W44 Labels
    
    W40_Data = AISC_Data(7:30,:); %Obtain W40 Shape Data
    W40_Labels = AISC_Labels(8:31,:); %Obtain W40 Labels
    
    W36_Data = AISC_Data(31:59,:); %Obtain W36 Shape Data
    W36_Labels = AISC_Labels(32:60,:); %Obtain W36 Labels
    
    W33_Data = AISC_Data(60:72,:); %Obtain W33 Shape Data
    W33_Labels = AISC_Labels(61:73,:); %Obtain W33 Labels
    
    W30_Data = AISC_Data(73:88,:); %Obtain W30 Shape Data
    W30_Labels = AISC_Labels(74:89,:); %Obtain W30 Labels
    
    W27_Data = AISC_Data(89:105,:); %Obtain W27 Shape Data
    W27_Labels = AISC_Labels(90:106,:); %Obtain W27 Labels
    
    W24_Data = AISC_Data(106:126,:); %Obtain W24 Shape Data
    W24_Labels = AISC_Labels(107:127,:); %Obtain W24 Labels
    
    W21_Data = AISC_Data(127:147,:); %Obtain W21 Shape Data
    W21_Labels = AISC_Labels(128:148,:); %Obtain W21 Labels
    
    W18_Data = AISC_Data(148:170,:); %Obtain W18 Shape Data
    W18_Labels = AISC_Labels(149:171,:); %Obtain W18 Labels
    
    W16_Data = AISC_Data(171:181,:); %Obtain W16 Shape Data
    W16_Labels = AISC_Labels(172:182,:); %Obtain W16 Labels
    
    W14_Data = AISC_Data(182:219,:); %Obtain W14 Shape Data
    W14_Labels = AISC_Labels(183:220,:); %Obtain W14 Labels
    
    W12_Data = AISC_Data(220:248,:); %Obtain W12 Shape Data
    W12_Labels = AISC_Labels(221:249,:); %Obtain W12 Labels
    
    W10_Data = AISC_Data(249:266,:); %Obtain W10 Shape Data
    W10_Labels = AISC_Labels(250:267,:); %Obtain W10 Labels
    
    W8_Data = AISC_Data(267:279,:); %Obtain W8 Shape Data
    W8_Labels = AISC_Labels(268:280,:); %Obtain W8 Labels
    
    W6_Data = AISC_Data(280:286,:); %Obtain W6 Shape Data
    W6_Labels = AISC_Labels(281:287,:); %Obtain W6 Labels
    
    W5_Data = AISC_Data(287:288,:); %Obtain W5 Shape Data
    W5_Labels = AISC_Labels(288:289,:); %Obtain W5 Labels
    
    W4_Data = AISC_Data(289,:); %Obtain W4 Shape Data
    W4_Labels = AISC_Labels(290,:); %Obtain W4 Labels
    
    
    
    
    %Code Calculations
    Girder_Spacing = (Bridge_Width - (2*d_e))/(Numb_Girders-1); %Calculates girder spacing
    Single_Span_Length = Total_Span_Length/Numb_Spans; %Calculates the length of 1 span of the bridge
    
    
    %Standardize Girder depth to be one that fits with AISC Label
    if Girder_Depth > 44 %if girder depth is larger than 44
        Girder_Depth_Label = -5; %Give error value of -5
    
    elseif Girder_Depth >= 40 %if depth is between 40 and 44
        Girder_Midpoint = (40+44)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 44; %Label as a W44
        else %if negative
        Girder_Depth_Label = 40; %Label as a W40
        end
    
    
    elseif Girder_Depth >= 36 %if depth is between 36 and 40
        Girder_Midpoint = (36+40)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 40; %Label as a W40
        else %if negative
        Girder_Depth_Label = 36; %Label as a W36
        end
    
    elseif Girder_Depth >= 33 %if depth is between 33 and 36
        Girder_Midpoint = (33+36)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 36; %Label as a W36
        else %if negative
        Girder_Depth_Label = 33; %Label as a W33
        end
    
    elseif Girder_Depth >= 30 %if depth is between 30 and 36
        Girder_Midpoint = (30+36)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 36; %Label as a W36
        else %if negative
        Girder_Depth_Label = 30; %Label as a W30
        end
    
    elseif Girder_Depth >= 27 %if depth is between 27 and 30
        Girder_Midpoint = (27+30)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 30; %Label as a W30
        else %if negative
        Girder_Depth_Label = 27; %Label as a W27
        end
    
    elseif Girder_Depth >= 24 %if depth is between 24 and 27
        Girder_Midpoint = (24+27)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 27; %Label as a W27
        else %if negative
        Girder_Depth_Label = 24; %Label as a W24
        end
    
    elseif Girder_Depth >= 21 %if depth is between 21 and 24
        Girder_Midpoint = (21+24)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 24; %Label as a W24
        else %if negative
        Girder_Depth_Label = 21; %Label as a W21
        end
    
    elseif Girder_Depth >= 18 %if depth is between 18 and 21
        Girder_Midpoint = (18+21)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 21; %Label as a W21
        else %if negative
        Girder_Depth_Label = 18; %Label as a W18
        end
    
    elseif Girder_Depth >= 16 %if depth is between 16 and 18
        Girder_Midpoint = (16+18)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 18; %Label as a W18
        else %if negative
        Girder_Depth_Label = 16; %Label as a W16
        end
    
    elseif Girder_Depth >= 14 %if depth is between 14 and 16
        Girder_Midpoint = (14+16)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 16; %Label as a W16
        else %if negative
        Girder_Depth_Label = 14; %Label as a W14
        end
    
    elseif Girder_Depth >= 12 %if depth is between 12 and 14
        Girder_Midpoint = (12+14)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 14; %Label as a W14
        else %if negative
        Girder_Depth_Label = 12; %Label as a W12
        end
    
    elseif Girder_Depth >= 10 %if depth is between 10 and 12
        Girder_Midpoint = (10+12)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 12; %Label as a W12
        else %if negative
        Girder_Depth_Label = 10; %Label as a W10
        end
    
    elseif Girder_Depth >= 8 %if depth is between 8 and 10
        Girder_Midpoint = (8+10)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 10; %Label as a W10
        else %if negative
        Girder_Depth_Label = 8; %Label as a W8
        end
    
    elseif Girder_Depth >= 6 %if depth is between 6 and 8
        Girder_Midpoint = (6+8)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 8; %Label as a W8
        else %if negative
        Girder_Depth_Label = 6; %Label as a W6
        end
    
    elseif Girder_Depth >= 5 %if depth is between 5 and 6
        Girder_Midpoint = (5+6)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 6; %Label as a W6
        else %if negative
        Girder_Depth_Label = 5; %Label as a W5
        end
    
    elseif Girder_Depth >= 4 %if depth is between 4 and 5
        Girder_Midpoint = (4+5)/2; %Find midpoint between both types
        ClassificationCalc = Girder_Depth - Girder_Midpoint; %Calculate Number for Classification, if positive then use upper classification, if negative use lower classification
        
        if ClassificationCalc > 0 %if positive
        Girder_Depth_Label = 5; %Label as a W5
        else %if negative
        Girder_Depth_Label = 4; %Label as a W4
        end
    
    else %if depth is below 4
        Girder_Depth_Label = -4; %Give error value of -4
    end
    
    
    
    
    %Determine What Graph to use from # of spans and spacing 
    %Calculate Interpolated Values
    if Numb_Spans == 1 %If there is only 1 span
        %Get interpolated values from created function
        [Weight_All_Spacing,Weight_Specified_Spacing_1,Weight_Specified_Spacing_2] = BridgeSteelWeight(Girder_Spacing,Single_Span_Length,"Single Span 7-9 Spacing Line.xlsx","Single Span 9-11 Spacing Line.xlsx","Single Span 11+ Spacing Line.xlsx","Single Span All Spacing Line.xlsx");
    elseif Numb_Spans == 2 %If there is 2 spans
        %Get interpolated values from created function
        [Weight_All_Spacing,Weight_Specified_Spacing_1,Weight_Specified_Spacing_2] = BridgeSteelWeight(Girder_Spacing,Single_Span_Length,"Two Span 7-9 Spacing Line.xlsx","Two Span 9-11 Spacing Line.xlsx","Two Span 11+ Spacing Line.xlsx","Two Span All Spacing Line.xlsx");
    elseif Numb_Spans >= 3 %If there is 3 or more spans
        %Get interpolated values from created function
        [Weight_All_Spacing,Weight_Specified_Spacing_1,Weight_Specified_Spacing_2] = BridgeSteelWeight(Girder_Spacing,Single_Span_Length,"Three or More Spans 7-9 Spacing Line.xlsx","Three or More Spans 9-11 Spacing Line.xlsx","Three or More Spans 11+ Spacing Line.xlsx","Three or More Spans All Spacing Line.xlsx");
    end
    
    
    
    
    %Calculate Girder plf values from All Spacing Graphs
    %Filter out Error Values
    if Weight_All_Spacing == -1
        plf_Girder_All_Spacing = -1; %if error value of -1 is calculated, show -1 as output
        High_Bound_Girder_All_Spacing_WShape = -1;
        Low_Bound_Girder_All_Spacing_WShape = -1;
        plf_High_Bound_Girder_All_Spacing = -1;
        plf_Low_Bound_Girder_All_Spacing = -1;
    elseif Weight_All_Spacing == -2
        plf_Girder_All_Spacing = -2; %if error value of -2 is calculated, show -2 as output
        High_Bound_Girder_All_Spacing_WShape = -2;
        Low_Bound_Girder_All_Spacing_WShape = -2;
        plf_High_Bound_Girder_All_Spacing = -2;
        plf_Low_Bound_Girder_All_Spacing = -2;
    else %No errors, continue calculation
        plf_All_Steel_All_Spacing = Weight_All_Spacing*Bridge_Width; %Calculates total steel weight in plf
        plf_Girder_All_Spacing = plf_All_Steel_All_Spacing/Numb_Girders; %Calculates girder steel weight in plf
        
        %Check for W Shape
        if Girder_Depth_Label == 44 %If it is a W44
            
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W44_Data,W44_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
        
        elseif Girder_Depth_Label == 40 %If it is a W40
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W40_Data,W40_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
            
        elseif Girder_Depth_Label == 36 %If it is a W36
            
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W36_Data,W36_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 33 %If it is a W33
            
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W33_Data,W33_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 30 %If it is a W30
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W30_Data,W30_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 27 %If it is a W27
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W27_Data,W27_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 24 %If it is a W24
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W24_Data,W24_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 21 %If it is a W21
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W21_Data,W21_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 18 %If it is a W18
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W18_Data,W18_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 16 %If it is a W16
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W16_Data,W16_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 14 %If it is a W14
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W14_Data,W14_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 12 %If it is a W12
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W12_Data,W12_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 10 %If it is a W10
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W10_Data,W10_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 8 %If it is a W8
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W8_Data,W8_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 6 %If it is a W6
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W6_Data,W6_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 5 %If it is a W5
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W5_Data,W5_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 4 %If it is a W4
    
            [High_Bound_Girder_All_Spacing_WShape,Low_Bound_Girder_All_Spacing_WShape,plf_High_Bound_Girder_All_Spacing,plf_Low_Bound_Girder_All_Spacing] = W_Shape_Select(W4_Data,W4_Labels,plf_Girder_All_Spacing); %Find High and Low Bound Shapes
        end
    end
    
    
    
    
    %Calculate Girder plf values from Specified Spacing Graph
    %Filter out Error Values
    if Weight_Specified_Spacing_1 == -1
        plf_Girder_Specified_Spacing_1 = -1; %if error value of -1 is calculated, show -1 as output
        High_Bound_Girder_Specified_Spacing_1_WShape = -1;
        Low_Bound_Girder_Specified_Spacing_1_WShape = -1;
        plf_High_Bound_Girder_Specified_Spacing_1 = -1;
        plf_Low_Bound_Girder_Specified_Spacing_1 = -1;
    elseif Weight_Specified_Spacing_1 == -2
        plf_Girder_Specified_Spacing_1 = -2; %if error value of -2 is calculated, show -2 as output
        High_Bound_Girder_Specified_Spacing_1_WShape = -2;
        Low_Bound_Girder_Specified_Spacing_1_WShape = -2;
        plf_High_Bound_Girder_Specified_Spacing_1 = -2;
        plf_Low_Bound_Girder_Specified_Spacing_1 = -2;
    elseif Weight_Specified_Spacing_1 == -3
        plf_Girder_Specified_Spacing_1 = -3; %if error value of -3 is calculated, show -3 as output
        High_Bound_Girder_Specified_Spacing_1_WShape = -3;
        Low_Bound_Girder_Specified_Spacing_1_WShape = -3;
        plf_High_Bound_Girder_Specified_Spacing_1 = -3;
        plf_Low_Bound_Girder_Specified_Spacing_1 = -3;
    else %No errors, continue calculation
        plf_All_Steel_Specified_Spacing_1 = Weight_Specified_Spacing_1*Bridge_Width; %Calculates total steel weight in plf
        plf_Girder_Specified_Spacing_1 =  plf_All_Steel_Specified_Spacing_1/Numb_Girders; %Calculates girder steel weight in plf
    
        %Check for W Shape
        if Girder_Depth_Label == 44 %If it is a W44
            
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W44_Data,W44_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 40 %If it is a W40
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W40_Data,W40_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 36 %If it is a W36
            
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W36_Data,W36_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 33 %If it is a W33
            
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W33_Data,W33_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 30 %If it is a W30
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W30_Data,W30_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 27 %If it is a W27
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W27_Data,W27_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 24 %If it is a W24
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W24_Data,W24_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 21 %If it is a W21
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W21_Data,W21_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 18 %If it is a W18
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W18_Data,W18_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 16 %If it is a W16
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W16_Data,W16_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 14 %If it is a W14
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W14_Data,W14_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 12 %If it is a W12
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W12_Data,W12_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 10 %If it is a W10
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W10_Data,W10_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 8 %If it is a W8
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W8_Data,W8_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 6 %If it is a W6
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W6_Data,W6_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 5 %If it is a W5
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W5_Data,W5_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 4 %If it is a W4
    
            [High_Bound_Girder_Specified_Spacing_1_WShape,Low_Bound_Girder_Specified_Spacing_1_WShape,plf_High_Bound_Girder_Specified_Spacing_1,plf_Low_Bound_Girder_Specified_Spacing_1] = W_Shape_Select(W4_Data,W4_Labels,plf_Girder_Specified_Spacing_1); %Find High and Low Bound Shapes
        end
    end
    
    
    
    
    %Calculate Girder plf values from Specified Spacing Graph if overlaping
    %Filter out Error Values
    if Weight_Specified_Spacing_2 == 0
        plf_Girder_Specified_Spacing_2 = 0; %if error value of 0 is calculated, show 0 as output
        High_Bound_Girder_Specified_Spacing_2_WShape = 0;
        Low_Bound_Girder_Specified_Spacing_2_WShape = 0;
        plf_High_Bound_Girder_Specified_Spacing_2 = 0;
        plf_Low_Bound_Girder_Specified_Spacing_2 = 0;
    elseif Weight_Specified_Spacing_2 == -1
        plf_Girder_Specified_Spacing_2 = -1; %if error value of -1 is calculated, show -1 as output
        High_Bound_Girder_Specified_Spacing_2_WShape = -1;
        Low_Bound_Girder_Specified_Spacing_2_WShape = -1;
        plf_High_Bound_Girder_Specified_Spacing_2 = -1;
        plf_Low_Bound_Girder_Specified_Spacing_2 = -1;
    elseif Weight_Specified_Spacing_2 == -2
        plf_Girder_Specified_Spacing_2 = -2; %if error value of -2 is calculated, show -2 as output
        High_Bound_Girder_Specified_Spacing_2_WShape = -2;
        Low_Bound_Girder_Specified_Spacing_2_WShape = -2;
        plf_High_Bound_Girder_Specified_Spacing_2 = -2;
        plf_Low_Bound_Girder_Specified_Spacing_2 = -2;
    else %No errors, continue calculation
        plf_All_Steel_Specified_Spacing_2 = Weight_Specified_Spacing_2*Bridge_Width; %Calculates total steel weight in plf
        plf_Girder_Specified_Spacing_2 =  plf_All_Steel_Specified_Spacing_2/Numb_Girders; %Calculates girder steel weight in plf
    
        %Check for W Shape
        if Girder_Depth_Label == 44 %If it is a W44
            
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W44_Data,W44_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 40 %If it is a W40
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W40_Data,W40_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 36 %If it is a W36
            
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W36_Data,W36_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 33 %If it is a W33
            
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W33_Data,W33_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 30 %If it is a W30
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W30_Data,W30_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 27 %If it is a W27
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W27_Data,W27_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 24 %If it is a W24
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W24_Data,W24_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 21 %If it is a W21
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W21_Data,W21_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 18 %If it is a W18
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W18_Data,W18_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 16 %If it is a W16
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W16_Data,W16_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 14 %If it is a W14
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W14_Data,W14_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 12 %If it is a W12
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W12_Data,W12_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 10 %If it is a W10
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W10_Data,W10_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 8 %If it is a W8
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W8_Data,W8_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 6 %If it is a W6
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W6_Data,W6_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 5 %If it is a W5
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W5_Data,W5_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
    
        elseif Girder_Depth_Label == 4 %If it is a W4
    
            [High_Bound_Girder_Specified_Spacing_2_WShape,Low_Bound_Girder_Specified_Spacing_2_WShape,plf_High_Bound_Girder_Specified_Spacing_2,plf_Low_Bound_Girder_Specified_Spacing_2] = W_Shape_Select(W4_Data,W4_Labels,plf_Girder_Specified_Spacing_2); %Find High and Low Bound Shapes
        end
    end
    
    
    %Find Controling Girder size out of the ones fround from the graphs
    if plf_Girder_Specified_Spacing_2 <= 0 %If there is no overlap in specified spacing graphs, or if it has an error
            
        %Filter out Error Values
        if or(plf_Girder_All_Spacing < 0,plf_Girder_Specified_Spacing_1 < 0) %If any Error have occured in plf calc
            if plf_Girder_All_Spacing < 0 %If the All Girder Spacing Graph Has an error
                if plf_Girder_Specified_Spacing_1 < 0 %Specified Girder Spacing also has an error value
                    %Flowchart Answer #1
                    Controling_Graph = "Errors in All Graphs";
                    %Subfunction Specific Code, Allows for loop use
                    plf_Controling = -8; %Show plf Error value
                    WShape_Controling = -8; %Show Shape Error Value
                    WShape_High_Bound_Controling = -8; %Show controling High Bound Value



                    %Original Code
                    % plf_Controling(1,:) = plf_Girder_All_Spacing; %Show plf Error value
                    % WShape_Controling(1,:) = Low_Bound_Girder_All_Spacing_WShape; %Show Shape Error Value
                    % WShape_High_Bound_Controling(1,:) = High_Bound_Girder_All_Spacing_WShape; %Show controling High Bound Value
                    % plf_Controling(2,:) = plf_Girder_Specified_Spacing_1; %Show plf Error value
                    % WShape_Controling(2,:) = Low_Bound_Girder_Specified_Spacing_1_WShape; %Show Shape Error Value
                    % WShape_High_Bound_Controling(2,:) = High_Bound_Girder_Specified_Spacing_1_WShape; %Show controling High Bound Value
                    % plf_Controling(3,:) = plf_Girder_Specified_Spacing_2; %Show plf Error value
                    % WShape_Controling(3,:) = Low_Bound_Girder_Specified_Spacing_2_WShape; %Show Shape Error Value
                    % WShape_High_Bound_Controling(3,:) = High_Bound_Girder_Specified_Spacing_2_WShape; %Show controling High Bound Value
                else %There is no error for specified spacing, it controls
                    %Flowchart Answer #2
                    Controling_Graph = "Specified Spacing Graph 1 Controls";
                    plf_Controling = plf_Girder_Specified_Spacing_1;
                    WShape_Controling = Low_Bound_Girder_Specified_Spacing_1_WShape;
                    WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_1_WShape; 
                end
            elseif plf_Girder_Specified_Spacing_1 < 0 %if there is an error for only for specified spacng graphs
                %Flowchart Answer #3
                Controling_Graph = "All Spacing Graph Controls";
                plf_Controling = plf_Girder_All_Spacing; %Show All Spacing plf calc with no errors
                WShape_Controling = Low_Bound_Girder_All_Spacing_WShape; %Show All Spacing W Shape with no errors
                WShape_High_Bound_Controling = High_Bound_Girder_All_Spacing_WShape;
            end
        else %if there are no errors
            if plf_Girder_All_Spacing <= plf_Girder_Specified_Spacing_1 %if ALl Girder Spacing controls
                %Flowchart Answer #4
                Controling_Graph = "All Spacing Graph Controls";
                plf_Controling = plf_Girder_All_Spacing;
                WShape_Controling = Low_Bound_Girder_All_Spacing_WShape;
                WShape_High_Bound_Controling = High_Bound_Girder_All_Spacing_WShape;
            else %if Specified Spacing controls
                %Flowchart Answer #5
                Controling_Graph = "Specified Spacing Graph 1 Controls";
                plf_Controling = plf_Girder_Specified_Spacing_1;
                WShape_Controling = Low_Bound_Girder_Specified_Spacing_1_WShape;
                WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_1_WShape;
            end
        end
    else %if there is no error for the overlaping graph and it does exist
        
        %Filter out Error Values
        if or(plf_Girder_All_Spacing < 0,plf_Girder_Specified_Spacing_1 < 0) %If any Error have occured in plf calc
            if plf_Girder_All_Spacing < 0 %If the All Girder Spacing Graph Has an error
                if plf_Girder_Specified_Spacing_1 < 0 %if Graph 1 also had an error
                    %Flowchart Answer #6
                    Controling_Graph = "Specified Spacing Graph 2 Controls";
                    plf_Controling = plf_Girder_Specified_Spacing_2; %Graph 2 controls
                    WShape_Controling = Low_Bound_Girder_Specified_Spacing_2_WShape; %Graph 2 controls
                    WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_2_WShape; %Graph 2 controls
                else %Graph 1 does not have an error
                    if plf_Girder_Specified_Spacing_1 <= plf_Girder_Specified_Spacing_2 %if Graph 1 controls
                        %Flowchart Answer #7
                        Controling_Graph = "Specifed Spacing Graph 1 Controls";
                        plf_Controling = plf_Girder_Specified_Spacing_1;
                        WShape_Controling = Low_Bound_Girder_Specified_Spacing_1_WShape;
                        WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_1_WShape;
                    else %if Graph 2 controls
                        %Flowchart Answer #8
                        Controling_Graph = "Specifed Spacing Graph 2 Controls";
                        plf_Controling = plf_Girder_Specified_Spacing_2;
                        WShape_Controling = Low_Bound_Girder_Specified_Spacing_2_WShape;
                        WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_2_WShape;
                    end
                end
            else %there is an error for only for specified spacng graph 1
                if plf_Girder_All_Spacing <= plf_Girder_Specified_Spacing_2 %if ALl Girder Spacing controls
                    %Flowchart Answer #9
                    Controling_Graph = "All Spacing Graph Controls";
                    plf_Controling = plf_Girder_All_Spacing;
                    WShape_Controling = Low_Bound_Girder_All_Spacing_WShape;
                    WShape_High_Bound_Controling = High_Bound_Girder_All_Spacing_WShape;
                else %if Specified Spacing 2 controls
                    %Flowchart Answer #10
                    Controling_Graph = "Specifed Spacing Graph 2 Controls";
                    plf_Controling = plf_Girder_Specified_Spacing_2;
                    WShape_Controling = Low_Bound_Girder_Specified_Spacing_2_WShape;
                    WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_2_WShape;
                end
            end
        else %if there are no errors
            if plf_Girder_All_Spacing <= and(plf_Girder_Specified_Spacing_1,plf_Girder_Specified_Spacing_2) %if ALl Girder Spacing controls
                %Flowchart Answer #11
                Controling_Graph = "All Spacing Graph Controls";
                plf_Controling = plf_Girder_All_Spacing;
                WShape_Controling = Low_Bound_Girder_All_Spacing_WShape;
                WShape_High_Bound_Controling = High_Bound_Girder_All_Spacing_WShape;
            elseif plf_Girder_Specified_Spacing_1 <= plf_Girder_Specified_Spacing_2 %if Speccifed Graph Spacing 1 controls
                %Flowchart Answer #12
                Controling_Graph = "Specifed Spacing Graph 1 Controls";
                plf_Controling = plf_Girder_Specified_Spacing_1;
                WShape_Controling = Low_Bound_Girder_Specified_Spacing_1_WShape;
                WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_1_WShape;
            else %if Speccifed Graph Spacing 2 controls
                %Flowchart Answer #13
                Controling_Graph = "Specified Spacing Graph 2 Controls";
                plf_Controling = plf_Girder_Specified_Spacing_2;
                WShape_Controling = Low_Bound_Girder_Specified_Spacing_2_WShape;
                WShape_High_Bound_Controling = High_Bound_Girder_Specified_Spacing_2_WShape;
            end
        end
    end 
       
    
    
    %Outputs
    
    %Not needed for subfunction
    % if Output_Type == 1 %Output all important information
    %     Girder_Depth
    %     Girder_Depth_Label
    %     plf_Girder_All_Spacing
    %     High_Bound_Girder_All_Spacing_WShape
    %     Low_Bound_Girder_All_Spacing_WShape
    % 
    %     Girder_Depth_Label
    %     plf_Girder_Specified_Spacing_1
    %     High_Bound_Girder_Specified_Spacing_1_WShape
    %     Low_Bound_Girder_Specified_Spacing_1_WShape
    % 
    %     Girder_Depth_Label
    %     plf_Girder_Specified_Spacing_2
    %     High_Bound_Girder_Specified_Spacing_2_WShape
    %     Low_Bound_Girder_Specified_Spacing_2_WShape
    % 
    %     Controling_Graph
    %     plf_Controling
    %     WShape_High_Bound_Controling
    %     WShape_Controling
    % elseif Output_Type == 2 %Output controling shapes with calculated plf all graphs
    %     plf_Girder_All_Spacing
    %     Low_Bound_Girder_All_Spacing_WShape
    % 
    %     plf_Girder_Specified_Spacing_1
    %     Low_Bound_Girder_Specified_Spacing_1_WShape
    % 
    %     plf_Girder_Specified_Spacing_2
    %     Low_Bound_Girder_Specified_Spacing_2_WShape
    % 
    %     Controling_Graph
    %     plf_Controling
    %     WShape_Controling
    % elseif Output_Type == 3 %Output controling shapes only all graphs
    %     Low_Bound_Girder_All_Spacing_WShape
    %     Low_Bound_Girder_Specified_Spacing_1_WShape
    %     Low_Bound_Girder_Specified_Spacing_2_WShape
    % 
    %     Controling_Graph
    %     WShape_Controling
    % elseif Output_Type == 4 %Output the W shape outputs from controling graph only 
    %     Controling_Graph
    %     plf_Controling
    %     WShape_High_Bound_Controling
    %     WShape_Controling
    % elseif Output_Type == 5 %Output only the controling shape with plf value
    %     Controling_Graph
    %     plf_Controling
    %     WShape_Controling
    % elseif Output_Type == 6 %Output only controling shape
    %     Controling_Graph
    %     WShape_Controling
    % end



end