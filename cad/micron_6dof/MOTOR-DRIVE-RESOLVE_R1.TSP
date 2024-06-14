G04*
G04  File:            MOTOR-DRIVE-RESOLVE_R1.TSP, Tue Feb 14 13:00:20 2012*
G04  Source:          P-CAD 2000 PCB, Version 15.10.24, (C:\Users\ram\Documents\work\Micron\cad\micron_6dof\motor-drive-resolve_r1.pcb)*
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
%INMOTOR-DRIVE-RESOLVE_R1.TSP*%
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
G04  D10 : "Ellipse X0.150mm Y0.150mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0059*
%ADD10C, 0.0059*%
G04  D11 : "Ellipse X0.025mm Y0.025mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0010*
%ADD11C, 0.0010*%
G04  D12 : "Ellipse X0.254mm Y0.254mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0100*
%ADD12C, 0.0100*%
G04  D13 : "Ellipse X0.280mm Y0.280mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0110*
%ADD13C, 0.0110*%
G04  D14 : "Ellipse X0.300mm Y0.300mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0118*
%ADD14C, 0.0118*%
G04  D15 : "Ellipse X0.500mm Y0.500mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0197*
%ADD15C, 0.0197*%
G04  D16 : "Ellipse X0.050mm Y0.050mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0020*
%ADD16C, 0.0020*%
G04  D17 : "Ellipse X0.100mm Y0.100mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0039*
%ADD17C, 0.0039*%
G04  D18 : "Ellipse X0.127mm Y0.127mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0050*
%ADD18C, 0.0050*%
G04  D19 : "Ellipse X0.178mm Y0.178mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0070*
%ADD19C, 0.0070*%
G04  D20 : "Ellipse X0.200mm Y0.200mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0079*
%ADD20C, 0.0079*%
G04  D21 : "Ellipse X0.203mm Y0.203mm H0.000mm 0.0deg (0.000mm,0.000mm) Draw"*
G04  Disc: OuterDia=0.0080*
%ADD21C, 0.0080*%
G04  D22 : "Ellipse X2.600mm Y2.600mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.1024*
%ADD22C, 0.1024*%
G04  D23 : "Ellipse X3.360mm Y3.360mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.1323*
%ADD23C, 0.1323*%
G04  D24 : "Ellipse X3.480mm Y3.480mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.1370*
%ADD24C, 0.1370*%
G04  D25 : "Ellipse X3.620mm Y3.620mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.1425*
%ADD25C, 0.1425*%
G04  D26 : "Ellipse X1.000mm Y1.000mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0394*
%ADD26C, 0.0394*%
G04  D27 : "Ellipse X1.120mm Y1.120mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0441*
%ADD27C, 0.0441*%
G04  D28 : "Ellipse X1.220mm Y1.220mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0480*
%ADD28C, 0.0480*%
G04  D29 : "Ellipse X2.260mm Y2.260mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0890*
%ADD29C, 0.0890*%
G04  D30 : "Rectangle X1.440mm Y0.270mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0567, DimY=0.0106, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD30R, 0.0567 X0.0106*%
G04  D31 : "Rectangle X0.270mm Y1.440mm H0.000mm 330.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0106, DimY=0.0567, Rotation=330.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD31ROTRECTNOHOLE, 0.0106 X0.0567 X330.0*%
G04  D32 : "Rectangle X2.700mm Y2.700mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Square: Side=0.1063, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000*
%ADD32R, 0.1063 X0.1063*%
G04  D33 : "Rectangle X0.280mm Y0.900mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0110, DimY=0.0354, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD33R, 0.0110 X0.0354*%
G04  D34 : "Rectangle X0.900mm Y0.280mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0354, DimY=0.0110, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD34R, 0.0354 X0.0110*%
G04  D35 : "Rectangle X1.600mm Y0.300mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0630, DimY=0.0118, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD35R, 0.0630 X0.0118*%
G04  D36 : "Rectangle X0.300mm Y1.600mm H0.000mm 330.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0118, DimY=0.0630, Rotation=330.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD36ROTRECTNOHOLE, 0.0118 X0.0630 X330.0*%
G04  D37 : "Rectangle X0.400mm Y1.020mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0157, DimY=0.0402, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD37R, 0.0157 X0.0402*%
G04  D38 : "Rectangle X1.020mm Y0.400mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0402, DimY=0.0157, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD38R, 0.0402 X0.0157*%
G04  D39 : "Rectangle X1.720mm Y0.420mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0677, DimY=0.0165, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD39R, 0.0677 X0.0165*%
G04  D40 : "Rectangle X0.420mm Y1.720mm H0.000mm 330.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0165, DimY=0.0677, Rotation=330.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD40ROTRECTNOHOLE, 0.0165 X0.0677 X330.0*%
G04  D41 : "Rectangle X0.572mm Y0.572mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Square: Side=0.0225, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000*
%ADD41R, 0.0225 X0.0225*%
G04  D42 : "Rectangle X0.635mm Y0.635mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Square: Side=0.0250, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000*
%ADD42R, 0.0250 X0.0250*%
G04  D43 : "Rectangle X0.755mm Y0.755mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Square: Side=0.0297, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000*
%ADD43R, 0.0297 X0.0297*%
G04  D44 : "Rectangle X0.900mm Y0.225mm H0.000mm 127.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0354, DimY=0.0089, Rotation=127.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD44ROTRECTNOHOLE, 0.0354 X0.0089 X127.0*%
G04  D45 : "Rectangle X0.900mm Y0.225mm H0.000mm 53.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0354, DimY=0.0089, Rotation=53.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD45ROTRECTNOHOLE, 0.0354 X0.0089 X53.0*%
G04  D46 : "Rectangle X0.940mm Y0.940mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Square: Side=0.0370, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000*
%ADD46R, 0.0370 X0.0370*%
G04  D47 : "Rectangle X1.000mm Y0.250mm H0.000mm 127.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0394, DimY=0.0098, Rotation=127.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD47ROTRECTNOHOLE, 0.0394 X0.0098 X127.0*%
G04  D48 : "Rectangle X1.000mm Y0.250mm H0.000mm 53.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0394, DimY=0.0098, Rotation=53.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD48ROTRECTNOHOLE, 0.0394 X0.0098 X53.0*%
G04  D49 : "Rectangle X1.060mm Y1.060mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Square: Side=0.0417, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000*
%ADD49R, 0.0417 X0.0417*%
G04  D50 : "Rectangle X1.120mm Y0.370mm H0.000mm 127.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0441, DimY=0.0146, Rotation=127.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD50ROTRECTNOHOLE, 0.0441 X0.0146 X127.0*%
G04  D51 : "Rectangle X1.120mm Y0.370mm H0.000mm 53.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0441, DimY=0.0146, Rotation=53.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD51ROTRECTNOHOLE, 0.0441 X0.0146 X53.0*%
G04  D52 : "Rectangle X1.340mm Y1.000mm H0.000mm 127.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0528, DimY=0.0394, Rotation=127.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD52ROTRECTNOHOLE, 0.0528 X0.0394 X127.0*%
G04  D53 : "Rectangle X1.340mm Y1.000mm H0.000mm 53.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0528, DimY=0.0394, Rotation=53.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD53ROTRECTNOHOLE, 0.0528 X0.0394 X53.0*%
G04  D54 : "Rectangle X0.305mm Y1.400mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0120, DimY=0.0551, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD54R, 0.0120 X0.0551*%
G04  D55 : "Rectangle X1.460mm Y1.120mm H0.000mm 127.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0575, DimY=0.0441, Rotation=127.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD55ROTRECTNOHOLE, 0.0575 X0.0441 X127.0*%
G04  D56 : "Rectangle X1.460mm Y1.120mm H0.000mm 53.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0575, DimY=0.0441, Rotation=53.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD56ROTRECTNOHOLE, 0.0575 X0.0441 X53.0*%
G04  D57 : "Rectangle X0.425mm Y1.520mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0167, DimY=0.0598, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD57R, 0.0167 X0.0598*%
G04  D58 : "Rectangle X1.800mm Y0.800mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0709, DimY=0.0315, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD58R, 0.0709 X0.0315*%
G04  D59 : "Rectangle X1.800mm Y0.800mm H0.000mm 60.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0709, DimY=0.0315, Rotation=60.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD59ROTRECTNOHOLE, 0.0709 X0.0315 X60.0*%
G04  D60 : "Rectangle X1.920mm Y0.920mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0756, DimY=0.0362, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD60R, 0.0756 X0.0362*%
G04  D61 : "Rectangle X1.920mm Y0.920mm H0.000mm 60.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0756, DimY=0.0362, Rotation=60.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD61ROTRECTNOHOLE, 0.0756 X0.0362 X60.0*%
G04  D62 : "Rectangle X0.252mm Y0.810mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0099, DimY=0.0319, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD62R, 0.0099 X0.0319*%
G04  D63 : "Rectangle X0.810mm Y0.252mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Rectangular: DimX=0.0319, DimY=0.0099, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000 *
%ADD63R, 0.0319 X0.0099*%
G04  D64 : "Rectangle X2.500mm Y2.500mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Square: Side=0.0984, Rotation=0.0, OffsetX=0.0000, OffsetY=0.0000, HoleDia=0.0000*
%ADD64R, 0.0984 X0.0984*%
G04  D65 : "Ellipse X0.570mm Y0.570mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0224*
%ADD65C, 0.0224*%
G04  D66 : "Ellipse X0.600mm Y0.600mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0236*
%ADD66C, 0.0236*%
G04  D67 : "Ellipse X0.690mm Y0.690mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0272*
%ADD67C, 0.0272*%
G04  D68 : "Ellipse X0.820mm Y0.820mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0323*
%ADD68C, 0.0323*%
G04  D69 : "Ellipse X0.870mm Y0.870mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0343*
%ADD69C, 0.0343*%
G04  D70 : "Ellipse X0.920mm Y0.920mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0362*
%ADD70C, 0.0362*%
G04  D71 : "Ellipse X0.940mm Y0.940mm H0.000mm 0.0deg (0.000mm,0.000mm) Flash"*
G04  Disc: OuterDia=0.0370*
%ADD71C, 0.0370*%
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
D41*
X36968Y37031D3*
Y37418D3*
D63*
X35743Y39566D3*
Y39311D3*
Y39055D3*
Y38799D3*
X37318Y39311D3*
Y39055D3*
Y38799D3*
D62*
X36146Y39970D3*
X36658D3*
X36402D3*
X36914D3*
X36146Y38395D3*
X36402D3*
X36658D3*
X36914D3*
D32*
X36530Y39183D3*
D63*
X37318Y39566D3*
D52*
X38620Y42807D3*
X36331Y41083D3*
D44*
X38114Y41588D3*
X37957Y41470D3*
X37800Y41351D3*
X37642Y41233D3*
X37485Y41114D3*
X38271Y41707D3*
D63*
X41353Y39566D3*
Y39311D3*
Y39055D3*
Y38799D3*
X42928Y39311D3*
Y39055D3*
Y38799D3*
D62*
X41757Y39970D3*
X42268D3*
X42012D3*
X42524D3*
X41757Y38395D3*
X42012D3*
X42268D3*
X42524D3*
D32*
X42140Y39183D3*
D63*
X42928Y39566D3*
D41*
X40314Y40202D3*
Y39815D3*
D53*
X42408Y41083D3*
X40119Y42807D3*
D45*
X41097Y41233D3*
X40940Y41351D3*
X40782Y41470D3*
X40625Y41588D3*
X40468Y41707D3*
X41254Y41114D3*
D46*
X41240Y37696D3*
Y37096D3*
X37903Y37568D3*
Y36968D3*
D41*
X41692Y37365D3*
Y37753D3*
D30*
X40059Y36082D3*
Y36279D3*
Y36476D3*
Y36673D3*
Y36870D3*
Y37066D3*
Y37263D3*
Y37460D3*
Y37657D3*
Y37854D3*
X38641Y37657D3*
Y37460D3*
Y37263D3*
Y37066D3*
Y36870D3*
Y36673D3*
Y36476D3*
Y36279D3*
D58*
X39350Y35393D3*
Y38543D3*
D30*
X38641Y37854D3*
Y36082D3*
D02M02*
