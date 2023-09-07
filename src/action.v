module game

import math

struct ActionFields {
mut:
	performer &Actor
}

pub interface Action  {
mut:
	init()
	perform()
	is_completed() bool
}

// #################################################################################################################################################################
struct Walk_Action {
	ActionFields
	dir        Direction
mut:
	mov_change f32
}

fn (mut a Walk_Action)init() {

	a.mov_change = 16

}

fn (mut a Walk_Action)perform() {
	a.performer.dir = a.dir
	match a.performer.dir {
		.right {
			a.performer.pos.x += 1
			a.mov_change -= 1
		}
		.left {
			a.performer.pos.x -= 1
			a.mov_change -= 1		
		}
		.up {
			a.performer.pos.y -= 1
			a.mov_change -= 1		
		}
		.down {
			a.performer.pos.y += 1
			a.mov_change -= 1		
		}		

	}
	
}

fn (mut a Walk_Action)is_completed() bool {
	if a.mov_change <= 0 {
		//TODO: round to closes multiple of 16
		a.performer.pos.x = f32(math.round(f64(a.performer.pos.x) / 16) * 16)
		a.performer.pos.y = f32(math.round(f64(a.performer.pos.y) / 16) * 16)
	}
	return a.mov_change <= 0
}