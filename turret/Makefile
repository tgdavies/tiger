TARGETS=$(shell seq 0 5 | xargs printf "turret-slice-%s.stl ")

all : ${TARGETS}

clean :
	rm ${TARGETS}

%.stl : turret.scad
	openscad -Dslice_i=$(shell expr $@ : 'turret-slice-\([0-9]\).stl') -o $@ turret.scad
