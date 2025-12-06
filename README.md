# BBQ-Model
A simple customizable model of a BBQ grill.
Written in openscad.

I created it because we needed some nice way to present a gift (money for a BBQ grill).
There is enough space inside for even a bigger amount.

Inspired by this nice design:
https://www.thingiverse.com/thing:6632766. Created from scatch with openscad.


# Customizer
The original customizer will not show any values (on purpose).
But you can adjust any values in the source code.
The size of the current values are 200mm * 100mm * 135mm.
There is a variable "Scale" that can be used to adjust the sizes.

## Warning
Most of the values are using thr Scale, but there are a few dirty spots that need tweaking after a size change.

# Printing
I printed with PLA+, 20% infill, 0.4mm nozzle, variable layerheight (0.2mm) with Orca.
Find the .stl files in the STL folder.

<img title="All" src="PNG/all_PNG.png" width="500">
<img title="All" src="PNG/all_PNG.png" width="500">

## Parts
The grill consist of quite a few printed parts. This allows for different colors. In my case I used gray and black.
| Lower  | Upper  | Cover  | Platform |
| :----: | :----: | :----: |:----:    |
| <img title="lower" src="PNG/lower.png" width="200"> | <img title="upper" src="PNG/upper.png" width="350"> | <img title="cover" src="PNG/cover.png" width="200"> | <img title="platform" src="PNG/platform.png" width="300">

| handle  | knob  | wheel  | wheel washer |
| :----: | :----: | :----: |:----:        |
| <img title="handle" src="PNG/handle.png" width="200"> | <img title="knob" src="PNG/knob.png" width="100"> | <img title="wheel" src="PNG/wheel.png" width="100"> | <img title="wheel_washer" src="PNG/wheel_washer.png" width="50">|

## Needed parts
### Print
- One of each: lower, upper, cover.
- 3 handles
- 6 knobs
- 4 wheels
- 4 wheel washers
### Metall
I used DIN7500 self tapping M3, but you can tap und use regular M3.
- 7 screws M3*10 (knobs and platform)
- 2 screws M3*8 (cover)
- 4 screws M3*18 (15..20 is ok too) (wheels)
- 8 screws 2*8mm self tapping (handles, mount upper and lower together)


# Source files

- grill.scad
	The grill creator.
- grill.json
	Defines sizes and parts.
- svn_rev.scad
	Contains the subversion revision and is automatically created by the Makefile and SubWCRev (subwcrev).
	The revision string gets printed onto the bigger parts.
- Makefile
	The control file for make (I use gmake on Linux, others not tested).

 # Rebuild
	On Linux open a shell in the source directory, then type make and wait.
	The png and stl files will get created in subdirs. This takes a while, so be patient.
	On Windows, Mac, your are on your own.

	A manual rebuild with openscad is also possible, open grill.scad in openscad, select a thing in the customizer (PrintThis) press F6, wait, then F7 to export the stl. To much work for me, therefore I created the Makefile.

# Details on the Makefile
	It parses the json file to get the list of things/flavours to build.
	Then it creates pictures in PNG directory and the stl in STL directory.

	Not used by this project:
	It also checks for an auto-versioning template file (svn_rev.tmpl). If found, calls SubWCRev (see pysubwcrev below) to create svn_rev.scad. 
	I do not provide the template file (not useful for you), so this rule will not execute on your machine (I provide the svn_rev.scad instead).
	
	You might also notice that it checks for my library dfLibscad. If found, the libraries svn_rev.tmpl file gets translated into 
	another svn_rev.scad file with a version string of the library.
	Designs can use the module WriteRevision() to print the revision strings onto the part.

	I use this Makefile in other projects as well. Usually, just the very few first lines need to be adjusted.
	Feel free to reuse it.

## Requirements

- The Makefile expects openscad-nighly to be installed. I use it because it is much faster.
For openscad stable, locate the two lines with "OPENSCAD ?=" and comment/uncomment the version you want.

	>"OPENSCAD ?= openscad-nightly --enable=fast-csg --enable=fast-csg-trust-corefinement --enable=lazy-union"
	
	>"# OPENSCAD ?= openscad"

- On Linux, grep is installed by default, for poor OS you can use either cygwin or the WSL (untested).
	

# Github
- This project: https://github.com/FauthD/BBQ-Model

- My github projects: 	https://github.com/FauthD?tab=repositories

- pysubwcrev is a cross-platform version of subwcrev. It can be found there https://github.com/FauthD/pysubwcrev

