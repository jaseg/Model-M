//measures are in millimeters
AY=18.5;
AX=19.0;
BY=12.5;
BLX=14.5;
EZ=11.0;
FLZ=14.0;
H=12.75;
CYL_OFF_Z=50;
CYL_DEPTH=0.75;


WallThickness=0.75;
ClipWidth=2.2;
ClipDepth=0.75;

ascfront=FLZ/sqrt(pow(FLZ,2)-pow(H,2));
asctop=(H-EZ)/sqrt(pow(BLX,2)-pow((H-EZ),2));

alpha=asin((H-EZ)/BLX);
beta=asin(H/FLZ);
gamma=90-asin((0.5*(AY-BY))/EZ);

difference(){
	cube([AX,AY,H]);
	rotate(a=gamma,v=[1,0,0]) cube([100,100,100]);
	translate([0,AY,0]) rotate(a=90-gamma,v=[1,0,0]) cube([100,100,100]);
	translate([0,0,EZ]) rotate(a=-alpha,v=[0,1,0]) translate([-50,0,0]) cube([100,100,100]);
	translate([0,AY/2,EZ+CYL_OFF_Z]) rotate(a=90-alpha,v=[0,1,0]) cylinder(h=100,center=true,r=CYL_OFF_Z+CYL_DEPTH,$fa=1);
	translate([AX,0,0]) rotate(a=beta-90,v=[0,1,0]) cube([100,100,100]);
}