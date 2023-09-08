module game 

import gx

struct Level {
pub mut:
	game &Game
mut:
	width int
	height int
	tiles [][]int
	actor_manager Actor_Manager
}


fn (mut l Level)draw() {
	for y := 0; y < l.height; y++ {
		for x := 0; x < l.width; x++ {
			draw_x, draw_y := ((x - l.game.camera.x)  * l.game.scale * 16), ((y - l.game.camera.y) * l.game.scale * 16)
			if draw_x < 0 || draw_y < 0 || draw_x > l.game.width || draw_y > l.game.height - (8 * 16) {
				continue
			}
			l.game.ctx.draw_rect_filled(draw_x, draw_y, 16 * l.game.scale - 1, 16 * l.game.scale - 1, gx.rgb(20, 20, 20))
		}
	}
	
	l.draw_actors()
}

fn (mut l Level)draw_actors() {
	for _, actor in l.actor_manager.actors {
		color := match actor.stereotype{
			.human_male {
				gx.rgb(204, 166, 175)
			}
			.dog {
				gx.rgb(80, 80, 80)
			}
			else {
				gx.rgb(0, 0, 0)
			}
		}
		// draw actor shape
		l.game.ctx.draw_rect_filled((actor.pos.x / (16) - l.game.camera.x) * l.game.scale * 16 , (actor.pos.y / (16) - l.game.camera.y) * l.game.scale * 16, 16 * l.game.scale, 16 * l.game.scale, color)
		
		ax := actor.pos.x / 16
		ay := actor.pos.y / 16
		if (l.game.ctx.mouse_pos_x / (16 * l.game.scale)) == ax && (l.game.ctx.mouse_pos_y / (16 * l.game.scale)) == ay {
			conf := gx.TextCfg{
				color: gx.yellow
				size: 20
				align: .center
				vertical_align: .middle
				bold: true
				italic: true
				mono: true
			}
			l.game.ctx.draw_text(int(actor.pos.x * l.game.scale) + 16, int(actor.pos.y * l.game.scale) - 8, "$actor.name", conf)
		}


	}

}