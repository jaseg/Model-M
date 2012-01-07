//measures are in millimeters
AY=23.0;
AX=19.0;
BY=18.0;
BLX=14.5;
EZ=11.0;
FLZ=14.0;
H=12.75;
CYL_OFF_Z=70;
CYL_DEPTH=0.1;
CLIP_X=2;
CLIP_Y=0.75;
CLIP_H=3*CLIP_Y;
CORNER_RADIUS=2;
INNER_GUARD_RADIUS=6.5;
OUTER_GUARD_RADIUS=7.5;
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

}

module shaft(){
	translate([0,0,-SHAFT_LENGTH]) difference(){
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
		translate([0,-SHAFT_SMALL_SLOT_WIDTH/2,0]){
			mirror([1,0,0]) cube([100,SHAFT_SMALL_SLOT_WIDTH,SHAFT_SMALL_SLOT_LENGTH-0.5*SHAFT_SMALL_SLOT_WIDTH]);
		}
		translate([0,0,SHAFT_SMALL_SLOT_LENGTH-0.5*SHAFT_SMALL_SLOT_WIDTH]) rotate(a=-90,v=[0,1,0]) cylinder(r=SHAFT_SMALL_SLOT_WIDTH/2,h=SHAFT_X/2,$fs=0.3);
	}
}

module guard(){
	difference(){
		union(){
			cube([1,100,100],center=true);
			cube([100,1,100],center=true);
			cylinder(r=OUTER_GUARD_RADIUS,h=100);
		}
		cylinder(r=INNER_GUARD_RADIUS,h=100);
	}
}

difference(){
	keycap();
	difference(){
		translate([WallThickness, WallThickness, 0]) scale(v=[1-2*WallThickness/AX, 1-2*WallThickness/AY, 1-WallThickness/H]) keycap();
		translate([OUTER_GUARD_RADIUS+WallThickness,AY/2]) guard();
	}
}
intersection(){
	union(){
		translate([WallThickness, WallThickness, 0]) scale(v=[1-2*WallThickness/AX, 1-2*WallThickness/AY, 1-WallThickness/H]) keycap();
		translate([-50,-50,-99.9]) cube([100,100,100]);
	}
	translate([OUTER_GUARD_RADIUS+WallThickness,AY/2]) union(){
		shaft();
	}
}
