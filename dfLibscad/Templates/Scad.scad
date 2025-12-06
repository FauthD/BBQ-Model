// 
// Copyright (C) 2025 Dieter Fauth
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
// Contact: dieter.fauth at web.de

/* [Print] */

PrintThis = "all"; // ["all", "mount"]
RotateForPrint = [0,0,0];

/* [Sizes] */

/* [Misc] */
// For revision text (0 turns off)
Fontsize=6;	//	[0:1:10]
// For revision text
Emboss=0.3;

/* [Hidden] */

module __Customizer_Limit__ () {}
	shown_by_customizer = false;

$fa = $preview ? 2 : 0.5;
$fs = $preview ? 1 : 0.5;

// If you enable the next line, the $fa and $fs are ignored.
// $fn = $preview ? 12 : 100;

Epsilon = 0.01;
epsilon = Epsilon;

// use <dfLibscad/Revision.scad>
// use <dfLibscad/RoundCornersCube.scad>
// use <dfLibscad/Helpers.scad>
// include <svn_rev.scad>

module print(what="all")
{
	if(what == "all")
	{
		Something();
	}
	if(what == "mount")
	{
	}
}

print(PrintThis);

