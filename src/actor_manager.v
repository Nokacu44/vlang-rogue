module game 

struct Actor_Manager {
mut:
	actors []&Actor
}



fn (mut m Actor_Manager)new_actor(s Actor_Stereotype, name string , x int, y int) &Actor{
	mut actor := match s {
		.human_male {
			 &Actor{
				stereotype: s
				name: name,
			}		
		}
		.human_female {
			 &Actor{
				stereotype: s
				name: name,
			}		
		}
		.mutant {
			 &Actor{
				stereotype: s
				name: name,
			}		
		}
		.dog {
			 &Actor{
				stereotype: s
				name: name,
			}		
		}
	}
	actor.pos.x = x
	actor.pos.y = y
	m.actors << actor

	return actor
}