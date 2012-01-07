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
	intersection(){
		cylinder(h=100,r=SHAFT_X/2);
		translate([-SHAFT_X/2,-SHAFT_Y/2,0]) cube([SHAFT_X,SHAFT_Y,100]);
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
		translate([OUTER_GUARD_RADIUS+WallThickness,AY/2]) union(){
			guard();
			shaft();
		}
	}
}
