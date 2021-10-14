note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE
inherit
	ETF_MOVE_INTERFACE
create
	make
feature -- command
	move(row: INTEGER_32 ; column: INTEGER_32)
		require else
			move_precond(row, column)
    	local
			Z:INTEGER_32
    	do
			-- perform some update on the model state
       	    if row = A then Z:=1
			elseif row = B then Z:=2
			elseif row = C then Z:=3
			elseif row = D then Z:=4
			elseif row = E then Z:=5
			elseif row = F then Z:=6
			elseif row = G then Z:=7
			elseif row = H then Z:=8
			elseif row = I then Z:=9
			else   Z:=10

			end
			model.default_update
			model.move(Z,column)
		--	across model.enemy is m loop if m.type ~1 then m.passes if m.can_see_starfighter= true then m.action_when_starfighetr_is_seen else m.action_when_starfighter_not_seen end end end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
