module game


pub struct Actor {
pub:
	stereotype Actor_Stereotype
	name string
mut:

	pos Position
	dir Direction
	action_manager Action_Manager
}

fn (mut a Actor)update() {
	a.action_manager.update()
}