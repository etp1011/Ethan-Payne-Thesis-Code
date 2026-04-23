function [SS_DL_Pos_Shear, SS_DL_Neg_Shear, SS_DL_Pos_Moment, SS_DL_Neg_Moment, SS_LL_Pos_Shear, SS_LL_Neg_Shear, SS_LL_Pos_Moment, SS_LL_Neg_Moment] = Single_Span_Demand_Prediction_SUBF(Length_Input,Width_Input,Slab_Depth_Input,Numb_Girders_Input,Girder_Depth_Input);
%%%%%%%%%%
% Ethan Payne Programer
% June 28, 2025
% Neural Network Demand Predictive Formulas for Single Span Bridges
%%%%%%%%%%
%This code uses the formulas produced from the neural networks to predict
%the shear and moment demand of the bridge for dead and truck load. 

%Inputs
%Length_Input = Total Bridge Length (Ft)
%Width_Input = Out to Out Width of Bridge (Ft)
%Slab_Depth_Input = Depth of Concrete Slab (in)
%Numb_Girders_Input = Total Number of Bridge Girders
%Girder_Depth_Input = Depth of Girder (in)


Length = Length_Input;
Width = Width_Input;
Slab_Depth = Slab_Depth_Input;
Numb_Girders = Numb_Girders_Input;
Girder_Depth = Girder_Depth_Input;

%%
%Dead Load Positive Shear
DL_PS_H1 = tanh(0.5 * ((-0.704563041479347) + 0.00103389503978647 * Length + 0.0567109544109435 * Width + -0.144667340963664 *Slab_Depth + 0.0188337063098597 *Numb_Girders + -0.0179762218405515 *Girder_Depth)); %Node 1 
DL_PS_H2 = tanh(0.5 * (4.55688199033496 + -0.00925738557248361 *Length + -0.0583532923106115 * Width + -0.249951289524365 * Slab_Depth + 0.510037369755031 *Numb_Girders + -0.00984302778055973 * Girder_Depth)); %Node 2
DL_PS_H3 = tanh(0.5 * ((-0.798772496303577) + -0.00388941442104872 * Length + 0.0732944191298429 *Width + -0.130446381125843 *Slab_Depth + -0.0831777582624413 *Numb_Girders + -0.0150801284027743 *Girder_Depth)); %Node 3

SS_DL_Pos_Shear = 129.312480952926 + 99.4358489675863 *DL_PS_H1 + -133.763983533612 *DL_PS_H2 + -86.0620131049349 * DL_PS_H3; %Predictive Formula


%%
%Dead Load Negative Shear
DL_NS_H1 = tanh(0.5 * ((-7.12539940234546) + 0.00744850416919799 *Length + 0.0490510208232139 *Width + 0.130688296129671 * Slab_Depth + -0.434719657243314 *Numb_Girders + 0.0155411140385096 * Girder_Depth)); %Node 1
DL_NS_H2 = tanh(0.5 * (0.227704431654274 + -0.000201399193293031 *Length+ -0.000160372772025567 * Width + -0.0010055978770965 *Slab_Depth + -0.000574806264389205 *Numb_Girders + 0.000286777424472911 *Girder_Depth)); %Node 2
DL_NS_H3 = tanh(0.5 * (4927.33902948414 + -6.96498053704712 *Length + -47.3278269617525 *Width + -386.906654105027 * Slab_Depth + 134.111413236419 *Numb_Girders + 13.3841309525445 * Girder_Depth)); %Node 3

SS_DL_Neg_Shear = (-2628.64387763988) + -2355.58378755793 *DL_NS_H1 + 2486.45157717445 *DL_NS_H2 + 7.26183017789969 *DL_NS_H3; %Predictive Formula


%%
%Dead Load Positive Moment

DL_PM_H1 = tanh(0.5 * (5.18650249732888 + -0.0228747665378759 * Length+ -0.044459013186081 *Width + -0.157513102095879 * Slab_Depth+ 0.27007940600788 * Numb_Girders + 0.00561375119788832 * Girder_Depth)); %Node 1
DL_PM_H2 = tanh(0.5 * (10.0568930685508 + -0.0350849210434952 *Length + 0.0720867646577807 *Width + -0.460577084741486 *Slab_Depth + 0.268763084859153 *Numb_Girders+ -0.049304116911942 * Girder_Depth)); %Node 2
DL_PM_H3 = tanh(0.5 * ((-9.67926848579682) + 0.0321050611400867 *Length + 0.0252252066061874 *Width + 0.458853655839972 *Slab_Depth + -0.760020434767068 *Numb_Girders + 0.0472989150217951 * Girder_Depth)); %Node 3

SS_DL_Pos_Moment = 3762.52871560001 + -3204.89532769851 *DL_PM_H1 + 3773.15917035479 *DL_PM_H2 + 4417.08185403832 *DL_PM_H3; %Predictive Formula


%%
%Dead Load Negative Moment

SS_DL_Neg_Moment = NaN; %No Predictive Formula for Single Span Bridges


%%
%Truck Load Positive Shear

LL_PS_H1 = tanh(0.5 * (2.38811857947805 + -0.000242784912376796 * Length + 0.19344118266766 * Width + 0.0859727043100411 *Slab_Depth + -1.82307354343537 * Numb_Girders+ -0.00715187442862849 *Girder_Depth)); %Node 1
LL_PS_H2 = tanh(0.5 * (1.06325996343045 + -0.00960710059640992 *Length + 0.0148128704987836 *Width + 0.278263976315864 *Slab_Depth + -0.587089252488773 * Numb_Girders + -0.0202022120182893 *Girder_Depth)); %Node 2
LL_PS_H3 = tanh(0.5 * ((-22.1262392294166) + -0.00106119111168223 * Length + -0.105135393982904 *Width + -0.0767370928372597 *Slab_Depth + 8.66732401232095 * Numb_Girders + 0.0122340661575378 *Girder_Depth)); %Node 3

SS_LL_Pos_Shear = 38.808915213423 + 11.6320001972638 *LL_PS_H1 + -11.8304322331627 * LL_PS_H2+ -17.4066748725784 *LL_PS_H3; %Predictive Formula


%%
%Truck Load Negative Shear

LL_NS_H1 = tanh(0.5 * ((-6.94839878464409) + -0.00197430115234708 * Length+ -0.0177698328578704 *Width + -0.032351138568669 *Slab_Depth + 1.84946636524424 * Numb_Girders+ -0.000722565928844317 *Girder_Depth)); %Node 1
LL_NS_H2 = tanh(0.5 * ((-4.64630854945073) + -0.00297624963676129 *Length + 0.0258895310568904 *Width + 0.0191091111509693 *Slab_Depth + 0.955902733988781 *Numb_Girders + -0.00794973253531208 *Girder_Depth)); %Node 2
LL_NS_H3 = tanh(0.5 * ((-1.31874684174452) + -0.00100399463292807 *Length + -0.0569422725183186 * Width + -0.00846872454066717 *Slab_Depth + 1.0802733925582 * Numb_Girders + -0.00273996194160785 *Girder_Depth)); %Node 3

SS_LL_Neg_Shear = (-66.1548991773378) + -61.4352933810035 *LL_NS_H1 + 51.2272946438342 *LL_NS_H2 + 65.0095676257938 * LL_NS_H3; %Predictive Formula


%%
%Truck Load Positive Moment

LL_PM_H1 = tanh(0.5 * (2.29537627924839 + 0.0167119578534773 *Length + 0.0158743488986372 * Width + 0.00965130550333007 *Slab_Depth + -1.84788785032802 * Numb_Girders + 0.000363491599330685 *Girder_Depth)); %Node 1
LL_PM_H2 = tanh(0.5 * (1.1624208205389 + -0.016215525656317 *Length + -0.021376655101776 *Width + 0.0835310791254698 * Slab_Depth + 0.47076715543906 *Numb_Girders + -0.0159352489045045 *Girder_Depth)); %Node 2
LL_PM_H3 = tanh(0.5 * (0.473736971925303 + -0.0197828174565544 *Length+ -0.0131272512754298 * Width+ -0.031915765978053 *Slab_Depth + -0.219747375585195 *Numb_Girders + 0.0107825537461742 *Girder_Depth)); %Node 3

SS_LL_Pos_Moment = 572.262073759335 + 382.89235389406 * LL_PM_H1 + -501.425142313729 * LL_PM_H2 + -564.682346168809 *LL_PM_H3; %Predictive Formula


%%
%Truck Load Negative Moment

SS_LL_Neg_Moment = NaN; %No Predictive Formula for Single Span Bridges


end