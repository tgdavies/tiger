$fa = 1;
$fs = 0.25;
barbette_d = 60;
smooth_r = 1;

module back_curve() {
		translate([-45 + 10,0,0]) { cylinder(r = 10, h = 0.01); }
}

module blank_top() {	
		hull() {
			back_curve();
			translate([-2,0,0]) { 
				intersection() {
					cylinder(r = 25, h = 0.01);
					translate([5,-25,-0.02]) { cube([50,50,1]); }
				}
			}
			translate([-(41 - smooth_r),17-smooth_r,0]) { cylinder(r = smooth_r, h = 0.01); }
			translate([-(41 - smooth_r),-(17-smooth_r),0]) { cylinder(r = smooth_r, h = 0.01); }
		}
}

module resize() {
	difference() {
		translate([0,0,0.0045]){cube([98,58,0.009], center=true);}
		minkowski() {
			difference() {
				translate([0,0,0.0045]){cube([100,60,0.009], center=true);}
				child(0);
				//projection(cut = false) { child(0); }
			}
			cylinder(r = 1.5, h = 0.01);
		}
	}
}

module blank_base() {
	hull() {
		cylinder(r = barbette_d / 2, h = 0.01);
		back_curve();
		translate([-(39-smooth_r),24-smooth_r,0]) { cylinder(r = smooth_r, h = 0.01); }
		translate([-(39-smooth_r),-(24-smooth_r),0]) { cylinder(r = smooth_r, h = 0.01); }
	}
}

module blank() {
	hull() {
		blank_base();
		translate([0,0,18]) {blank_top();}
	}
}

module core() {
	difference() {
		hull() {
			translate([0,0,16]) {resize() {blank_top();}}
			translate([0,0,-0.1]){resize() {blank_base();}}
		}
		translate([0,0,-3.01]) {
			roof();
			scale([1,-1,1]) { roof(); }
			}

	}
}

module roof1() {
		translate([-25 - 22, 0, 18]) { rotate([-8.5,0,0]) {translate([-1,-1,0]) {cube([30,30,5]);}}}
}

module roof2() {
		translate([-25 - 2, 0, 18.5]) { rotate([-8.5,5.2,0]) {translate([0, -5, 0]){cube([27,40,10]);}}}
}

module roof3() {
		translate([-2, 0, 16.5]) { rotate([-8.5,5.2,0]) {translate([0, -5, 0]){cube([35,40,10]);}}}
}

module roof() {
	union() {
		roof1();
		roof2();
		roof3();
	}
}

module c_corner() {
	union() {
		translate([0,0,2]) {sphere(r = 2);}
		cylinder(r = 2, h = 2);
	}
}

module dome() {
	translate([7,-3,3.25]) {
	hull() {
			rotate_extrude(convexity = 10)
			translate([1.5, 0, 0])
			circle(r = 0.75);
			
			translate([0,0,-2]) {cylinder(r = 2.25, h = 2.0);}
		}
	}
}

module rangefinder_hood() {
	difference() {
		translate([-34.5,0,16]) {
			union() {
				hull() {
					c_corner();
					translate([0,5,0]) {c_corner();}
					translate([2,13,0]) {c_corner();}
					translate([10,13,-1.5]) {c_corner();}
					translate([8,0,-1.5]) {c_corner();}
				}
				hull() {
					translate([0,0,0]) {c_corner();}
					translate([8,0,-1.5]) {c_corner();}
					translate([9,-8,-1.5]) {c_corner();}
					translate([2,-8,-0.25]) {c_corner();}
				}
				dome();
			}
		}
		plain_turret();
	}
}

sh_w = 2.5;

module sighting_hood() {
	hull() {
		rotate([90,0,0]){translate([0,0,-sh_w/2]) {cylinder(r = 2.5, h = sh_w);}}
		translate([6 - 1/2,0,0.5]) {cube([1,sh_w,3.8], center = true);}
	}
}
csh_w = 3;

csighting_hood_extension_z = 15.2;
rangefinder_hood_extension_z = 17;
sighting_hood_extension_z = 13;

module csighting_hood() {
		difference() {
			translate([21,0,-11.5]) {
				scale([1.5,1,1.5]) {
					intersection() {
						rotate([90,0,0]){translate([0,0,-csh_w/2]) {cylinder(r = 20, h = csh_w);}}
						translate([-6.5,0,18.5]) {cube([7,csh_w,2.5], center = true);}
					}
						//translate([-7,0,13]) {cube([7,3.5,2.5], center = true);}
				}
			}
			plain_turret();
		}
}

// how far below the hoods the stub goes
extent_depth = 1.5;

module extended(z) {
	union() {
		child(0);
		extend(extent_depth, z) { child(0); }
	}
}

module cutout(z) {
	extend(10, z) { child(0); }
}

// extend h mm below the object's extents
// z is the z coordinate of the base of the shape
module extend(h, z) {
	union() {
		child(0);
		translate([0,0,z-extent_depth]) {
			linear_extrude(height = h, center = false, convexity = 2, twist = 0) {
				projection(cut=false) { child(0); }
			}
		}
	}
}

// turret with no hoods, solid
module plain_turret() {
	difference() {
			blank();
			roof();
			scale([1,-1,1]) { roof(); }
	}
}

module p_sighting_hood() {
		difference() {
			translate([12,16,13]) {sighting_hood();}
			plain_turret();
		}
}

module s_sighting_hood() {
		difference() {
			translate([12,-16,13]) {sighting_hood();}
			plain_turret();
		}
}

// what the final product looks like, not for CAM
module turret_vis() {
	difference() {
		union() {
			plain_turret();
			rangefinder_hood();
			s_sighting_hood();
			p_sighting_hood();
			csighting_hood();
		}
		core();
	}
}

barrel_d = 8;
// distance between barrel centers
barrel_space = 20;

module barrel_slot(port) {
	translate([29,(port ? 1 : -1) * barrel_space / 2,9]) { rotate([0, -21, 0]) { multmatrix(m) cube([10,barrel_d,18], center=true); } }
}

m = [
	[1,0.3,0,0],
	[0,1,0,0],
	[0,0,1,0],
	[0,0,0,1]
	];

module turret_cam() {
	difference() {
		plain_turret();
		cutout(rangefinder_hood_extension_z) { rangefinder_hood(); }
		cutout(sighting_hood_extension_z) { s_sighting_hood(); }
		cutout(sighting_hood_extension_z) { p_sighting_hood(); }
		cutout(csighting_hood_extension_z) { csighting_hood(); }
		core();
		//barrel_slot(true);
		//barrel_slot(false);
	}
}

module test() {
			//cutout(rangefinder_hood_extension_z) { rangefinder_hood(); }
			//extended(rangefinder_hood_extension_z) { rangefinder_hood(); }
					extended(sighting_hood_extension_z) { s_sighting_hood(); }
		extended(sighting_hood_extension_z) { p_sighting_hood(); }
		extended(csighting_hood_extension_z) { csighting_hood(); }

}

slice_h = 3;
module slice(i) {
	intersection() {
		turret_cam();
		translate([0,0,(i + 0.5) * slice_h]) { cube([100,100,slice_h], center=true);}
	}
}
//slice_i = 4;
//turret_cam();
//barrel_slot(true);
slice(slice_i);

//test();



