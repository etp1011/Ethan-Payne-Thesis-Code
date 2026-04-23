function [MS_DL_Pos_Shear, MS_DL_Neg_Shear, MS_DL_Pos_Moment, MS_DL_Neg_Moment, MS_LL_Pos_Shear, MS_LL_Neg_Shear, MS_LL_Pos_Moment, MS_LL_Neg_Moment] = Multi_Span_Demand_Prediction_SUBF(Length_Input,Spans_Input,Width_Input,Slab_Depth_Input,Numb_Girders_Input,Girder_Depth_Input);
%%%%%%%%%%Numb_Girders
% Ethan Payne Programer
% June 28, 2025
% Neural Network Demand Predictive Formulas for Multi Span Bridges
%%%%%%%%%%
%This code uses the formulas produced from the neural networks to predict
%the shear and moment demand of the bridge for dead and truck load. 

%Inputs
%Length_Input = Total Bridge Length (Ft)
%Spans_Input = Number of Spans
%Width_Input = Out to Out Width of Bridge (Ft)
%Slab_Depth_Input = Depth of Concrete Slab (in)
%Numb_Girders_Input = Total Number of Bridge Girders
%Girder_Depth_Input = Depth of Girder (in)


Length = Length_Input;
Spans = Spans_Input;
Width = Width_Input;
Slab_Depth = Slab_Depth_Input;
Numb_Girders = Numb_Girders_Input;
Girder_Depth = Girder_Depth_Input;

%%
%Dead Load Positive Shear

DL_PS_H1 = tanh(0.5 * ((-3.33270806062192) + 0.0156401697083952 * Length + -0.869340750359887 * Spans + 0.0815950778468963 * Width + 0.27208466666379 * Slab_Depth + -0.678794834371278 * Numb_Girders + -0.000724908902965273 * Girder_Depth)); %Node 1 
DL_PS_H2 = tanh(0.5 * ((-1.84828383080119) + 0.0396266940961484 * Length + 0.321687854118424 * Spans + -0.0495727412251028 * Width + 0.00699142879190735 *Slab_Depth + -0.0170214917005885 *Numb_Girders + 0.00669455017314757 * Girder_Depth)); %Node 2
DL_PS_H3 = tanh(0.5 * ((-0.267642038832207) + 0.0178739403855169 * Length + 2.29903200783614 * Spans + -0.216228530624703 * Width + -0.455036529762977 *Slab_Depth + 0.587007578710871 * Numb_Girders + -0.0358315489860573 *Girder_Depth)); %Node 3

MS_DL_Pos_Shear = 50.8059178914425 + 45.7250311730249 *DL_PS_H1 + 10.7703934906155 * DL_PS_H2 + -5.96047182052345 * DL_PS_H3; %Predictive Formula


%%
%Dead Load Negative Shear

DL_NS_H1 = tanh(0.5 * ((-3.57794028807578) + 0.0152317936345791 * Length + -0.831448761085391 * Spans + 0.085916376508668 * Width + 0.270830987897452 * Slab_Depth + -0.656950259558167 * Numb_Girders + 0.00423304582176076 * Girder_Depth)); %Node 1
DL_NS_H2 = tanh(0.5 * ((-2.65078102847817) + 0.0335929005408727 * Length + 0.36309065663295 * Spans + -0.0311909019807847 * Width + -0.00811958593408671 * Slab_Depth + 0.0800786251515864 * Numb_Girders + 0.0148051115394356 * Girder_Depth)); %Node 2
DL_NS_H3 = tanh(0.5 * ((-4.51239923279591) + 0.024401251826824 * Length + 2.43493443739314 * Spans + -0.174871591067101 * Width + -0.482447016451032 * Slab_Depth + 0.645899259832883 * Numb_Girders + 0.0309871568434366 * Girder_Depth)); %Node 3

MS_DL_Neg_Shear = (-50.5828861016385) + -46.3950771306666 * DL_NS_H1 + -10.0619494070675 * DL_NS_H2 + 3.9390341618062 * DL_NS_H3; %Predictive Formula


%%
%Dead Load Positive Moment

DL_PM_H1 = tanh(0.5 * (1.71903503474017 + 0.000448785409034762 * Length + 0.724139294068751 *Spans + -0.0544404129217553 * Width + -0.134067306706877 * Slab_Depth + 0.520497117878889 * Numb_Girders + 0.00490762137490582 * Girder_Depth)); %Node 1
DL_PM_H2 = tanh(0.5 * (2.06113555968728 + -0.00757345132429949 * Length + 0.689923828170438 * Spans + -0.0577298117676006 * Width + -0.144994297989803 * Slab_Depth + 0.657835237573867 * Numb_Girders + 0.00291531269284737 *Girder_Depth)); %Node 2
DL_PM_H3 = tanh(0.5 * (4.35102081043865 + -0.0143371584151161 * Length+ 1.00209202239617 *Spans + -0.0360093732833702 * Width + -0.131975856806163 *Slab_Depth + -0.00393734775061852 * Numb_Girders + -0.0058685888977252 *Girder_Depth)); %Node 3

MS_DL_Pos_Moment = 888.571106239694 + 1349.76798701671 *DL_PM_H1 + -1503.07977269659 * DL_PM_H2 + -729.339082206962 * DL_PM_H3; %Predictive Formula


%%
%Dead Load Negative Moment

DL_NM_H1 = tanh(0.5 * (7.33136585366818 + -0.057316496144368 *Length + 5.35571752669119 * Spans+ -0.232906885574774 *Width + -1.03239594016804 * Slab_Depth + 1.73314460489631 *Numb_Girders + 0.0082611615953325 * Girder_Depth)); %Node 1
DL_NM_H2 = tanh(0.5 * (1.14445387129697 + 0.00293510110272364 * Length+ -4.14961645095112 * Spans + 0.288555030054565 *Width + 0.0706628727797849 *Slab_Depth + -0.97066384735256 * Numb_Girders + 0.115582261289119 *Girder_Depth)); %Node 2
DL_NM_H3 = tanh(0.5 * ((-4.12759197008311) + 0.0228772128046101 *Length + 2.74549959869193 *Spans + -0.146673380510097 *Width + -0.0700568313621188 *Slab_Depth + 0.645487109494744 *Numb_Girders + -0.0387654349286515 *Girder_Depth)); %Node 3
DL_NM_H4 = tanh(0.5 * (15.7817877707011 + -0.00016651929763492 *Length + -4.06018884131329 *Spans + -0.00442954775401368 * Width + -0.00784960499513927 * Slab_Depth + -0.156483317013457 * Numb_Girders + -0.0409959793360351 * Girder_Depth)); %Node 4
DL_NM_H5 = tanh(0.5 * (36.955924271403 + -0.0440885569056723 * Length + 6.5463907658487 * Spans + -0.228712092020025 *Width + -5.43765879832694 * Slab_Depth + 2.16112515205702 * Numb_Girders + -0.128880585512313 *Girder_Depth)); %Node 5
DL_NM_H6 = tanh(0.5 * ((-1.3230856013909) + 0.0295813446622714 *Length + -2.01149196103296 * Spans + 0.0729429972582998 * Width + 0.347260911855273 * Slab_Depth + -0.717024381835956 * Numb_Girders + 0.0135900464836305 *Girder_Depth)); %Node 6

MS_DL_Neg_Moment = (-524.081549564201) + 507.023332464065 * DL_NM_H1 + -88.5611704656025 * DL_NM_H2 + -145.76255795953 *DL_NM_H3 + -130.019413288769 *DL_NM_H4 + -108.435398349232 *DL_NM_H5 + -242.293379215679 *DL_NM_H6; %Predictive Formula


%%
%Truck Load Positive Shear

LL_PS_H1 = tanh(0.5 * ((-1.87561721525058) + -0.0349225678155173 *Length + 0.667396626375196 * Spans + 0.0372034521975889 * Width + -0.00535887291921108 * Slab_Depth + -0.325574344655875 *Numb_Girders + 0.0046118222209883 *Girder_Depth)); %Node 1
LL_PS_H2 = tanh(0.5 * ((-1.79120054145713) + -0.00461865339235772 * Length + 0.707133628883268 *Spans + -0.34804627008442 *Width + 0.146208977305847 *Slab_Depth + 2.65547074113196 *Numb_Girders + -0.0217890895779391 *Girder_Depth)); %Node 2
LL_PS_H3 = tanh(0.5 * (16.0958130429487 + 0.00391272806542887 *Length + -0.343308878267978 *Spans + 0.103724585812627 * Width + -0.0116308840492786 *Slab_Depth + -6.71597693977611 *Numb_Girders + 0.00718621711639036 *Girder_Depth)); %Node 3

MS_LL_Pos_Shear = 10.6804317533367 + -43.0054793139704 * LL_PS_H1 + -7.31161779163135 *LL_PS_H2 + 20.0553310396841 *LL_PS_H3; %Predictive Formula


%%
%Truck Load Negative Shear

LL_NS_H1 = tanh(0.5 * (0.0700594402904424 + -0.0123260784265176 *Length + 0.388145411945622 * Spans + -0.0410580360315424 *Width + 0.0822166329703351 *Slab_Depth  + 0.385105305553878 *Numb_Girders + -0.0121808179071684 *Girder_Depth)); %Node 1
LL_NS_H2 = tanh(0.5 * ((-10.6042909576334) + 0.0425719856748312 *Length + -0.309544626087172 *Spans + -0.0954699365429727 * Width + 0.620619705920415 *Slab_Depth + 0.906835342856722 *Numb_Girders + 0.0177028098841913 *Girder_Depth)); %Node 2
LL_NS_H3 = tanh(0.5 * ((-10.8991850859808) + 0.0429989007392942 *Length + -0.353877212608112 *Spans + 0.0402395306136808 *Width + 1.08008398993923 *Slab_Depth + -0.446100067196332 *Numb_Girders + 0.00801062000895217 * Girder_Depth)); %Node 3

MS_LL_Neg_Shear = (-28.9256986560034) + 24.9377208122415 *LL_NS_H1 + 17.13006109116 *LL_NS_H2 + -11.9455141799132 *LL_NS_H3; %Predictive Formula


%%
%Truck Load Positive Moment

LL_PM_H1 = tanh(0.5 * (0.969155791196656 + -0.00250855984015509 * Length + -0.0499045771205189 * Spans + 0.0020626895107529 * Width + -0.00509251218582273 *Slab_Depth + -0.0443087469265413 * Numb_Girders + -0.0000130435187534084 *Girder_Depth)); %Node 1
LL_PM_H2 = tanh(0.5 * ((-2.52661520618309) + 0.0055227710970472 *Length + 0.231809203096236 *Spans + -0.0112757262509147 *Width + 0.0189389018523911 *Slab_Depth + 0.178254868334005 *Numb_Girders + -0.00124855035033137 *Girder_Depth)); %Node 2
LL_PM_H3 = tanh(0.5 * (6.65570756413602 + 0.0193856524984794 *Length + -1.68408053855394 * Spans + 0.064141894102734 *Width + -0.0573188363265832 *Slab_Depth + -2.61174974022409 * Numb_Girders + -0.0033207948894645 * Girder_Depth)); %Node 3

MS_LL_Pos_Moment = 662.671690321259 + -5281.10304099179 *LL_PM_H1 + -1997.34590425059 * LL_PM_H2 + 190.585485992701 *LL_PM_H3; %Predictive Formula


%%
%Truck Load Negative Moment

LL_NM_H1 = tanh(0.5 * ((-1.60957607763474) + -0.0121558601916 * Length + 0.756726129413466 *Spans + -0.0203557009059249 *Width + 0.0124407940838665 *Slab_Depth + 1.31526808452159 *Numb_Girders + 0.00552780191102125 *Girder_Depth)); %Node 1
LL_NM_H2 = tanh(0.5 * (1.07467170557285 + -0.0131482980715293 *Length + 0.20503030422165 * Spans + 0.011891851206998 * Width + -0.0131155384054447 *Slab_Depth + -0.0837592323992849 *Numb_Girders + 0.00217932186815384 *Girder_Depth)); %Node 2
LL_NM_H3 = tanh(0.5 * (2.21513997790064 + -0.0207397031877176 *Length + 0.209389331042649 *Spans + 0.0540028100843881 *Width + -0.0534381186781683 * Slab_Depth + -0.340743084152782 *Numb_Girders + 0.00769465709512695 * Girder_Depth)); %Node 3

MS_LL_Neg_Moment = (-452.60219563827) + 382.703156413707 *LL_NM_H1 + 621.190160493788 * LL_NM_H2 + -346.410347843946 *LL_NM_H3; %No Predictive Formula for Single Span Bridges


end