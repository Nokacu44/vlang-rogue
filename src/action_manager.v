module game

struct Action_Manager {
mut:
	action_queue []Action
}

fn (mut m Action_Manager)update() {
	if m.action_queue.len > 0 {
		mut action := m.action_queue.first()
		action.perform()
		if action.is_completed() {
			_ := m.action_queue.pop()
		}
	}
}

fn (mut m Action_Manager)add_action(mut a Action) {
	m.action_queue << a
	a.init()
}

fn (mut m Action_Manager)clear_actions() {

}