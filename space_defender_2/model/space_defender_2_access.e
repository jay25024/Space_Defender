note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	SPACE_DEFENDER_2_ACCESS

feature
	m: SPACE_DEFENDER_2
		once
			create Result.make
		end

invariant
	m = m
end




