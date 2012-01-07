//measures are in millimeters
AY=27.0;
AX=19.0;
INNER_AY=18.5;
INNER_BY=12.5;
BY=22.0;
BLX=14.5;
EZ=11.0;
FLZ=14.0;
H=12.75;
CYL_OFF_Z=100;
CYL_DEPTH=0.05;
CLIP_X=2;
CLIP_Y=0.75;
CLIP_H=3*CLIP_Y;
CLIP_DISTANCE=17.0;
CORNER_RADIUS=2;

WallThickness=0.75;
ClipWidth=2.2;
ClipDepth=0.75;

//ascfront=FLZ/sqrt(pow(FLZ,2)-pow(H,2));
//asctop=(H-EZ)/sqrt(pow(BLX,2)-pow((H-EZ),2));

//curve control rod
//translate([14,4,0]) cube([1,1,H]);

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
			translate([0,AY/2,EZ+CYL_OFF_Z]) rotate(a=90-alpha,v=[0,1,0]) cylinder(h=100,center=true,r=CYL_OFF_Z+CYL_DEPTH,$fa=2);
			translate([AX,0,0]) rotate(a=beta-90,v=[0,1,0]) cube([100,100,100]);
		}
		cylinder(h=0.01,r=CORNER_RADIUS,$fs=0.6);
		//rotate(a=90,v=[1,0,0]) cylinder(h=0.01,r=1,$fs=0.3);
	}
}

module struts(){
	difference(){
		cube([AX,INNER_AY,H]);
		rotate(a=gamma,v=[1,0,0]) cube([100,100,100]);
		translate([0,INNER_AY,0]) rotate(a=90-gamma,v=[1,0,0]) cube([100,100,100]);
		translate([0,0,EZ]) rotate(a=-alpha,v=[0,1,0]) translate([-50,0,0]) cube([100,100,100]);
		translate([0,INNER_AY/2,EZ+CYL_OFF_Z]) rotate(a=90-alpha,v=[0,1,0]) cylinder(h=100,center=true,r=CYL_OFF_Z+CYL_DEPTH,$fa=2);
		translate([AX,0,0]) rotate(a=beta-90,v=[0,1,0]) cube([100,100,100]);
	}
}

module clip(){
	difference(){
		cube([CLIP_X,CLIP_Y,CLIP_H]);
		translate([0,CLIP_Y,0]) rotate(a=asin(CLIP_Y/CLIP_H),v=[1,0,0]) cube([100,100,100]);
	}
}

//clip distance control rod
//translate([(AX-CLIP_X)/2,(AY-CLIP_DISTANCE)/2,0]) cube([1,CLIP_DISTANCE,1]);
translate([(AX-CLIP_X)/2,(AY-CLIP_DISTANCE)/2,0]) clip();
translate([(AX-CLIP_X)/2,(AY+CLIP_DISTANCE)/2,0]) mirror([0,1,0]) clip();

difference(){
	keycap();
	difference(){
		translate([WallThickness, WallThickness, 0]) scale(v=[1-2*WallThickness/AX, 1-2*WallThickness/AY, 1-WallThickness/H]) keycap();
		translate([0,(AY-INNER_AY)/2,0]) difference(){
			struts();
			translate([WallThickness, WallThickness, 0]) scale(v=[1-2*WallThickness/AX, 1-2*WallThickness/INNER_AY, 1-WallThickness/H]) struts();
		}
		//translate([0,(AY-CLIP_DISTANCE)/2-WallThickness,0]) cube([100,WallThickness, 100]);
		//translate([0,(AY+CLIP_DISTANCE)/2,0]) cube([100,WallThickness, 100]);
	}
}
