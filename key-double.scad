//measures are in millimeters
//(feel free to cocnvert them to attoparsecs)
AY=37.0;
AX=19.0;
BY=32.0;
BLX=14.5;
EZ=11.0;
FLZ=14.0;
H=12.75;
SHAFT_OFF_Y=28.0;
BLIND_SHAFT_OFF_Y=9.0;
CYL_OFF_Z=200;
CYL_DEPTH=0.1;
CLIP_X=2;
CLIP_Y=0.75;
CLIP_H=3*CLIP_Y;
CORNER_RADIUS=2;
INNER_GUARD_RADIUS=6.5;
OUTER_GUARD_RADIUS=7.5;
BLIND_SHAFT_OUTER_DIAMETER=4.0;
BLIND_SHAFT_INNER_DIAMETER=2.0;
SHAFT_X=8.0;
SHAFT_Y=6.0;
SHAFT_LENGTH=9.0;
SHAFT_THICKNESS=1.0;
SHAFT_CLIP_WIDTH=3.0;
SHAFT_CLIP_THICKNESS=0.75;
SHAFT_CLIP_HEIGHT=2.0;
SHAFT_CLIP_SLOPE_DEPTH=1.0;
SHAFT_CLIP_ANGLE=45;
SHAFT_END_CUTOUT_HEIGHT=1.5;
SHAFT_LARGE_SLOT_TO_BASE=1.5;
SHAFT_SMALL_SLOT_LENGTH=7.25;
SHAFT_SMALL_SLOT_WIDTH=2.5;
SHAFT_SPRING_HOLDER_WIDTH=3.0;
SHAFT_SPRING_HOLDER_TO_BASE=4.0;
SHAFT_SPRING_GUIDE_WIDTH=1.0;
SHAFT_SPRING_GUIDE_SIDES_HEIGHT=3.5;
STRUT_THICKNESS=1;
STRUT_HEIGHT=3;
STRUT_SPACING=1;
SHAFT_SPRING_HOLDER_NIPPLE_HEIGHT=1;
SHAFT_SPRING_HOLDER_NIPPLE_RADIUS=0.75;

SHAFT_SMALL_SLOT_BEVEL=0.5;

WallThickness=0.75;
ClipWidth=2.2;
ClipDepth=0.75;

//ascfront=FLZ/sqrt(pow(FLZ,2)-pow(H,2));
//asctop=(H-EZ)/sqrt(pow(BLX,2)-pow((H-EZ),2));

alpha=asin((H-EZ)/BLX);
beta=asin(H/FLZ);
gamma=90-asin((0.5*(AY-BY))/EZ);

module keycap(){
	scale([AX/(AX+2*CORNER_RADIUS),AY/(AY+2*CORNER_RADIUS),1])
	translate([CORNER_RADIUS,CORNER_RADIUS,0.01])
	minkowski(){
		difference(){
			cube([AX,AY,H]);
			rotate(a=gamma,v=[1,0,0]) cube([100,100,100]);
			translate([0,AY,0]) rotate(a=90-gamma,v=[1,0,0]) cube([100,100,100]);
			translate([0,0,EZ]) rotate(a=-alpha,v=[0,1,0]) translate([-50,0,0]) cube([100,100,100]);
			translate([0,AY/2,EZ+CYL_OFF_Z]) rotate(a=90-alpha,v=[0,1,0]) cylinder(h=100,center=true,r=CYL_OFF_Z+CYL_DEPTH,$fa=1);
			translate([AX,0,0]) rotate(a=beta-90,v=[0,1,0]) cube([100,100,100]);
		}
		cylinder(h=0.01,r=CORNER_RADIUS,$fs=0.6);
		//rotate(a=90,v=[1,0,0]) cylinder(h=0.01,r=1,$fs=0.3);
	}
}

module blind_shaft(){
	translate([0,0,-SHAFT_LENGTH]) difference(){
		cylinder(r=BLIND_SHAFT_OUTER_DIAMETER/2,h=100,$fs=0.3);
		cylinder(r=BLIND_SHAFT_INNER_DIAMETER/2,h=100,$fs=0.3);
	}
}

module shaft(){
	spring_guide_length = SHAFT_X-SHAFT_THICKNESS-SHAFT_SPRING_HOLDER_WIDTH;
	spring_guide_height = SHAFT_SPRING_HOLDER_TO_BASE-SHAFT_LARGE_SLOT_TO_BASE;
	translate([0,0,-SHAFT_LENGTH]) difference(){
		union(){
			difference(){
				union(){
					difference(){
						intersection(){
							cylinder(h=100,r=SHAFT_X/2,$fs=0.3);
							translate([-SHAFT_X/2,-SHAFT_Y/2,0]) cube([SHAFT_X,SHAFT_Y,100]);
						}
						intersection(){
							cylinder(h=100,r=SHAFT_X/2-SHAFT_THICKNESS,$fs=0.3);
							translate([-SHAFT_X/2+SHAFT_THICKNESS,-SHAFT_Y/2+SHAFT_THICKNESS,0]) cube([SHAFT_X-2*SHAFT_THICKNESS,SHAFT_Y-2*SHAFT_THICKNESS,100]);
						}
					}
					translate([-SHAFT_CLIP_WIDTH/2, -SHAFT_CLIP_THICKNESS-SHAFT_Y/2,0]) cube([SHAFT_CLIP_WIDTH/2, SHAFT_CLIP_THICKNESS,SHAFT_CLIP_HEIGHT]);
					translate([-SHAFT_CLIP_WIDTH/2, SHAFT_Y/2,0]) cube([SHAFT_CLIP_WIDTH/2, SHAFT_CLIP_THICKNESS,SHAFT_CLIP_HEIGHT]);
				}
				translate([-SHAFT_CLIP_WIDTH/2, -SHAFT_CLIP_THICKNESS-SHAFT_Y/2+SHAFT_CLIP_SLOPE_DEPTH,0]) rotate(a=90+SHAFT_CLIP_ANGLE,v=[1,0,0]) cube([SHAFT_CLIP_WIDTH/2,100,100]);
				translate([-SHAFT_CLIP_WIDTH/2, SHAFT_Y/2+SHAFT_CLIP_THICKNESS-SHAFT_CLIP_SLOPE_DEPTH,0]) mirror([0,1,0]) rotate(a=90+SHAFT_CLIP_ANGLE,v=[1,0,0]) cube([SHAFT_CLIP_WIDTH/2,100,100]);
				translate([0,-50,0]) cube([100,100,SHAFT_END_CUTOUT_HEIGHT]);
				translate([0,-SHAFT_Y/2+SHAFT_THICKNESS,0]) cube([100,SHAFT_Y-SHAFT_THICKNESS*2,SHAFT_LENGTH+SHAFT_LARGE_SLOT_TO_BASE]);
				//small slot cutout
				translate([0,-SHAFT_SMALL_SLOT_WIDTH/2,0]){
					mirror([1,0,0]) cube([100,SHAFT_SMALL_SLOT_WIDTH,SHAFT_SMALL_SLOT_LENGTH-0.5*SHAFT_SMALL_SLOT_WIDTH]);
				}
				//small slot cutout
				translate([0,0,SHAFT_SMALL_SLOT_LENGTH-0.5*SHAFT_SMALL_SLOT_WIDTH]) rotate(a=-90,v=[0,1,0]) cylinder(r=SHAFT_SMALL_SLOT_WIDTH/2,h=SHAFT_X/2,$fs=0.3);
			}
			//spring holder
			translate([-SHAFT_X/2+SHAFT_SPRING_HOLDER_WIDTH/2+SHAFT_THICKNESS,0,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE]) cylinder(r=SHAFT_SPRING_HOLDER_WIDTH/2,h=100,$fs=0.3);
			intersection(){
				translate([-SHAFT_X/2+SHAFT_SPRING_HOLDER_WIDTH/2+SHAFT_THICKNESS,0,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE-SHAFT_SPRING_HOLDER_NIPPLE_HEIGHT]) cylinder(r=SHAFT_SPRING_HOLDER_NIPPLE_RADIUS,h=100,$fs=0.3);
				translate([0,0,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE-SHAFT_SPRING_HOLDER_NIPPLE_HEIGHT*1.5]) rotate(v=[0,1,0], a=atan(SHAFT_SPRING_HOLDER_NIPPLE_HEIGHT/(SHAFT_SPRING_HOLDER_NIPPLE_RADIUS*2))) translate([-50,-50,0]) cube(100,100,100);
			}
			intersection(){
				difference(){
					translate([SHAFT_X/2-SHAFT_THICKNESS,-0.5*SHAFT_SPRING_GUIDE_WIDTH,SHAFT_LENGTH+SHAFT_LARGE_SLOT_TO_BASE]) mirror([1,0,0]) cube([100,SHAFT_SPRING_GUIDE_WIDTH,100]);
					translate([-SHAFT_X/2+SHAFT_SPRING_HOLDER_WIDTH+SHAFT_THICKNESS,-0.5*SHAFT_SPRING_GUIDE_WIDTH,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE])
					mirror([1,0,0]) rotate(a=90-asin(spring_guide_height/spring_guide_length),v=[0,1,0]) mirror([0,0,1]) translate([0,0,-50]) cube([100,SHAFT_SPRING_GUIDE_WIDTH,100]);
				}
				cube([SHAFT_X-SHAFT_THICKNESS,SHAFT_Y,100],center=true);
			}
			//side spring guides
			difference(){
				translate([-SHAFT_X/2+SHAFT_THICKNESS+(SHAFT_SPRING_HOLDER_WIDTH-SHAFT_SPRING_GUIDE_WIDTH)/2,-SHAFT_Y/2+SHAFT_THICKNESS,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE-SHAFT_SPRING_GUIDE_SIDES_HEIGHT]) cube([SHAFT_SPRING_GUIDE_WIDTH,SHAFT_Y-2*SHAFT_THICKNESS,EZ-SHAFT_SPRING_HOLDER_TO_BASE+SHAFT_SPRING_GUIDE_SIDES_HEIGHT]);
				translate([-SHAFT_X/2+SHAFT_THICKNESS+(SHAFT_SPRING_HOLDER_WIDTH-SHAFT_SPRING_GUIDE_WIDTH)/2,-SHAFT_SPRING_HOLDER_WIDTH/2,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE]) rotate(a=-asin(((SHAFT_Y-SHAFT_SPRING_HOLDER_WIDTH)/2-SHAFT_THICKNESS)/SHAFT_SPRING_GUIDE_SIDES_HEIGHT),v=[1,0,0]) translate([0,0,-50]) cube([SHAFT_SPRING_GUIDE_WIDTH,100,100]);
			}
			difference(){
				translate([-SHAFT_X/2+SHAFT_THICKNESS+(SHAFT_SPRING_HOLDER_WIDTH-SHAFT_SPRING_GUIDE_WIDTH)/2,-SHAFT_Y/2+SHAFT_THICKNESS,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE-SHAFT_SPRING_GUIDE_SIDES_HEIGHT]) cube([SHAFT_SPRING_GUIDE_WIDTH,SHAFT_Y-2*SHAFT_THICKNESS,EZ-SHAFT_SPRING_HOLDER_TO_BASE+SHAFT_SPRING_GUIDE_SIDES_HEIGHT]);
				mirror([0,1,0]) translate([-SHAFT_X/2+SHAFT_THICKNESS+(SHAFT_SPRING_HOLDER_WIDTH-SHAFT_SPRING_GUIDE_WIDTH)/2,-SHAFT_SPRING_HOLDER_WIDTH/2,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE]) rotate(a=-asin(((SHAFT_Y-SHAFT_SPRING_HOLDER_WIDTH)/2-SHAFT_THICKNESS)/SHAFT_SPRING_GUIDE_SIDES_HEIGHT),v=[1,0,0]) translate([0,0,-50]) cube([SHAFT_SPRING_GUIDE_WIDTH,100,100]);
			}
		}
		translate([-SHAFT_X/2+SHAFT_SPRING_HOLDER_WIDTH+SHAFT_THICKNESS,-SHAFT_Y/2+SHAFT_THICKNESS,SHAFT_LENGTH+SHAFT_SPRING_HOLDER_TO_BASE]) mirror([1,0,0]) rotate(a=90-asin(spring_guide_height/spring_guide_length),v=[0,1,0]) mirror([0,0,1]) cube([SHAFT_THICKNESS,SHAFT_Y-2*SHAFT_THICKNESS,100]);
	}
}

module guard(){
	difference(){
		union(){
			cube([100,STRUT_THICKNESS,100],center=true);
			cylinder(r=OUTER_GUARD_RADIUS,h=100);
		}
		difference(){
			cylinder(r=INNER_GUARD_RADIUS,h=100);
			translate([-STRUT_SPACING/2-STRUT_THICKNESS,-50,EZ-STRUT_HEIGHT]) cube([STRUT_THICKNESS,100,STRUT_HEIGHT]);
			translate([STRUT_SPACING/2,-50,EZ-STRUT_HEIGHT]) cube([STRUT_THICKNESS,100,STRUT_HEIGHT]);
			translate([-50,-STRUT_SPACING/2-STRUT_THICKNESS,EZ-STRUT_HEIGHT]) cube([100,STRUT_THICKNESS,STRUT_HEIGHT]);
			translate([-50,STRUT_SPACING/2,EZ-STRUT_HEIGHT]) cube([100,STRUT_THICKNESS,STRUT_HEIGHT]);
		}
	}
}

difference(){
	keycap();
	difference(){
		translate([WallThickness, WallThickness, 0]) scale(v=[1-2*WallThickness/AX, 1-2*WallThickness/AY, 1-WallThickness/H]) keycap();
		translate([OUTER_GUARD_RADIUS+WallThickness,0,0]){
			translate([0,SHAFT_OFF_Y]) guard();
			translate([0,BLIND_SHAFT_OFF_Y]) guard();
			difference(){
				 cube([STRUT_THICKNESS,100,100],center=true);
				 translate([0,SHAFT_OFF_Y]) cube([100,2*OUTER_GUARD_RADIUS-WallThickness,100],center=true);
				 translate([0,BLIND_SHAFT_OFF_Y]) cube([100,2*OUTER_GUARD_RADIUS-WallThickness,100],center=true);
			}
		}
	}
}
intersection(){
	union(){
		translate([WallThickness, WallThickness, 0]) scale(v=[1-2*WallThickness/AX, 1-2*WallThickness/AY, 1-WallThickness/H]) keycap();
		translate([-50,-50,-99.9]) cube([100,100,100]);
	}
	translate([OUTER_GUARD_RADIUS+WallThickness,0,0]){
		translate([0,SHAFT_OFF_Y]) shaft();
		translate([0,BLIND_SHAFT_OFF_Y]) blind_shaft();
	}
}
