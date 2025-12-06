//
// Copyright (C) 2025 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print] */

PrintThis = "all"; // ["all", "upper", "lower", "handle", "knob", "wheel", "wheel_washer", "cover", "mount", "mount_all", "mount_open", "cut1", "cut2", "platform", "nothing"]

/* [Sizes] */

/* [Misc] */

/* [Hidden] */

module __Customizer_Limit__ () {}
	shown_by_customizer = false;

preview=$preview;
$fa = preview ? 2 : 0.25;
$fs = preview ? 1 : 0.25;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;
Epsilon = 0.01;
epsilon = Epsilon;

use <dfLibscad/Revision.scad>
use <dfLibscad/RoundCornersCube.scad>
include <./svn_rev.scad>

Tolerance=0.2;
Scale=0.8;
Rounding=4*Scale;

Length=150*Scale;
Width=100*Scale;
BurnerHeight=25*Scale;
Height=BurnerHeight+69*Scale;
KnobAngle=60;
WheelInset=15*Scale;
Door_W=Length/2-12;
DoorDiff=(BurnerHeight+5)*Scale;

ExtensionLength=47*Scale;

M3_DIN7500=2.8;
M3_HeadDiameter=6;
M3_HeadHeight=3;

HingeScrewhole=3.5;
HingeScrewholeDIN7500=M3_DIN7500;
HingeOffset=10;
HingeWall=4.2;
HingeSize=2.5*HingeScrewhole;

HandleDiameter=4*Scale;
HandleLength=42*Scale;
HandleDistance=10*Scale;
HandleScrewDiameter=2.4;
HandleScrewHoleDiameter=1.9;

WheelAxisDiameter=M3_DIN7500;
WheelMountDiameter=3.5;
WheelDiameter=19*Scale;

KnobDiameter=15*Scale;
KnobAxisDiameter=3.5;
KnobAxisDiameterDIN7500=M3_DIN7500;

ConnectScrewDiameter=1.9;
ConnectScrewBohr=2.4;

Wall=3.5;

// For revision text (0 turns off)
Fontsize=6;	//	[0:1:10]
// For revision text
Emboss=0.5;

Author="Dieter Fauth";
Author2="Created by";

module PrintRevision(rot=[0,0,90], mirror=false)
{
	// print revision
	if(Fontsize>0)	// turn of by setting font size to 0
	{
		color("black")
		{
			WriteRevision(rev=SVN_RevisionStr, height=Emboss, fontsize=Fontsize, oneline=true, halign="center", rot=rot, mirror=mirror);
		}
	}
}

module PrintAuthor(name="", height=0.3, fontsize=Fontsize, font = "Liberation Mono:bold", halign="left", valign="top", mirror=false, rot=[0,0,0], oneline=false, lib=true)
{
	if(fontsize>0)	// turn of by setting font size to 0
	{
		color("black")
		{
			rotate(rot)
				mirror([mirror?1:0,0,0])
					linear_extrude(height = height, center = true, convexity = 10)
					{
						text(name, size=fontsize-1, font = font, halign=halign, valign=valign);
					}
		}
	}
}

module M3_Head()
{
	cylinder(d=M3_HeadDiameter, h=M3_HeadHeight);
}

module Lower()
{
	wall=Wall;
	width=Width-2*wall-Tolerance;
	length=Length-2*wall-Tolerance;
	door_h=Height-DoorDiff;
	door_thick=1.0*Scale;
	difference()
	{
		union()
		{
			RoundCornersCube([length, width, Height], center=true, r=Rounding);
			// doors
			for(dis=[Door_W/2+1,-Door_W/2-1])
			{
				translate([dis, -width/2, -DoorDiff/2])
					cube([Door_W, door_thick, door_h], center=true);
			}
		}
		translate([0,0,wall])
			RoundCornersCube([length-wall, width-wall, Height], center=true, r=Rounding-1.5);
		// holes for handles
		for(dis=[Door_W/2+1,-Door_W/2-1])
		{
			translate([dis, 2, -Height/2+door_h-7])
				HandleHoles();
		}
		// holes for wheels
		for(x=[1,-1])
		{
			for(y=[1,-1])
			{
				translate([x*(length/2-WheelInset), y*(width/2-WheelInset), -Height/2])
					cylinder(d=WheelMountDiameter, h=Height, center=true);
			}
		}
		// holes for connecting upper and lower
		translate([0,0,Height/2-BurnerHeight/2])
			rotate([0,90,0])
				cylinder(d=ConnectScrewBohr, h=2*Length, center=true);
		// hole for mounting on platform
		cylinder(d=WheelMountDiameter, h=2*Height, center=true);

	}
	translate([0, 1.2*Fontsize, -Height/2+wall])
		rotate([0,0, -90])
			PrintRevision();

	translate([0, -2*1.2*Fontsize, -Height/2+wall])
		PrintAuthor(name=Author2, halign="center", valign="bottom");
	translate([0, -3*1.2*Fontsize, -Height/2+wall])
		PrintAuthor(name=Author, halign="center", valign="bottom");
}

module MountLower()
{
	wall=Wall;
	width=Width-2*wall-Tolerance;
	length=Length-2*wall-Tolerance;
	door_h=Height-DoorDiff;

	translate([0,0,BurnerHeight])
	{
		Lower();
		// wheels
		for(x=[1,-1])
		{
			for(y=[1,-1])
			{
				translate([x*(length/2-WheelInset), y*(width/2-WheelInset), -Height/2-3])
					rotate([180,0,90])
						Wheel();
				translate([x*(length/2-WheelInset), y*(width/2-WheelInset), -Height/2-wall/2])
					rotate([180,0,90])
						WheelWasher();
			}
		}
		// handles
		for(dis=[Door_W/2+1,-Door_W/2-1])
		{
			translate([dis, -width/2-2*Tolerance, -Height/2+door_h-7])
				rotate([90,0,0])
					Handle();
		}
	}
}


module Hinge(cube_offset=HingeSize, diameter=HingeScrewhole)
{
	size=HingeSize;
	wall=HingeWall;

	difference()
	{
		union()
		{
			cylinder(d=size, h=wall, center=true);
			translate([cube_offset/2, 0,0])
				cube([cube_offset, size, wall], center=true);
		}
		cylinder(d=diameter, 3*wall, center=true);
	}
}

module SidePlate(offset)
{
	inset=0;
	w=Width-inset;
	h= 17;
	wall=4;
	difference()
	{
		translate([0,0, h/2])
			cube([ExtensionLength, w, h], center=true);

		translate([-offset, -Width/2, h/2])
			rotate([45,0,0])
				cube([ExtensionLength+Epsilon, w, h], center=true);

		translate([0, -Width/2-5, h/2+2])
			rotate([45,0,0])
				cube([ExtensionLength+Epsilon, w, h], center=true);
	}
	translate([0,0, wall/2])
		cube([ExtensionLength, w, wall], center=true);
}

module SidePlateLeft(offset)
{
	h= 17;
	wall=Wall;
	difference()
	{
		SidePlate(offset=-offset);

		translate([0, 10, h/2+wall/2])
			cube([ExtensionLength-6, Width-27, h+Epsilon], center=true);
	}
}

module SidePlateRight(offset)
{
	SidePlate(offset=offset);
}

module BurnerBase()
{
	h=BurnerHeight;
	front_extend=14*Scale;
	w=Width+front_extend;
	wall=Wall;

	difference()
	{
		translate([0, -front_extend/2, h/2])
			cube([Length, w, h], center=true);
	
		translate([0, -w/2+h/2+wall, h/2-1.5])
			rotate([KnobAngle, 0,0])
				cube([Length-2*wall, Width-2*wall, h+Epsilon], center=true);

		translate([0, -w/2-15, h/2-1])
			rotate([KnobAngle, 0,0])
				cube([Length+Epsilon, w, h], center=true);
	
	}
	// close hole underneath the dials
	translate([0, -w/2+wall/2, 1.6*wall/2])
		cube([Length, front_extend+wall, 1.6*wall], center=true);
	// add some material to allow for rounded edges at the front side iof the burner
	for(x=[1,-1])
	{
		translate([x*(Length/2-2.5*Rounding/2), -Width/2+front_extend/2, h/2])
			cube([2.5*Rounding, front_extend, h], center=true);
	}
}

module Burner()
{
	h=BurnerHeight;
	front_extend=10;
	w=Width+front_extend;
	wall=Wall;

	difference()
	{
		BurnerBase();
	
		// hollow
		translate([0, 0, h/2])
			RoundCornersCube([Length-2*wall, Width-2*wall, 2*h], center=true, r=Rounding);
	}
}

module UpperBase()
{
	base_h=3.5;
	side_offset=3.5;
	total_l = Length+2*ExtensionLength-2*side_offset;
	
	side=Length/2+ExtensionLength/2;
	translate([-side, 0, 0])
		SidePlateLeft(side_offset);
	
	translate([side, 0, 0])
		SidePlateRight(side_offset);

	Burner();

	h=BurnerHeight+HingeSize/2;
	for(x=[1,-1])
	{
		translate([x*Length/2 - x*HingeOffset, Width/2+HingeSize/2, h])
			rotate([0,90,0])
				Hinge(h);
	}
	translate([0, Width/2, BurnerHeight/2])
		rotate([0,90,90])
			PrintRevision();
}

module Upper()
{
	wall=Wall;
	dist=1.6*KnobDiameter;
	difference()
	{
		UpperBase();
		len=Length/2-dist/2-3;
		for(l=[-len:dist:Length/2])
		{
			translate([l,-Width/2, 10])
				rotate([KnobAngle, 0, 0])
					Axis(KnobAxisDiameter, 20);
		}
		// holes for connecting upper and lower
		translate([wall+1.5, 0, BurnerHeight/2])
			rotate([0,90,0])
				cylinder(d=ConnectScrewDiameter, h=Length+4*wall, center=true);
	}
}

module MountUpper()
{
	Upper();

	dist=1.6*KnobDiameter;
	len=Length/2-dist/2-3;
	for(l=[-len:dist:Length/2])
	{
		translate([l,-Width/2-6, 13.5])
			rotate([KnobAngle, 0, 0])
				Knob();
		translate([l,-Width/2, 10])
			rotate([KnobAngle, 0, 0])
				M3_Head();
	}
}


module RoundedCylinder(d, h, center)
{
	len=h-d;
	cylinder(d=d, h=len, center=true);
	for(z=[1,-1])
	{
		translate([0,0,z*len/2])
			sphere(d=d);
	}
}

module CoverBase()
{
	base_h=1*Scale;
	h0=13*Scale;
	h=39*Scale;
	h2=11*Scale;
	hullradius=25*Scale;
	w0=Width/2-hullradius/2;
	w1=Width/3-2;
	w2=-4*Scale;
	w3=-Width/2+hullradius/4+-1*Scale;
	l=Length;
	wall=3*Scale;

	hull()
	{
		translate([0,w0,h0])
			rotate([0,90,0])
				RoundedCylinder(d=hullradius, h=l, center=true);
		translate([0,w1,h])
			rotate([0,90,0])
				RoundedCylinder(d=hullradius, h=l, center=true);
		translate([0,w2,h])
			rotate([0,90,0])
				RoundedCylinder(d=hullradius, h=l, center=true);
		translate([0,w3,h2])
			rotate([0,90,0])
				RoundedCylinder(d=hullradius/3, h=l, center=true);
		translate([0, 0, base_h/2])
			RoundCornersCube([l, Width+wall, base_h], center=true, r=Rounding);
	}
}

module CoverSkin()
{
	h=50;
	difference()
	{
		CoverBase();
		translate([0,Width,h/2-Epsilon])
			cube([Length+Epsilon, Width, h], center=true);
	}
}

module Cover()
{
	scalex=0.97;
	scaley=0.95;
	scalez=0.95;
	difference()
	{
		CoverSkin();
		translate([0,0,-Epsilon])
			scale([scalex,scaley,scalez])
				CoverSkin();

		// holes for handle
		translate([0,0,-22*Scale])
			rotate([-45,0,0])
				HandleHoles();
	}

	for(x=[1,-1])
	{
		translate([x*Length/2 - x*HingeOffset - x*Tolerance - x*HingeWall, Width/2+HingeSize/2, HingeSize/2])
			rotate([90,0,-90])
				Hinge(diameter=HingeScrewholeDIN7500);
	}
	translate([0, Width/2, 1.2*Fontsize+1])
		rotate([0,90,90])
			PrintRevision();
	
	// increase contact to print bed
	wall=3;
	translate([0, Width/2-wall/2-2*wall/2, wall/4])
		RoundCornersCube([Length, 3*wall, wall/2], center=true, r=Rounding);
	translate([0, -Width/2+wall+0.5, wall/4])
		RoundCornersCube([Length, 2*wall, wall/2], center=true, r=Rounding);
	for(x=[1,-1])
	{
		translate([x*Length/2-x*2*wall/2, 0, wall/4])
			cube([2*wall, Width-3*wall, wall/2], center=true);
	}
}

module MountCover(angle=0)
{
	h=16;
	w=-Width/2+(9*Scale);
	move=Width/2+HingeSize/2;

	handle_angle=45;

	translate([0, move,BurnerHeight+HingeSize/2])
		rotate([-angle, 0,0])
			translate([0, -move, -HingeSize/2])
			{
				Cover();
				translate([0, w, h])
					rotate([handle_angle, 0,0])
						Handle();
			}
}

module Handle()
{
	dia=HandleDiameter;
	l=HandleLength;
	distance=6;
	frame=3*dia;
	frame_h=0.44;

	difference()
	{
		union()
		{
			translate([0,0,distance])
				rotate([0,90,0])
					cylinder(d=dia, h=l, center=true);

			for (x=[l/2,-l/2, 0])
			{
				translate([x,0,distance/2])
					cylinder(d=dia, h=distance, center=true);
				translate([x,0,distance])
					sphere(d=dia);
				translate([x,0,0])
					cylinder(d=frame, h=frame_h);
				translate([0,0,frame_h/2])
					cube([l, frame, frame_h], center=true);
			}

		}
		for (x=[l/2,-l/2])
		{
			translate([x,0,0])
				cylinder(d=HandleScrewHoleDiameter, h=distance+4, center=true);
		}
	}
}


module HandleHoles()
{
	for(dis=[HandleLength/2,-HandleLength/2])
	{
		translate([dis, -Width/2, 0])
			rotate([90,0,0])
				cylinder(d=HandleScrewDiameter, h=Width/2, center=true);
	}
}

module Wheel()
{
	dia=WheelDiameter;
	thick=7;

	difference()
	{
		union()
		{
			translate([0,0,dia/2])
				for(distance=[thick,-thick])
				{
					translate([distance,0,0])
						rotate([0,90,0])
							cylinder(d=dia, h=thick, center=true);
				}
				l=2*dia/3;
				translate([0,0, l/2])
					cube([thick+Epsilon, thick, l], center=true);
				l2=1;
				translate([0,0, l2/2])
					cube([3*thick, thick, l2], center=true);
		}
		translate([0,0,-thick])
			cylinder(d=WheelAxisDiameter, h=5*thick, center=false);
		translate([0,0, -thick/2])
			cylinder(d=WheelAxisDiameter+0.3, h=thick, center=false);
		// cube([20,20,20]);
	}
}

module WheelWasher()
{
	thick=7;
	h=3;
	difference()
	{
		cylinder(d=thick, h=h, center=true);
		cylinder(d=WheelMountDiameter, h=3*h, center=true);
		translate([0,0, 1.7*h])
			cylinder(d=WheelMountDiameter+0.4, h=3*h, center=true);
	}
}

module Knob()
{
	dia=KnobDiameter;
	h=8;
	cut=0.6;
	axis_length=h+1;

	difference()
	{
		cylinder(d=dia, h=h);
		for(o=[dia/2-cut,-dia/2+cut])
		{
			translate([o, 0,h])
				cube([dia/2, 2*dia, h], center=true);
		}
		translate([0, 0, -axis_length/4])
			Axis(KnobAxisDiameterDIN7500, axis_length);
		translate([0, 0, -axis_length/4])
			Axis(KnobAxisDiameterDIN7500+0.3, axis_length/2);
		// cube([20,20,20]);
	}
}

module Axis(diameter=0, h=6)
{
	cylinder(d=diameter, h=h);
}

module MountKnob()
{
	print("upper");
	translate([-3.5, -29, 15])
		rotate([55,0,0])
			Knob();
}

module MountHandle()
{
	print("upper");
	translate([-3.5+5, -18, 22])
		rotate([45,0,0])
			Handle();
}

module MountWheel()
{
	print("lower");
	translate([40,0,42])
		rotate([0,0,90])
			Wheel();
}

module MountAll(angle=0)
{
	MountLower();
	translate([0,0,Height/2])
	{
		MountUpper();
		MountCover(angle);
	}
}

module MountOpen()
{
	MountAll(60);
}

module Mount()
{
	MountAll();
}

module Cut1()
{
	difference()
	{
		MountAll();
		cube([Length, Width, Height]);
		translate([-Length, -Width,0])
			cube([Length, Width, Height]);
	}
}

module Cut2()
{
	difference()
	{
		MountAll();
		translate([0,0 ,Height+BurnerHeight-Epsilon])
			cube([Length+Epsilon, Width+Epsilon, Height], center=true);
	}
}

module PlatformBase(d, w, h, thickness=1.5)
{
	border = thickness * 3;
	scale = w/d;
	echo(scale);
	scale([1,scale,1])
	{
		difference()
		{
			cylinder(d=d, h=h);
			translate([0,0,thickness])
				cylinder(d=d-border, h=h);
		}
	}
}

module Platform()
{
	thickness=1.5;
	PlatformBase(260, 210, 11, 1.5);

	h=WheelDiameter+thickness+3;
	difference()
	{
		cylinder(d=20, h=h);
		cylinder(d=WheelAxisDiameter, h=2*h);
	}
}

module All()
{
	Platform();
	translate([0,0,Height/2])
		MountOpen();

}
module print(what="all")
{
	if(what == "handle")
	{
		Handle();
	}
	if(what == "knob")
	{
		Knob();
	}
	if(what == "wheel")
	{
		Wheel();
	}
	if(what == "wheel_washer")
	{
		WheelWasher();
	}
	if(what == "lower")
	{
		Lower();
	}
	if(what == "upper")
	{
		Upper();
	}
	if(what == "cover")
	{
		Cover();
	}
	if(what == "mount")
	{
		Mount();
	}
	if(what == "mount_all")
	{
		MountAll();
	}
	if(what == "mount_open")
	{
		MountOpen();
	}
	if(what == "cut1")
	{
		Cut1();
	}
	if(what == "cut2")
	{
		Cut2();
	}
	if(what == "platform")
	{
		Platform();
	}
	if(what == "all")
	{
		All();
	}
}

print(PrintThis);
