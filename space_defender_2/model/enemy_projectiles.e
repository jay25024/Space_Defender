note
	description: "Summary description for {ENEMY_PROJECTILES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENEMY_PROJECTILES
feature--attributes
    move:INTEGER
    damage:INTEGER
    id: INTEGER
    position:TUPLE[row:INTEGER;column:INTEGER]
    status:BOOLEAN
    model:SPACE_DEFENDER_2
    model_access:SPACE_DEFENDER_2_ACCESS
feature -- methods
    change_position(row:INTEGER;column:INTEGER) deferred end
    set_id (k:INTEGER) deferred end
    status_mutator(l:BOOLEAN)deferred end
    damage_mutator(l:INTEGER)deferred end
    advance deferred end

end
