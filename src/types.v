module game


pub struct Position {
pub mut:
	x f32
	y f32
}

enum Direction {
	up
	down
	right
	left
}

enum Actor_Stereotype {
	mutant
	human_male
	human_female
	dog
}

enum PlayerMode {
	normal
	combat
}

pub struct Rectangle {
	x f32
	y f32
	width f32 
	height f32
}