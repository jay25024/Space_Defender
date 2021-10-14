note
	description: "Summary description for {ENEMIES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENEMIES

feature -- Attributes
    signature:STRING
    name:STRING
    type:INTEGER
    health_n:INTEGER
    health_d:INTEGER
    regen:INTEGER
    armour:INTEGER
    vision:INTEGER
    position:TUPLE[row:INTEGER;column:INTEGER]
    id:INTEGER

    seen_by_starfighter:BOOLEAN
    can_see_starfighter:BOOLEAN
    seen_by_starfighter_presentation: STRING
    can_see_starfighter_presentation:STRING

    action_flag:INTEGER
    just_spawned:BOOLEAN


    alive:BOOLEAN

feature -- Actions
   spawn_flag_true deferred end
   spawn_flag_false deferred end
   fires deferred end
   false_true_presenter deferred end
   position_setter(r:INTEGER;c:INTEGER) deferred end
--   passes deferred end
--   specials deferred end
   action_when_starfighter_not_seen deferred end
   action_when_starfighetr_is_seen deferred end
   advance deferred end
   action_flag_reset deferred end
   change_vision deferred end
   alive_flag_mutator(l:BOOLEAN) deferred end
   health_mutator(l:INTEGER)deferred end
   assign_id(u:INTEGER)deferred end
   preemptive_action deferred end

invariant
	invariant_clause: True -- Your invariant here

end
