G04*
G04  File:            LED-FLEX.TSP, Fri Feb 17 13:05:50 2012*
G04  Source:          P-CAD 2000 PCB, Version 15.10.24, (C:\Users\ram\Documents\work\Micron\cad\micron_6dof\led-flex.pcb)*
G04  Format:          Gerber Format (RS-274-D), ASCII*
G04*
G04  Format Options:  Absolute Positioning*
G04                   Leading-Zero Suppression*
G04                   Scale Factor 1:1*
G04                   NO Circular Interpolation*
G04                   Inch Units*
G04                   Numeric Format: 4.4 (XXXX.XXXX)*
G04                   G54 NOT Used for Aperture Change*
G04                   Apertures Embedded*
G04*
G04  File Options:    Offset = (0.0mil,0.0mil)*
G04                   Drill Symbol Size = 80.0mil*
G04                   No Pad/Via Holes*
G04*
G04  File Contents:   Pads*
G04                   No Vias*
G04                   No Designators*
G04                   No Types*
G04                   No Values*
G04                   No Drill Symbols*
G04                   Top Paste*
G04*
%INLED-FLEX.TSP*%
%ICAS*%
%MOIN*%
G04*
G04  Aperture MACROs for general use --- invoked via D-code assignment *
G04*
G04  General MACRO for flashed round with rotation and/or offset hole *
%AMROTOFFROUND*
1,1,$1,0.0000,0.0000*
1,0,$2,$3,$4*%
G04*
G04  General MACRO for flashed oval (obround) with rotation and/or offset hole *
%AMROTOFFOVAL*
21,1,$1,$2,0.0000,0.0000,$3*
1,1,$4,$5,$6*
1,1,$4,0-$5,0-$6*
1,0,$7,$8,$9*%
G04*
G04  General MACRO for flashed oval (obround) with rotation and no hole *
%AMROTOVALNOHOLE*
21,1,$1,$2,0.0000,0.0000,$3*
1,1,$4,$5,$6*
1,1,$4,0-$5,0-$6*%
G04*
G04  General MACRO for flashed rectangle with rotation and/or offset hole *
%AMROTOFFRECT*
21,1,$1,$2,0.0000,0.0000,$3*
1,0,$4,$5,$6*%
G04*
G04  General MACRO for flashed rectangle with rotation and no hole *
%AMROTRECTNOHOLE*
21,1,$1,$2,0.0000,0.0000,$3*%
G04*
G04  General MACRO for flashed rounded-rectangle *
%AMROUNDRECT*
21,1,$1,$2-$4,0.0000,0.0000,$3*
21,1,$1-$4,$2,0.0000,0.0000,$3*
1,1,$4,$5,$6*
1,1,$4,$7,$8*
1,1,$4,0-$5,0-$6*
1,1,$4,0-$7,0-$8*
1,0,$9,$10,$11*%
G04*
G04  General MACRO for flashed rounded-rectangle with rotation and no hole *
%AMROUNDRECTNOHOLE*
21,1,$1,$2-$4,0.0000,0.0000,$3*
21,1,$1-$4,$2,0.0000,0.0000,$3*
1,1,$4,$5,$6*
1,1,$4,$7,$8*
1,1,$4,0-$5,0-$6*
1,1,$4,0-$7,0-$8*%
G04*
G04  General MACRO for flashed regular polygon *
%AMREGPOLY*
5,1,$1,0.0000,0.0000,$2,$3+$4*
1,0,$5,$6,$7*%
G04*
G04  General MACRO for flashed regular polygon with no hole *
%AMREGPOLYNOHOLE*
5,1,$1,0.0000,0.0000,$2,$3+$4*%
G04*
G04  General MACRO for target *
%AMTARGET*
6,0,0,$1,$2,$3,4,$4,$5,$6*%
G04*
G04  General MACRO for mounting hole *
%AMMTHOLE*
1,1,$1,0,0*
1,0,$2,0,0*
$1=$1-$2*
$1=$1/2*
21,1,$2+$1,$3,0,0,$4*
21,1,$3,$2+$1,0,0,$4*%
G04*
G04*
G04  D10 : "Ellipse X0.010mm Y0.010mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0004*
%ADD10C, 0.0004*%
G04  D11 : "Ellipse X0.254mm Y0.254mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0100*
%ADD11C, 0.0100*%
G04  D12 : "Ellipse X0.350mm Y0.350mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0138*
%ADD12C, 0.0138*%
G04  D13 : "Ellipse X0.050mm Y0.050mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0020*
%ADD13C, 0.0020*%
G04  D14 : "Ellipse X0.100mm Y0.100mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0039*
%ADD14C, 0.0039*%
G04  D15 : "Ellipse X0.127mm Y0.127mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0050*
%ADD15C, 0.0050*%
G04  D16 : "Ellipse X0.150mm Y0.150mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0059*
%ADD16C, 0.0059*%
G04  D17 : "Ellipse X0.200mm Y0.200mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0079*
%ADD17C, 0.0079*%
G04  D18 : "Ellipse X0.203mm Y0.203mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0080*
%ADD18C, 0.0080*%
G04  D19 : "Ellipse X0.250mm Y0.250mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0098*
%ADD19C, 0.0098*%
G04  D20 : "Ellipse X1.300mm Y1.300mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0512*
%ADD20C, 0.0512*%
G04  D21 : "Rounded Rectangle X1.070mm Y1.070mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  RoundRct: DimX=0.0421, DimY=0.0421, CornerRad=0.0105, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD21ROUNDRECTNOHOLE, 0.0421 X0.0421 X0.0 X0.0211 X-0.0105 X-0.0105 X-0.0105 X0.0105*%
G04  D22 : "Rectangle X3.500mm Y0.350mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.1378, DimY=0.0138, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD22R, 0.1378 X0.0138*%
G04  D23 : "Rectangle X3.881mm Y0.731mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.1528, DimY=0.0288, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD23R, 0.1528 X0.0288*%
G04  D24 : "Rectangle X1.308mm Y1.500mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0515, DimY=0.0591, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD24R, 0.0515 X0.0591*%
G04  D25 : "Rectangle X1.500mm Y1.308mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0591, DimY=0.0515, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD25R, 0.0591 X0.0515*%
G04  D26 : "Rectangle X1.689mm Y1.881mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0665, DimY=0.0741, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD26R, 0.0665 X0.0741*%
G04  D27 : "Rectangle X1.881mm Y1.689mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0741, DimY=0.0665, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD27R, 0.0741 X0.0665*%
G04*
%FSLAX44Y44*%
%SFA1B1*%
%OFA0.0000B0.0000*%
G04*
G70*
G90*
G01*
D2*
%LNTop Paste*%
D21*
X32494Y30734D3*
X33281D3*
D22*
X98326Y32381D3*
Y32185D3*
Y31988D3*
Y31791D3*
Y31594D3*
Y31397D3*
D21*
X29208Y31501D3*
Y32289D3*
X33273Y33045D3*
X32486D3*
D02M02*
