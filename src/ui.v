module game
import gx

struct UI {
mut:
	game &Game

	crt_screen Rectangle
	bottom_rect Rectangle

	messages []string

	opt gx.TextCfg = gx.TextCfg {
		color: gx.white
		size: 18
		align: .left
		vertical_align: .middle
		max_width: 1
		bold: true
		mono: true           
	}
}




fn (mut ui UI)draw() {
	// Draw Bottom UI Rect
	ui.game.ctx.draw_rect_filled(ui.bottom_rect.x * ui.game.scale, ui.bottom_rect.y * ui.game.scale, ui.bottom_rect.width * ui.game.scale, ui.bottom_rect.height * ui.game.scale, gx.rgb(76, 70	, 50))

	// Draw Monitor
	ui.game.ctx.draw_rect_filled(ui.crt_screen.x * ui.game.scale, ui.crt_screen.y * ui.game.scale, ui.crt_screen.width * ui.game.scale, ui.crt_screen.height * ui.game.scale, gx.rgb(20,100,20))

	// Draw messages
	mut mx := 0
	for msg in ui.messages {
		ui.game.ctx.draw_text((int(ui.crt_screen.x) + 4) * ui.game.scale,( int(ui.crt_screen.y) + 6  + mx) * ui.game.scale, msg, ui.opt)
		mx += 8
	}	

}


fn (mut ui UI)push_message(msg string) {
	ui.messages << "~ $msg"
}