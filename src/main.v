module main

import game

fn main() {
	mut g := game.new_game(frame)
	g.run()	
}

fn frame(mut g game.Game) {
	g.update()
	g.draw()
}