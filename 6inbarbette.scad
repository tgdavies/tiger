$fn=50;
face_r = 21;
face_h = 17;
face_depth = 12;

slot_h = 8;
slot_below = (face_h - slot_h) * 3 / 5;
slot_offset = 4;
slot_r = slot_offset;
slot_y_fudge = 0.275;
slot_x_fudge = 1;

shield_r = 7;
shield_x = 4;
shield_y = -3;

barrel_slot_w = 3;
// distance from top of slot to top of shield
barrel_slot_offest = 0.75;
barrel_slot_depth = 2;

module face() {
	difference() {
		translate([0,face_r - face_depth,0]) {cylinder(r = face_r, h = face_h);}
		translate([-face_r,0,0])  {cube(face_r * 2, face_r + 1, face_h + 1);}
		slot();
	}
}

module slot() {
	translate([-slot_offset,-face_r,slot_below]) {cube([face_r*2, face_r*2, slot_h]);}
}

module slotcurve() {
	translate([-slot_offset+slot_x_fudge,-(face_depth-slot_r)+slot_y_fudge,slot_below]) {
		cylinder(r = slot_r, h = slot_h);
		}
}

module shield() {
	translate([shield_x,shield_y,slot_below]) {
		rotate([0,0,90]) {
			difference() {
				cylinder(r = shield_r, h = slot_h);
				barrelslot();
			}
		}
	}
}	

module barrelslot() {
	translate([0,- shield_r,barrel_slot_w /2 + barrel_slot_offest]) {
		hull() {
			rotate([-90,0,0]) { cylinder(r = barrel_slot_w /2, h = barrel_slot_depth); }
			translate([0,0,slot_h - 2*barrel_slot_offest - barrel_slot_w ]) {rotate([-90,0,0]) { cylinder(r = barrel_slot_w /2, h = barrel_slot_depth); }}
		}
	}
}

module measure() {
	translate([-20,0,0]) {
		cube([40,6,6]);
	}
}

module barbette() {
	union() {
		face();
		slotcurve();
		shield();
		measure();
	}
}

barbette();
//barrelslot();