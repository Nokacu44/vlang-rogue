module game

import gg
import gx

import os
import sokol.sapp
import math

pub struct Game {
pub mut:
	ctx gg.Context
	width int
	height int
	scale int

	actor_manager Actor_Manager
mut:
	player &Actor
	selected_tile Position

	cursor_normal gg.Image
	cursor_combat gg.Image

	mode PlayerMode
}

pub fn new_game(frame_fn fn (voidptr)) &Game {
	mut g := Game {
		scale: 2
		player: &Actor{
			pos: Position{x: 32, y:32}
		}
		mode: .normal
	}

	g.ctx = gg.new_context(
		bg_color: gx.rgb(0, 0, 0)
		width: 640 * 2
		height: 480 * 2
		window_title: 'Polygons'
		frame_fn: frame_fn
		keydown_fn: keydown
		user_data: &g
		resizable: false
		event_fn: on_event
		init_fn: init
    )

	g.width = g.ctx.width
	g.height = g.ctx.height

	if cursor_normal := g.ctx.create_image(os.resource_abs_path('assets/cursor_default.png')) {
		g.cursor_normal = cursor_normal
	} else {
		panic(err)
	}
	if cursor_combat := g.ctx.create_image(os.resource_abs_path('assets/cursor_combat.png')) {
		g.cursor_combat = cursor_combat
	} else {
		panic(err)
	}
	g.actor_manager.new_actor(Actor_Stereotype.dog, "dogmeat", 48, 48)
	g.actor_manager.new_actor(Actor_Stereotype.human_male, "jhon", 128, 256)
	g.player = g.actor_manager.new_actor(Actor_Stereotype.human_male, "player", 0, 0)

	return &g	
}

fn init(mut g Game) {
	sapp.show_mouse(false)
}

pub fn (mut g Game)run() {
	g.ctx.run()
}

pub fn (mut g Game)update() {
	g.player.update()

}

pub fn (mut g Game)draw() {
	g.ctx.begin()
		for y := 0; y < g.height / (16 * g.scale); y++ {
			for x := 0; x < g.width / (16 * g.scale); x++ {
				g.ctx.draw_rect_filled(x * g.scale * 16, y * g.scale * 16, 16 * g.scale - 1, 16 * g.scale - 1, gx.rgb(20, 20, 20))
			}
		}
		g.draw_actors()

	g.ctx.draw_image(g.ctx.mouse_pos_x - 24, g.ctx.mouse_pos_y - 24, 16 * 3, 16 * 3, g.current_cursor())
	g.ctx.end()
}

fn keydown(key gg.KeyCode, m gg.Modifier, mut g &Game) {
	if key == gg.KeyCode.d || key == gg.KeyCode.right {
		g.player.action_manager.add_action(mut Walk_Action{
			ActionFields: ActionFields{
				performer: g.player
			}
			dir: Direction.right
		})
	}
	
	if key == gg.KeyCode.a || key == gg.KeyCode.left {
		g.player.action_manager.add_action(mut Walk_Action{
			ActionFields: ActionFields{
				performer: g.player
			}
			dir: Direction.left
		})
	}
	
	if key == gg.KeyCode.w || key == gg.KeyCode.up {
		g.player.action_manager.add_action(mut Walk_Action{
			ActionFields: ActionFields{
				performer: g.player
			}
			dir: Direction.up
		})
	}

	if key == gg.KeyCode.s || key == gg.KeyCode.down {
		g.player.action_manager.add_action(mut Walk_Action{
			ActionFields: ActionFields{
				performer: g.player
			}
			dir: Direction.down
		})
	}
}

fn on_event(e &gg.Event, mut g Game) {
	if e.mouse_button == .right && e.typ == .mouse_down {
		g.mode = match g.mode {
			.combat {.normal}
			.normal {.combat}
		}
		println("sex")
	}
}


fn (mut g Game)draw_actors() {
	for actor in g.actor_manager.actors {
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
		g.ctx.draw_rect_filled(actor.pos.x * g.scale , actor.pos.y * g.scale, 16 * g.scale, 16 * g.scale, color)
		
		ax := actor.pos.x / 16
		ay := actor.pos.y / 16

		if (g.ctx.mouse_pos_x / (16 * g.scale)) == ax && (g.ctx.mouse_pos_y / (16 * g.scale)) == ay {
			conf := gx.TextCfg{
				color: gx.yellow
				size: 20
				align: .center
				vertical_align: .middle
				bold: true
				italic: true
				mono: true
			}
			g.ctx.draw_text(int(actor.pos.x * g.scale) + 16, int(actor.pos.y * g.scale) - 8, "$actor.name", conf)
		}
	}

}

fn(mut g Game)current_cursor() &gg.Image{
	return &match g.mode {
		.combat {
			g.cursor_combat
		}
		.normal {
			g.cursor_normal
		}
	}
}