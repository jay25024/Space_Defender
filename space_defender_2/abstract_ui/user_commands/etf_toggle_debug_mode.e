note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_TOGGLE_DEBUG_MODE
inherit
	ETF_TOGGLE_DEBUG_MODE_INTERFACE
create
	make
feature -- command
	toggle_debug_mode
    	do
			-- perform some update on the model state
            model.mark_first_toggel_call
			model.toogle_flag_changer
			
			etf_cmd_container.on_change.notify ([Current])
    	end

end
