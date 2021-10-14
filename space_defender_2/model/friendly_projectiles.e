note
	description: "Summary description for {FRIENDLY_PROJECTILES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FRIENDLY_PROJECTILES

feature--attributes
    model:SPACE_DEFENDER_2
    model_access:SPACE_DEFENDER_2_ACCESS

    move:INTEGER
    damage0:INTEGER
    damage1:INTEGER
    damage2:INTEGER
    id0: INTEGER
    id1:INTEGER
    id2:INTEGER
    position0:TUPLE[row:INTEGER;column:INTEGER]
    position1:TUPLE[row:INTEGER;column:INTEGER]
    position2:TUPLE[row:INTEGER;column:INTEGER]
    cost:INTEGER
    status0:BOOLEAN
    status1:BOOLEAN
    status2:BOOLEAN

feature -- methods
    change_position(row:INTEGER;column:INTEGER) deferred end
    set_id (k:INTEGER) deferred end
    update_status0(j:BOOLEAN) deferred end
    update_status1(j:BOOLEAN) deferred end
    update_status2(j:BOOLEAN) deferred end
    advance deferred end
    update_damage0(l:INTEGER) deferred end
    update_damage1(l:INTEGER) deferred end
    update_damage2(l:INTEGER) deferred end

end
