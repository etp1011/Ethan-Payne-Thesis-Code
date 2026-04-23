function [Beta_Estimate, New_x_Stars] = Reliability_Index_Code_Modified_SUBF(g_Input, Limit_State_Variables_Input, Limit_State_Variables_U_Input,Initial_Design_Points_Input, Equivelent_Means_Input, Equivelent_SDs_Input, Gamma_Input, Theta_Input)
%Uses the Rackwitz-Fiessler modified matrix procedure as outlined in
%"Reliability of Structures" by Nowack (5.4) as a baseline

%Used "A robust approximation method for nonlinear cases of structural
%reliability analysis" by Mohammad Amin Roudak and others to modify
%procedure to help with convergence

%User Inputs:
%g_Input = Limit State Function
%Limit_State_Variables_Input = Vector of all random variables within the limit state function, Note: last variable in vector is the variable that we calculate the design point for
%Initial_Design_Points_Input = Vector of Initial Design Points (x*) for all but 1 variable
%Equivelent_Means_Input = Vector of Equivilent Normal Means for the Distributions of the Random Variables (All Variables)
%Equivelent_SDs_Input = Vector of Equivilent Normal Standard Deviations for the Distributions of the Random Variables (All Variables)
%Gamma_Input = Adjusting parameter - Solve for g = Gamma*g(x*) instead of g = 0
%Theta_Input = Step Parameter


%Outputs:
%Beta_Estimate = Reliability Index Estimate from this itteration
%New_x_Stars = New Calculated Design points (Includes value for x* not givin a initial design point)

    %%%%%%%%%%
    % Ethan Payne Programer
    % Nov 18, 2024
    % Calculate the Reliability Index of the perfrmace function for a given
    % limit state function, subfunction version for multiple itterations
    %%%%%%%%%%
    %Code requires the Symbolic Math Toolbox
    %Uses Functions to determine equivilent normal means and standard deviations
    
    
    
    %%
    %Note: Coments with **** are sections of the code that require user to change for different calculations (Now as Inputs for Subfunction)
    %Inputs
    
    %Step 1: Limit State Function
    
 
    
    g =g_Input; %Limit state function ****
    
    Limit_State_Variables = Limit_State_Variables_Input; %Store the variables for the limit state function (Last variable will not have an initial design point) ****
    
    Total_Number_of_Variables = length(Limit_State_Variables); %Determine how many variables there are
    
    Limit_State_Variables_U = Limit_State_Variables_U_Input; %Store the U variables of the limit state function 

    %Do not need as all design points are to be given
    % Limit_State_Variables_For_x_Star_Remaining = Limit_State_Variables; %initalize Variable
    % 
    % Limit_State_Variables_For_x_Star_Remaining(Total_Number_of_Variables,:) = []; %Remove last variable for x* Calc
    
    
    %Step 2: Initial Design Points (x*) as Mean values
    
    %Define Initial Design Points for all variables (for all  but 1 variable in original method)
    Initial_Design_Points = Initial_Design_Points_Input; %Vector of Initial Desing Points (x*) ****
    
    %Do not need as all design points are to be given
    % %Solve for Remaining Initial Design point with setting g = 0
    % g_equal_to_0_equation = solve(g == 0, Limit_State_Variables(Total_Number_of_Variables)); %Solve for remaining x* when g = 0
    % 
    % x_star_remaining_sym = subs(g_equal_to_0_equation, Limit_State_Variables_For_x_Star_Remaining, Initial_Design_Points); %Input known x* values into equation to solve for remaining x*
    % x_star_remaining = double(x_star_remaining_sym); %Convert to double from sym value
    
    %Create x* vector
    x_Stars = Initial_Design_Points; %Initialize x_Star vector
    %x_Stars(Total_Number_of_Variables,:) = x_star_remaining; %Add calculated x_Star to vector
    
    
    
    
    %Step 3: Equivelent Means and Standard Deviations ****
    
    
    Equivelent_Means = Equivelent_Means_Input; %Vector of equivelent Means ****
    Equivelent_SDs = Equivelent_SDs_Input; %Vector of equivelent Standard Deviations ****
    
    
    
    %Update the variables of the limit state function to be in terms of the U values
    for m = 1:Total_Number_of_Variables %For each variable
        Temp_U_Variable = Limit_State_Variables_U(m,:); %Temp U Variable
        Temp_Mean = Equivelent_Means(m,:); %Temp Mean Variable
        Temp_SD = Equivelent_SDs(m,:); %Temp SD variable

        New_Limit_State_Variables(m,:) = Temp_Mean + Temp_U_Variable*Temp_SD; %Redefine limit state variable 
    end


    %Calculate g in terms of U variable
    g_U = subs(g,Limit_State_Variables,New_Limit_State_Variables); %Replace old variables with new updated variables

    %Step 5 Prep: Determine the partial derivative of g for each of the variables in the function
    for l = 1:Total_Number_of_Variables %For each variable
        Variable_To_Take_Dirivative_With = Limit_State_Variables_U(l); %Variabe to take derivative with
    
        dg_Variable = diff(g_U,Variable_To_Take_Dirivative_With); %Take direvative of limit state function
    
        Partial_Derivatives(l,:) = dg_Variable; %Store in Partial Derivatives vector
    end
    
    
    
    
    %%
    %Old Procedure

    % %Produce z* and G Vector with loop
    % for i = 1:Total_Number_of_Variables %For each variable (x*)
    %     %Old Step 4: Determine Reduced variates (z*)
    %     Temp_x_Star = x_Stars(i); %X_Star value for variable
    %     Temp_Equivelent_Mean = Equivelent_Means(i); %Equivelent mean value for variable
    %     Temp_Equivelent_SD = Equivelent_SDs(i); %Equivelent standard deviation value for variable
    % 
    %     z_Stars(i,:) = (Temp_x_Star-Temp_Equivelent_Mean)/Temp_Equivelent_SD; %Calculate z* for variable
    % 
    % 
    %     %Old Step 5: Determine partial derivatives with respect to the initial design point multiplied by -1 (G)
    % 
    %     Temp_Derivative = Partial_Derivatives(i); %Find derivative for this variable
    %     Temp_Solved_Derivative = double(subs(Temp_Derivative, Limit_State_Variables, x_Stars)); %Solve Derivative at design point
    % 
    % 
    %     G(i,:) = -1*(Temp_Solved_Derivative)*Temp_Equivelent_SD; %Add value to G Vector
    % end
    % 
    % 
    % %Old Step 6: Estimate Reliability Index
    % 
    % Beta_Estimate = (G.' * z_Stars)/((G.'*G)^0.5); %Estimate Reliability Index
    % 
    % 
    % %Old Step 7: Calculate Sensitivity Factors
    % 
    % Alpha = G/((G.'*G)^0.5); %Sinsitivity factors vector
    % 
    % 
    % %Old Step 8: Determine New Disign Point Reduced Variates
    % 
    % for j = 1:(Total_Number_of_Variables-1) %For all but the calculated x* value
    %     New_z_Stars(j,:) = Alpha(j,:)*Beta_Estimate; %New Reduced Variates vector
    % end
    % 
    % 
    % %Old Step 9: Determine new x* values 
    % for k= 1:(Total_Number_of_Variables-1) %For all but the calculated x* value
    %     Temp_z_Star = New_z_Stars(k); %Use new z* for calc
    %     Temp_Equivelent_Mean = Equivelent_Means(k); %Equivelent mean value for variable
    %     Temp_Equivelent_SD = Equivelent_SDs(k); %Equivelent standard deviation value for variable
    % 
    %     New_x_Stars(k,:) = Temp_Equivelent_Mean + (Temp_z_Star*Temp_Equivelent_SD); %New Reduced Variates
    % end
    % 
    % 
    % %Old Step 10: Solve for remaning x* using new x* values
    % 
    % New_x_star_remaining_sym = subs(g_equal_to_0_equation, Limit_State_Variables_For_x_Star_Remaining, New_x_Stars); %Input known x* values into equation to solve for remaining x*
    % New_x_star_remaining = double(New_x_star_remaining_sym); %Convert to double
    % 
    % 
    % New_x_Stars(Total_Number_of_Variables,:) = New_x_star_remaining; %Add new calculated x* to New x* vector

    %%
    %New Procedure
    
    %Step 6: Evaluate the partial derivatives at the design points

    for i = 1:Total_Number_of_Variables %For each variable (x*)
        %Step 4: Determine Reduced variates (z* or U_k)
        Temp_x_Star = x_Stars(i); %X_Star value for variable
        Temp_Equivelent_Mean = Equivelent_Means(i); %Equivelent mean value for variable
        Temp_Equivelent_SD = Equivelent_SDs(i); %Equivelent standard deviation value for variable

        z_Stars(i,:) = (Temp_x_Star-Temp_Equivelent_Mean)/Temp_Equivelent_SD; %Calculate z* for variable

    end

    for n = 1:Total_Number_of_Variables %For each reduced variate (Z* or U_k)
        %Step 5: Determine partial derivatives with respect to the reduced variate (old: initial design point multiplied by -1 (G))

        Temp_Derivative = Partial_Derivatives(n); %Find derivative for this variable
     
        Temp_Solved_Derivative = double(subs(Temp_Derivative, Limit_State_Variables_U, z_Stars)); %Solve Derivative at design point


        G(n,:) = Temp_Solved_Derivative; %Add value to G Vector
    end

    Solved_g_U = double(subs(g_U,Limit_State_Variables_U,z_Stars)); %Solve the g_U equation

    Normalized_G = norm(G); %Euclidean norm of G

    A = z_Stars - Theta_Input*(G/Normalized_G); %Find the Auxiliary point
    
    Normalized_A = norm(A); %Euclidean norm of A

    V = A/Normalized_A; %Find vector of direction cosines of U_k

    Beta_Estimate = ((G.'*z_Stars) - (1-Gamma_Input)*Solved_g_U)/(G.'*V); %New Reliability Index Estimate


    New_z_Stars = Beta_Estimate*V; %New Reduced Variates (New z* or U_k+1)

    %Step 7: Determine new x* values 
    for k= 1:(Total_Number_of_Variables) %For all variables
        Temp_z_Star = New_z_Stars(k); %Use new z* for calc
        Temp_Equivelent_Mean = Equivelent_Means(k); %Equivelent mean value for variable
        Temp_Equivelent_SD = Equivelent_SDs(k); %Equivelent standard deviation value for variable

        New_x_Stars(k,:) = Temp_Equivelent_Mean + (Temp_z_Star*Temp_Equivelent_SD); %New Reduced Variates
    end

end



