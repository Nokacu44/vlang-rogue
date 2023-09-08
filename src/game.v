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


	ui UI
mut:
	level Level
	player &Actor
	selected_tile Position

	camera Position
	cursor_normal gg.Image
	cursor_combat gg.Image

	focused_actor &Actor

	mode PlayerMode
}

pub fn new_game(frame_fn fn (voidptr)) &Game {
	mut g := Game {
		scale: 2
		player: &Actor{
			pos: Position{x: 32, y:32}
		}
		mode: .normal
		ui: UI {
			crt_screen: Rectangle {
				x: 10
				y: 25 * 16 - 5
				width: 15 * 16
				height: 4 * 16 + 10
			}

			bottom_rect: Rectangle {
				x: 0
				y: 384
				width: 640
				height: 96
			}
		}
	}
	g.ui.game = &g
	g.level.game = &g
	g.level.width = 100
	g.level.height = 100
	g.focused_actor = g.player
	g.ctx = gg.new_context(
		bg_color: gx.rgb(0, 0, 0)
		width: 640 * 2
		height: 480 * 2
		window_title: 'Polygons'
		frame_fn: frame_fn
		keydown_fn: keydown
		user_data: &g
		resized_fn: on_resize
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
	g.level.actor_manager.new_actor(Actor_Stereotype.dog, "dogmeat", 48, 48)
	g.level.actor_manager.new_actor(Actor_Stereotype.human_male, "jhon", 128, 256)
	g.player = g.level.actor_manager.new_actor(Actor_Stereotype.human_male, "player", 0, 0)


	g.ui.push_message("Hello Rogue!")
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

		g.level.draw()			
		// UI
		g.ui.draw()

		// Draw cursor
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

		if g.player.pos.x / 16 - g.camera.x >= 640 / 16 - 1  {
			g.camera.x += 640 / 16
		}
	}
	
	if key == gg.KeyCode.a || key == gg.KeyCode.left {
		g.player.action_manager.add_action(mut Walk_Action{
			ActionFields: ActionFields{
				performer: g.player
			}
			dir: Direction.left
		})

		if g.player.pos.x / 16 - g.camera.x <= 0 {
			g.camera.x -= 640 / 16
		}
	}
	
	if key == gg.KeyCode.w || key == gg.KeyCode.up {
		g.player.action_manager.add_action(mut Walk_Action{
			ActionFields: ActionFields{
				performer: g.player
			}
			dir: Direction.up
		})
		if g.player.pos.y / 16 - g.camera.y <= 0 {
			g.camera.y -= 480 / 16 - 6
		}
	}

	if key == gg.KeyCode.s || key == gg.KeyCode.down {
		g.player.action_manager.add_action(mut Walk_Action{
			ActionFields: ActionFields{
				performer: g.player
			}
			dir: Direction.down
		})
		if g.player.pos.y / 16 - g.camera.y >= 480 / 16 - 6 - 1{
			g.camera.y += 480 / 16 - 6
		}
	}


}

fn on_event(e &gg.Event, mut g Game) {
	if e.mouse_button == .right && e.typ == .mouse_down {
		g.mode = match g.mode {
			.combat {.normal}
			.normal {.combat}
		}
	}
	if e.mouse_button == .left && e.typ == .mouse_down {
		println(g.level.actor_manager.actors["${g.ctx.mouse_pos_x / (16 * g.scale)},${g.ctx.mouse_pos_y / (16 * g.scale)}"])
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

fn on_resize(e &gg.Event, mut g Game) {
	g.width = e.window_width
	g.height = e.window_height
}
