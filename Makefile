OPENSCAD=~/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD

images/barrel.png: *.scad
	$(OPENSCAD) -o $@ --autocenter --viewall --render kylpytynnyri.scad
