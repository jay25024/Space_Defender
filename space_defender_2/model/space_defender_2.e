note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	SPACE_DEFENDER_2

inherit
	ANY
		redefine
			out
		end

create {SPACE_DEFENDER_2_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			create setup.make
			create play_board.make_filled ("_",1,1)
			create play_ans.make_empty
			create starfighter_values.make_empty
            create move_ans.make_empty
            create feedback.make_empty
            create pass_ans.make_empty
            create friendly_projectiles.make_empty
            create fire_ans.make_empty
            create enemy.make_empty
            create special_ans.make_empty
            create toggle_ans.make_empty

            create rocket_advance.make_empty
            create enemy_projectile.make_empty
            create friendly_projectile.make_empty
			array_row:=<<"A","B","C","D","E","F","G","H","I","J">>
			i := -1
			initial_pos:=[0,0]
			fighter_pos:=[0,0]
			total_projectiles:=-1

			spawn_location:=[0,0]



			 create   enemy_toggle_string.make_empty
			 create   projectile_toggle_string.make_empty
			 create   friendly_proj_toggle_string.make_empty
			 create   enemy_proj_toggle_string.make_empty
			 create   starfighter_action_string.make_empty
			 create   enemy_action_string.make_empty
			 create   natural_enemy_spawn_string.make_empty

		end

feature -- model attributes
	s : STRING
	i : INTEGER
	setup: SETUP
	fighter_pos: TUPLE[r:INTEGER;c:INTEGER]
    feedback:STRING
    global_play_count: INTEGER
    rocket_advance:ARRAY[INTEGER]

-- play attributes
    board_row: INTEGER
    board_column: INTEGER

    play_board: ARRAY2[STRING]
    array_row: ARRAY[STRING]
    play_ans:STRING
    starfighter_values:STRING
    position:INTEGER

    rng: RANDOM_GENERATOR_ACCESS
-- move attributes
    move_ans:STRING
    initial_pos:TUPLE[row:INTEGER;column:INTEGER]
-- pass attributes
    pass_ans:STRING
-- fire attributes
    friendly_projectiles: ARRAY[TUPLE[key:INTEGER;value:TUPLE[r:INTEGER;c:INTEGER;t:INTEGER;in_board: BOOLEAN]]]
    friendly_projectile: ARRAY[FRIENDLY_PROJECTILES]
    total_projectiles: INTEGER
    fire_ans:STRING
--enemy_attributes

    model_g_threshold:INTEGER
    model_i_threshold:INTEGER
    model_f_threshold:INTEGER
    model_c_threshold:INTEGER
    model_p_threshold:INTEGER
    enemy:ARRAY[ENEMIES]
    enemy_projectile: ARRAY[ENEMY_PROJECTILES]
-- special attributes
   spawn_location:TUPLE[row:INTEGER;column:INTEGER]
   special_ans:STRING

-- toggle_attributes
    toggle_ans:STRING
    first_toggle_call:INTEGER

    enemy_toggle_string:STRING
    projectile_toggle_string:STRING
    friendly_proj_toggle_string:STRING
    enemy_proj_toggle_string:STRING
    starfighter_action_string:STRING
    enemy_action_string:STRING
    natural_enemy_spawn_string:STRING

feature -- flags
   play_flag:INTEGER
   move_flag:INTEGER
   fire_flag:INTEGER
   pass_flag:INTEGER
   abort_flag:INTEGER
   special_flag:INTEGER
   toggle_flag:INTEGER

   grunt_spawn_flag:INTEGER


feature -- model operations

    mark_first_toggel_call
        do
        	first_toggle_call:=1
        end
    first_toggle_call_reset
        do
           first_toggle_call:=0
        end
    total_projectile_mutator
        do
          total_projectiles:= total_projectiles-1
        end
    toogle_flag_changer
        do
        	if toggle_flag~1 then
        	   toggle_flag:=0
        	   else
        	   	  toggle_flag:=1
        	end
        end
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

    setup_increment(l:INTEGER)
        do
        	setup.setup_count_increment(l)
        end
    setup_decrement(k:INTEGER)
        do
        	if setup.setup_count -k < 1 then
        		play_flag := 0
        	end
        	setup.setup_count_decrement(k)
        end
    setup_selection(k:INTEGER)
        do
        	setup.setup_selection_setter(k)
        end

    print_board(z:STRING)
       local
			   t:INTEGER
               q:INTEGER
               u:INTEGER
            do
                across play_board is p loop t:=t+1 q:=q+1
                 if	(t/~board_column+1 and q>=10 and q<=board_column+1) then
                     	z.append(p+" ")
                 else
                 if (t~board_column+1) then
                 z.append(p)
                 if  not (u~board_row) then
                 z.append("%N")
                 end
                 t:=0
                 u:=u+1
                 else if(t~1)  then
                      z.append(p+" ")
                      else
               	      z.append(p+"  ")
                      end
                 end
                 end
             end
            end
    print_friendly_projectiles
         do
         	across friendly_projectile is  f loop if f.status0= true then play_board.put ("*", f.position0.row+1, f.position0.column+1) end if f.status1= true then play_board.put ("*", f.position1.row+1, f.position1.column+1)end if f.status2= true then play_board.put ("*", f.position2.row+1, f.position2.column+1) end end
         end



    -- setup.starfighter_status
    set_board(z:ARRAY2[STRING])
           do
              z.put ("   ",1,1)
              z.put ("S", fighter_pos.r+1, fighter_pos.c+1)
           	  across  2 |..| (board_column+1) is c loop z.put ((c-1).out, 1, c)  end
            across 1 |..| (board_column+1) is c
             loop
             	across 1 |..| (board_row+1) is r loop if (c~1 and r/~1) then z.put ("    "+array_row[r-1], r,c) end  end
             end
           end
    set_fog(z:ARRAY2[STRING])
          do
          	across 2 |..| (board_row+1) is r  loop  across 2 |..| (board_column+1) is c loop if c >= (fighter_pos.c+2+setup.vision)- (r-(fighter_pos.r+1)).abs  then  z.put ("?", r,c) end end  end
          end
    play(row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
	  -- Initiates spacefighter and grid
         do
         	global_play_count:=1
	     	play_flag:=1
	     	board_row:=row
	     	board_column:=column
	     	model_g_threshold:=g_threshold
	     	model_i_threshold:=i_threshold
	     	model_f_threshold:=f_threshold
	     	model_c_threshold:=c_threshold
	     	model_p_threshold:=p_threshold
            -- set fighter position coordinates
			if (row \\ 2)~1 then position  :=((row//2) +1)
    	    else position:=row//2 end
	        fighter_pos:=[position,1]
	        spawn_location:= [position,1]
            create play_board.make_filled ("_", board_row+1,board_column+1)
            update_setup_values
         end
    fill_enemy_toggle_string
    do
    	create enemy_toggle_string.make_empty
    	across enemy is e loop
    		if e.alive = true then
    		   enemy_toggle_string.append ("    ["+e.id.out+","+e.signature.out+"]->health:"+e.health_n.out+"/"+e.health_d.out+","+" Regen:"+e.regen.out+", Armour:"+e.armour.out+", Vision:"+e.vision.out+", seen_by_Starfighter:"+e.seen_by_starfighter_presentation.out+", can_see_Starfighter:"+e.can_see_starfighter_presentation.out+", location:"+"["+array_row[e.position.row].out+","+e.position.column.out+"]%N")
    		end
         end
    end
    fill_enemy_proj_toggle_string(w:STRING)
    do
      enemy_proj_toggle_string.append (w)
    end
    fill_enemy_action_string(w:STRING)
    do
      enemy_action_string.append (w)
    end
    fill_projectile_toggle_string
    local
    	y:INTEGER
    do
        create projectile_toggle_string.make_empty
    	across 1 |..| (total_projectiles).abs is t loop

    	across friendly_projectile is f loop if f.id0 = (-t) and f.status0 = true then projectile_toggle_string.append (" ["+f.id0.out+",*]->damage:"+f.damage0.out+", move:"+f.move.out+", location:["+array_row[f.position0.row]+","+f.position0.column.out+"]%N") end if f.id1 = (-t) and f.status1 = true then projectile_toggle_string.append (" ["+f.id1.out+",*]->damage:"+f.damage1.out+", move:"+f.move.out+", location:["+array_row[f.position1.row]+","+f.position1.column.out+"]%N") end if f.id2 = (-t) and f.status2 = true  then projectile_toggle_string.append (" ["+f.id2.out+",*]->damage:"+f.damage2.out+", move:"+f.move.out+", location:["+array_row[f.position2.row]+","+f.position2.column.out+"]%N") end end
        across enemy_projectile is e loop  if e.id = (-t) and e.status = true then projectile_toggle_string.append (" ["+e.id.out+",<]->damage:"+e.damage.out+", move:"+e.move.out+", location:["+array_row[e.position.row]+","+e.position.column.out+"]%N")    end end

        end
    end
    enemy_spawn_collision
       do
       	   across friendly_projectile is f loop
		       	if enemy[enemy.count].position.row ~ f.position0.row and enemy[enemy.count].position.column ~ f.position0.column and f.status0=true then
	                 f.update_status0(false)
	                 enemy[enemy.count].health_mutator(enemy[enemy.count].health_n-f.damage0)
	                 if enemy[enemy.count].health_n <=0 then
	                 	enemy[enemy.count].alive_flag_mutator (false)
	                 end
	                 print(enemy[enemy.count].health_n.out+"latest check%N")
		        end
		       	if enemy[enemy.count].position.row ~ f.position1.row and enemy[enemy.count].position.column ~ f.position1.column and f.status1=true then
	                 f.update_status1(false)
	                 enemy[enemy.count].health_mutator(enemy[enemy.count].health_n-f.damage1)
	                 if enemy[enemy.count].health_n <=0 then
	                 	enemy[enemy.count].alive_flag_mutator (false)
	                 end
	                 print(enemy[enemy.count].health_n.out+"latest check%N")
		        end
		       	if enemy[enemy.count].position.row ~ f.position2.row and enemy[enemy.count].position.column ~ f.position2.column and f.status2=true then
	                 f.update_status2(false)
	                 enemy[enemy.count].health_mutator(enemy[enemy.count].health_n-f.damage2)
	                 if enemy[enemy.count].health_n <=0 then
	                 	enemy[enemy.count].alive_flag_mutator (false)
	                 end
	                 print(enemy[enemy.count].health_n.out+"latest check%N")
		        end
	       end
	       across enemy_projectile is e loop
	                            if e.position.row~enemy[enemy.count].position.row and e.position.column ~ enemy[enemy.count].position.column and  e.status = true   then
                                   e.status_mutator(false)
                                   if enemy[enemy.count].health_n+ e.damage > enemy[enemy.count].health_d then
                                      enemy[enemy.count].health_mutator (enemy[enemy.count].health_d)
                                   else enemy[enemy.count].health_mutator (enemy[enemy.count].health_n + e.damage)
                                   end
	                            end
	       end
	       if enemy[enemy.count].position.row ~fighter_pos.r and enemy[enemy.count].position.column ~ fighter_pos.c then
                 enemy[enemy.count].alive_flag_mutator (false)
                 setup.health_mutator ( -enemy[enemy.count].health_n )
                 print(setup.health_n.out+"beforeUUUU%N")
                 if setup.health_n <=0 then
                 	print("yes exe%N")
                 	setup.health_mutator (-setup.health_n)
                 	play_board.put ("X", fighter_pos.r+1, fighter_pos.c+1)
                 end
                 print(setup.health_n.out+"UUUU%N")
	       end

       end
    rng_gen(row: INTEGER_32 ; column: INTEGER_32; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
       local
         		enemy_row:INTEGER
         		which_enemy:INTEGER
         do
         	enemy_row:=rng.rchoose (1, row)


            which_enemy:=rng.rchoose (1, 100)

           if which_enemy < g_threshold and which_enemy >=1 then enemy.force (create {GRUNT}.make,enemy.count+1)     enemy[enemy.count].position_setter(enemy_row,column)  enemy[enemy.count].alive_flag_mutator(true)  enemy_spawn_collision   enemy[enemy.count].assign_id (enemy.count)   grunt_spawn_flag:=1 end
            if which_enemy < f_threshold and which_enemy >=g_threshold then  enemy.force (create {FIGHTER}.make,enemy.count+1)     enemy[enemy.count].position_setter(enemy_row,column) enemy[enemy.count].alive_flag_mutator(true)  enemy_spawn_collision   enemy[enemy.count].assign_id (enemy.count)end
            if which_enemy < c_threshold and which_enemy >=f_threshold then  enemy.force (create {CARRIER}.make,enemy.count+1)     enemy[enemy.count].position_setter(enemy_row,column) enemy[enemy.count].alive_flag_mutator(true)  enemy_spawn_collision   enemy[enemy.count].assign_id (enemy.count) end
           if which_enemy < i_threshold and which_enemy >=c_threshold then  enemy.force (create {INTERCEPTOR}.make,enemy.count+1)     enemy[enemy.count].position_setter(enemy_row,column) enemy[enemy.count].alive_flag_mutator(true)  enemy_spawn_collision   enemy[enemy.count].assign_id (enemy.count) end
            if which_enemy < p_threshold and which_enemy >=i_threshold then  enemy.force (create {PYLON}.make,enemy.count+1)     enemy[enemy.count].position_setter(enemy_row,column) enemy[enemy.count].alive_flag_mutator(true)  enemy_spawn_collision   enemy[enemy.count].assign_id (enemy.count) end
         end


     move(row:INTEGER_32; column:INTEGER_32)
       local
       	 distance:INTEGER
        do
        	distance:=((fighter_pos.r - row).abs + (fighter_pos.c - column).abs)

        	regen
           	setup.energy_mutator (-setup.move_c*distance)

        	create play_board.make_filled ("_", board_row+1,board_column+1)
        	initial_pos:= fighter_pos


        	fighter_pos:=[row,column]

        	set_board(play_board)
         	--rng_gen(board_row,board_column,model_g_threshold,model_f_threshold,model_c_threshold,model_i_threshold,model_p_threshold)

        	if toggle_flag ~ 1 then

            else
           -- set_fog(play_board)
            end
        	print_enemies
        	create move_ans.make_empty
        	print_board(move_ans)
        	move_flag:=1
       end

    regen
       do
--       	   if setup.health_n +setup.regen_n > setup.health_d then setup.health_mutator (setup.health_d-setup.health_n)
--       	   else setup.health_mutator (setup.regen_n)
--       	   end
--       	   if setup.energy_n +setup.regen_d > setup.energy_d then setup.energy_mutator (setup.energy_d-setup.energy_n)
--       	   else setup.energy_mutator (setup.regen_d)
--       	   end
       end
    print_enemies
       do
       	across enemy is e loop
       	    if e.type ~ 1 then
       	        if e.position.column>=2 and e.alive = true then play_board.put ("G", e.position.row+1,e.position.column+1)end  end
       	    if e.type ~ 2 then
       	        if e.position.column>=2 and e.alive = true then play_board.put ("F", e.position.row+1,e.position.column+1)end  end
       	    if e.type ~ 3 then
       	        if e.position.column>=2 and e.alive = true then  play_board.put ("C", e.position.row+1,e.position.column+1)end  end
       	    if e.type ~ 4 then
       	        if e.position.column>=2 and e.alive = true then play_board.put ("I", e.position.row+1,e.position.column+1)end  end
       	    if e.type ~ 5 then
       	        if e.position.column>=2 and e.alive = true then play_board.put ("P", e.position.row+1,e.position.column+1)end  end

        end
       end





    pass
      local
      	g:ENEMIES
       do
       	pass_flag:=1
       --	regen
       --	regen




       	create play_board.make_filled ("_", board_row+1,board_column+1)
        set_board(play_board)
        across friendly_projectile is f loop f.advance  end
        across enemy_projectile is l loop l.advance end

        create pass_ans.make_empty

        across friendly_projectile is t loop print(t.damage0.out+"^^^%N")  print(t.status0.out+"^^^%N")end
      -- 	print(t.status0.out+"^^^%N") print(t.status1.out+"^^^%N")  print(t.position0.row.out+"^^^%N") print(t.position1.row.out+"^^^%N")print(t.position0.column.out+"^^^%N") print(t.position1.column.out+"^^^%N")

        if toggle_flag ~ 1 then

        else
           -- set_fog(play_board)
        end
        across enemy is e loop if  e.alive = true  then e.preemptive_action end  end
        across enemy is e loop  if e.can_see_starfighter = true and e.alive =true and e.just_spawned = false then e.action_when_starfighetr_is_seen  elseif e.alive = true and e.just_spawned = false then e.action_when_starfighter_not_seen  end end
        across enemy is e loop e.spawn_flag_false end
        across enemy_projectile is e loop print(e.status.out+"   "+ e.id.out+"  "+e.position.column.out+"%N")  end

        print_enemy_projectiles


        print_friendly_projectiles
         rng_gen(board_row,board_column,model_g_threshold,model_f_threshold,model_c_threshold,model_i_threshold,model_p_threshold)

       	print_enemies
--       	 print("COUNT&&&"+enemy.count.out+"%N")
--         across enemy  is e loop print("STSTTTTT"+e.type.out+"%N")  end
        fill_enemy_toggle_string
        fill_projectile_toggle_string
        print_board(pass_ans)

              end

    special
       do
       	if setup.p_selection ~ 1 then
       		regen


            fighter_pos:=[spawn_location.row, spawn_location.column]
            create play_board.make_filled ("_", board_row+1,board_column+1)
            set_board(play_board)
            if toggle_flag ~ 1 then

            else
          --  set_fog(play_board)
            end
            print_enemies
           -- print_enemy_projectiles
            print_board(special_ans)
            setup.energy_mutator(-50)
            special_flag:=1
       	elseif setup.p_selection ~ 2 then

       		elseif setup.p_selection ~ 3 then

       			elseif setup.p_selection ~ 4 then

       				elseif setup.p_selection ~ 5 then

        end
       end
    collision_for_splitter : INTEGER
    do
    	result:= -1
    	across friendly_projectile is f loop
                                           if f.position0.row ~ fighter_pos.r and f.position0.column ~ fighter_pos.c+1 and f.status0 = true then
                                              f.update_status0(false)
                                              result:=f.damage0
                                           end
        end
    end

    print_enemy_projectiles
       do
          	across enemy_projectile is e  loop if e.status = true then  play_board.put ("<",e.position.row+1 ,e.position.column+1) end end
       end

    fire
    local
    	status:BOOLEAN
        k:INTEGER
        x:INTEGER
       do
        fire_flag:=1

       	create play_board.make_filled ("_", board_row+1,board_column+1)
        set_board(play_board)


        across friendly_projectile is f loop f.advance  end
        print(enemy_projectile.count.out+"%N")
        across enemy_projectile is l loop l.advance end

       	   if setup.w_selection ~ 1 then
       		friendly_projectile.force (create {STANDARD_PROJECTILE}.make, friendly_projectile.count+1)
            friendly_projectile[friendly_projectile.count].set_id (total_projectiles)
            friendly_projectile[friendly_projectile.count].change_position (fighter_pos.r, fighter_pos.c+1)

       	   if fighter_pos.c +1 <= board_column then

       	      friendly_projectile[friendly_projectile.count].update_status0 (true)
       	      print(friendly_projectile[friendly_projectile.count].status0.out+"%N")
           end
       	   total_projectiles:=total_projectiles-1
       	    across enemy is e loop
       	    	                 print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
                               if e.position.row ~ fighter_pos.r and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status0= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status0 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage0)
                               	  print("enemy_health "+e.health_n.out+"%N")
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                               -- print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
           end
       	    across enemy_projectile is e loop
       	    	                -- print("INSPECT "+e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.status.out+" "+friendly_projectile[friendly_projectile.count].status0.out+" "+e.id.out+" "+friendly_projectile[friendly_projectile.count].id0.out+"%N")

                               if e.position.row ~ fighter_pos.r and e.position.column ~  (fighter_pos.c +1)and  not( e.id = friendly_projectile[friendly_projectile.count].id0) and friendly_projectile[friendly_projectile.count].status0 = true and e.status= true  then
                               	 print("spawn collision with e_proj%N")
										        if e.damage> friendly_projectile[friendly_projectile.count].damage0 then
										           friendly_projectile[friendly_projectile.count].update_status0 (false)
										           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage0)
										        elseif friendly_projectile[friendly_projectile.count].damage0 > e.damage then
										             e.status_mutator(false)
										             friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[friendly_projectile.count].damage0-e.damage)
										        else  friendly_projectile[friendly_projectile.count].update_status0(false)  e.status_mutator(false)
										        end

                               end
                              --  print("new damage f_proj "+friendly_projectile[friendly_projectile.count].damage0.out+"%N")
           end

--           if friendly_projectile[friendly_projectile.count].status0= true then
--           	    play_board.put ("*",fighter_pos.r+1, fighter_pos.c+2)
--           end
       	end

        if setup.w_selection ~ 2 then
            friendly_projectile.force (create {SPREAD_PROJECTILE}.make, friendly_projectile.count+1)
            friendly_projectile[friendly_projectile.count].set_id (total_projectiles)
            friendly_projectile[friendly_projectile.count].change_position (fighter_pos.r, fighter_pos.c+1)

            from
       			x:=1
       		until
       			x > (friendly_projectile.count-1)
       		loop

           if friendly_projectile[x].position0.row -1 ~ fighter_pos.r and friendly_projectile[x].position0.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status0 (false) friendly_projectile[friendly_projectile.count].update_damage2 (friendly_projectile[x].damage0+friendly_projectile[friendly_projectile.count].damage2)end
           if friendly_projectile[x].position0.row +1 ~ fighter_pos.r and friendly_projectile[x].position0.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status0 (false) friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[x].damage0+friendly_projectile[friendly_projectile.count].damage0)end
           if friendly_projectile[x].position0.row    ~ fighter_pos.r and friendly_projectile[x].position0.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status0 (false) friendly_projectile[friendly_projectile.count].update_damage1 (friendly_projectile[x].damage0+friendly_projectile[friendly_projectile.count].damage1)end

           if friendly_projectile[x].position1.row -1 ~ fighter_pos.r and friendly_projectile[x].position1.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status1 (false) friendly_projectile[friendly_projectile.count].update_damage2 (friendly_projectile[x].damage1+friendly_projectile[friendly_projectile.count].damage2)end
           if friendly_projectile[x].position1.row +1 ~ fighter_pos.r and friendly_projectile[x].position1.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status1 (false) friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[x].damage1+friendly_projectile[friendly_projectile.count].damage0)end
           if friendly_projectile[x].position1.row    ~ fighter_pos.r and friendly_projectile[x].position1.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status1 (false) friendly_projectile[friendly_projectile.count].update_damage1 (friendly_projectile[x].damage1+friendly_projectile[friendly_projectile.count].damage1)end

           if friendly_projectile[x].position2.row -1 ~ fighter_pos.r and friendly_projectile[x].position2.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status2 (false) friendly_projectile[friendly_projectile.count].update_damage2 (friendly_projectile[x].damage2+friendly_projectile[friendly_projectile.count].damage2)end
           if friendly_projectile[x].position2.row +1 ~ fighter_pos.r and friendly_projectile[x].position2.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status2 (false) friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[x].damage2+friendly_projectile[friendly_projectile.count].damage0)end
           if friendly_projectile[x].position2.row    ~ fighter_pos.r and friendly_projectile[x].position2.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status2 (false) friendly_projectile[friendly_projectile.count].update_damage1 (friendly_projectile[x].damage2+friendly_projectile[friendly_projectile.count].damage1)end

               x:=x+1
             end



           if friendly_projectile[friendly_projectile.count].status0= true then
           	    play_board.put ("*",fighter_pos.r+1, fighter_pos.c+2)
           end
       	   if fighter_pos.c +1 <= board_column then friendly_projectile[friendly_projectile.count].update_status1 (true) end
           if fighter_pos.c +1 <= board_column and fighter_pos.r +1 <= board_row then  friendly_projectile[friendly_projectile.count].update_status2 (true) end
           if fighter_pos.c +1 <= board_column and fighter_pos.r -1 >= 1 then  friendly_projectile[friendly_projectile.count].update_status0 (true) end

       	    total_projectiles:=total_projectiles-3

                  	    across enemy is e loop
       	    	                 print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
                               if e.position.row ~ fighter_pos.r and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status1= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status1 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage1)
                               	  print("new enemy health s0"+e.health_n.out+"%N")
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                                print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")

                               if e.position.row ~ fighter_pos.r-1 and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status0= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status0 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage0)
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                                print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")

                               if e.position.row ~ fighter_pos.r+1 and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status2= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status2 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage2)
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                                print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")


                        end

			       	    across enemy_projectile is e loop
			       	    	                -- print("INSPECT "+e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.status.out+" "+friendly_projectile[friendly_projectile.count].status0.out+" "+e.id.out+" "+friendly_projectile[friendly_projectile.count].id0.out+"%N")

			                              if e.position.row ~ fighter_pos.r+1 and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status2= true and e.status = true and  not( e.id = friendly_projectile[friendly_projectile.count].id2)then			                               	 print("spawn collision with e_proj%N")
													         print("spawn collision with e_proj2%N")
													        if e.damage> friendly_projectile[friendly_projectile.count].damage2 then
													           friendly_projectile[friendly_projectile.count].update_status2 (false)
													           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage2)
													        elseif friendly_projectile[friendly_projectile.count].damage2 > e.damage then
													             e.status_mutator(false)
													             friendly_projectile[friendly_projectile.count].update_damage2 (friendly_projectile[friendly_projectile.count].damage2-e.damage)
													        else  friendly_projectile[friendly_projectile.count].update_status2(false)  e.status_mutator(false)
													        end

			                               end
			                              --  print("new damage f_proj "+friendly_projectile[friendly_projectile.count].damage0.out+"%N")
			                               if e.position.row ~ fighter_pos.r and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status1= true and e.status = true and  not( e.id = friendly_projectile[friendly_projectile.count].id1)then
														         print("spawn collision with e_proj1%N")
														        if e.damage> friendly_projectile[friendly_projectile.count].damage1 then
														           friendly_projectile[friendly_projectile.count].update_status1 (false)
														           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage1)
														        elseif friendly_projectile[friendly_projectile.count].damage1 > e.damage then
														             e.status_mutator(false)
														             friendly_projectile[friendly_projectile.count].update_damage1 (friendly_projectile[friendly_projectile.count].damage1-e.damage)
														        else  friendly_projectile[friendly_projectile.count].update_status1(false)  e.status_mutator(false)
														        end
			                               end
			                              if e.position.row ~ fighter_pos.r-1 and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status0= true and e.status = true and not( e.id = friendly_projectile[friendly_projectile.count].id0)then
			                               	 print("spawn collision with e_proj0%N")
													        if e.damage> friendly_projectile[friendly_projectile.count].damage0 then
													           friendly_projectile[friendly_projectile.count].update_status0 (false)
													           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage0)
													        elseif friendly_projectile[friendly_projectile.count].damage0 > e.damage then
													             e.status_mutator(false)
													             friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[friendly_projectile.count].damage0-e.damage)
													        else  friendly_projectile[friendly_projectile.count].update_status0(false)  e.status_mutator(false)
													        end

			                               end
			           end

--                        if friendly_projectile[friendly_projectile.count].status1= true then
--           	                    play_board.put ("*",fighter_pos.r+1, fighter_pos.c+2)
--                        end
--                        if friendly_projectile[friendly_projectile.count].status2= true then
--           	                    play_board.put ("*",fighter_pos.r+2, fighter_pos.c+2)
--                        end
--                        if friendly_projectile[friendly_projectile.count].status0= true then
--           	                    play_board.put ("*",fighter_pos.r, fighter_pos.c+2)
--                        end
       end


        if setup.w_selection ~ 3 then
        	friendly_projectile.force (create {SNIPE_PROJECTILE}.make, friendly_projectile.count+1)
            friendly_projectile[friendly_projectile.count].set_id (total_projectiles)
            friendly_projectile[friendly_projectile.count].change_position (fighter_pos.r, fighter_pos.c+1)
            from
            	x:=1
            until
            	x > (friendly_projectile.count-1)
            loop
            	if friendly_projectile[x].position0.row    ~ fighter_pos.r and friendly_projectile[x].position0.column ~ fighter_pos.c+1   then friendly_projectile[x].update_status0 (false) friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[x].damage0+friendly_projectile[friendly_projectile.count].damage0)end
                x:=x+1
            end
            if fighter_pos.c +1 <= board_column then  friendly_projectile[friendly_projectile.count].update_status0 (true) end
             total_projectiles:=total_projectiles-1
       	    across enemy is e loop
       	    	                 print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
                               if e.position.row ~ fighter_pos.r and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status0= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status0 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage0)
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                                print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
           end
       	    across enemy_projectile is e loop
       	    	                -- print("INSPECT "+e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.status.out+" "+friendly_projectile[friendly_projectile.count].status0.out+" "+e.id.out+" "+friendly_projectile[friendly_projectile.count].id0.out+"%N")

                               if e.position.row ~ fighter_pos.r and e.position.column ~  (fighter_pos.c +1)and  not( e.id = friendly_projectile[friendly_projectile.count].id0) and friendly_projectile[friendly_projectile.count].status0 = true and e.status= true  then
                               	 print("spawn collision with e_proj%N")
										        if e.damage> friendly_projectile[friendly_projectile.count].damage0 then
										           friendly_projectile[friendly_projectile.count].update_status0 (false)
										           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage0)
										        elseif friendly_projectile[friendly_projectile.count].damage0 > e.damage then
										             e.status_mutator(false)
										             friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[friendly_projectile.count].damage0-e.damage)
										        else  friendly_projectile[friendly_projectile.count].update_status0(false)  e.status_mutator(false)
										        end

                               end
                              --  print("new damage f_proj "+friendly_projectile[friendly_projectile.count].damage0.out+"%N")
           end
--           if friendly_projectile[friendly_projectile.count].status0= true then
--           	    play_board.put ("*",fighter_pos.r+1, fighter_pos.c+2)
--           end
       	end
       	if setup.w_selection ~ 4 then


       	    friendly_projectile.force (create {ROCKET_PROJECTILE}.make, friendly_projectile.count+1)
            friendly_projectile[friendly_projectile.count].set_id (total_projectiles)
            friendly_projectile[friendly_projectile.count].change_position (fighter_pos.r, fighter_pos.c)
            from
       			x:=1
       		until
       			x > (friendly_projectile.count-1)
       		loop
       			 if (friendly_projectile[x].position0.row -1)~ fighter_pos.r and (friendly_projectile[x].position0.column +1)~ fighter_pos.c and friendly_projectile[x].status0 = true then friendly_projectile[x].update_status0(false) friendly_projectile[friendly_projectile.count].update_damage1 (friendly_projectile[x].damage0 + friendly_projectile[friendly_projectile.count].damage1) end
	             if (friendly_projectile[x].position0.row +1)~ fighter_pos.r and (friendly_projectile[x].position0.column +1)~ fighter_pos.c and friendly_projectile[x].status0 = true then print("1111111%N")friendly_projectile[x].update_status0(false) friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[x].damage0 + friendly_projectile[friendly_projectile.count].damage0)end
	             if (friendly_projectile[x].position1.row -1)~ fighter_pos.r and (friendly_projectile[x].position1.column +1)~ fighter_pos.c and friendly_projectile[x].status1 = true then print("2222222%N")friendly_projectile[x].update_status1(false) friendly_projectile[friendly_projectile.count].update_damage1 (friendly_projectile[x].damage1 + friendly_projectile[friendly_projectile.count].damage1)end
	             if (friendly_projectile[x].position1.row +1)~ fighter_pos.r and (friendly_projectile[x].position1.column +1)~ fighter_pos.c and friendly_projectile[x].status1 = true then friendly_projectile[x].update_status1(false) friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[x].damage1 + friendly_projectile[friendly_projectile.count].damage0)end
                 x:=x+1
       		end
       	   if fighter_pos.c -1 >=1 and fighter_pos.r -1 >=1 then  friendly_projectile[friendly_projectile.count].update_status0 (true) end
           if fighter_pos.c -1 >=1 and fighter_pos.r +1 <= board_row then  friendly_projectile[friendly_projectile.count].update_status1 (true) end
           total_projectiles:=total_projectiles-2

       	    across enemy is e loop
       	    	                 print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
                               if e.position.row ~ (fighter_pos.r-1) and e.position.column ~ (fighter_pos.c -1) and friendly_projectile[friendly_projectile.count].status0= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status0 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage0)
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                                print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")

       	    	                 print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
                               if e.position.row ~ (fighter_pos.r+1) and e.position.column ~ (fighter_pos.c -1) and friendly_projectile[friendly_projectile.count].status1= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status1 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage1)
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                                print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
           end
       	    across enemy_projectile is e loop
       	    	                -- print("INSPECT "+e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.status.out+" "+friendly_projectile[friendly_projectile.count].status0.out+" "+e.id.out+" "+friendly_projectile[friendly_projectile.count].id0.out+"%N")

                                if e.position.row ~ (fighter_pos.r-1) and e.position.column ~ (fighter_pos.c -1) and  not( e.id = friendly_projectile[friendly_projectile.count].id0) and friendly_projectile[friendly_projectile.count].status0 = true and e.status= true  then
                               	 print("spawn collision with e_proj%N")
										        if e.damage> friendly_projectile[friendly_projectile.count].damage0 then
										           friendly_projectile[friendly_projectile.count].update_status0 (false)
										           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage0)
										        elseif friendly_projectile[friendly_projectile.count].damage0 > e.damage then
										             e.status_mutator(false)
										             friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[friendly_projectile.count].damage0-e.damage)
										        else  friendly_projectile[friendly_projectile.count].update_status0(false)  e.status_mutator(false)
										        end

                               end
                                if e.position.row ~ (fighter_pos.r+1) and e.position.column ~ (fighter_pos.c -1) and  not( e.id = friendly_projectile[friendly_projectile.count].id1) and friendly_projectile[friendly_projectile.count].status1 = true and e.status= true  then
                               	 print("spawn collision with e_proj%N")
										        if e.damage> friendly_projectile[friendly_projectile.count].damage1 then
										           friendly_projectile[friendly_projectile.count].update_status1 (false)
										           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage1)
										        elseif friendly_projectile[friendly_projectile.count].damage1 > e.damage then
										             e.status_mutator(false)
										             friendly_projectile[friendly_projectile.count].update_damage1 (friendly_projectile[friendly_projectile.count].damage1-e.damage)
										        else  friendly_projectile[friendly_projectile.count].update_status1(false)  e.status_mutator(false)
										        end

                               end
                              --  print("new damage f_proj "+friendly_projectile[friendly_projectile.count].damage0.out+"%N")
           end
--           if friendly_projectile[friendly_projectile.count].status0= true then
--           	    play_board.put ("*",fighter_pos.r, fighter_pos.c)
--           end
--           if friendly_projectile[friendly_projectile.count].status1= true then
--           	    play_board.put ("*",fighter_pos.r+2, fighter_pos.c)
--           end

       	end
       	if setup.w_selection ~ 5 then

       	   	friendly_projectile.force (create {SPLITTER_PROJECTILE}.make, friendly_projectile.count+1)
       	   	k:=collision_for_splitter
       	   	if not (k = -1) then friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[friendly_projectile.count].damage0+k )  end
            friendly_projectile[friendly_projectile.count].set_id (total_projectiles)
            friendly_projectile[friendly_projectile.count].change_position (fighter_pos.r, fighter_pos.c+1)
            if fighter_pos.c +1 <= board_column then  friendly_projectile[friendly_projectile.count].update_status0 (true)end

       	    total_projectiles:=total_projectiles-1
       	    across enemy is e loop
       	    	                 print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
                               if e.position.row ~ fighter_pos.r and e.position.column ~ (fighter_pos.c +1) and friendly_projectile[friendly_projectile.count].status0= true and e.alive = true then
                               	  print("spawn collision%N")
                               	  friendly_projectile[friendly_projectile.count].update_status0 (false)
                               	  e.health_mutator(e.health_n - friendly_projectile[friendly_projectile.count].damage0)
                               	  if e.health_n<=0 then
                               	  	 e.alive_flag_mutator(false)
                               	  end
                               end
                                print(e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.alive.out+"%N")
           end
       	    across enemy_projectile is e loop
       	    	                print("INSPECT "+e.position.row.out+"  "+fighter_pos.r.out+"  "+e.position.column.out+" "+ (fighter_pos.c +1).out+" "+e.status.out+" "+friendly_projectile[friendly_projectile.count].status0.out+" "+e.id.out+" "+friendly_projectile[friendly_projectile.count].id0.out+"%N")

                               if e.position.row ~ fighter_pos.r and e.position.column ~  (fighter_pos.c +1)and  not( e.id = friendly_projectile[friendly_projectile.count].id0) and friendly_projectile[friendly_projectile.count].status0 = true and e.status= true  then
                               	 print("spawn collision with e_proj%N")
										        if e.damage> friendly_projectile[friendly_projectile.count].damage0 then
										           friendly_projectile[friendly_projectile.count].update_status0 (false)
										           e.damage_mutator(e.damage-friendly_projectile[friendly_projectile.count].damage0)
										        elseif friendly_projectile[friendly_projectile.count].damage0 > e.damage then
										             e.status_mutator(false)
										             friendly_projectile[friendly_projectile.count].update_damage0 (friendly_projectile[friendly_projectile.count].damage0-e.damage)
										        else  friendly_projectile[friendly_projectile.count].update_status0(false)  e.status_mutator(false)
										        end

                               end
                              --  print("new damage f_proj "+friendly_projectile[friendly_projectile.count].damage0.out+"%N")
           end
--           if friendly_projectile[friendly_projectile.count].status0= true then
--           	    play_board.put ("*",fighter_pos.r+1, fighter_pos.c+2)
--           end



       	end

--       	across friendly_projectile is g loop print(g.damage0.out+"^^^%N") --print(g.damage1.out+"^^^%N")
--       	print(g.status0.out+"^^^%N")  print(g.position0.column.out+"^^^%N") --print(g.position1.column.out+"^^^%N") print(g.status1.out+"^^^%N")
--        end
       	regen
       	--setup.energy_mutator (-setup.selected_weapon_attributes[2])
       --	setup.energy_mutator (-5)

       	if toggle_flag ~ 1 then

        else
         --   set_fog(play_board)
        end
        across enemy is e loop if  e.alive = true  then e.preemptive_action end  end
        across enemy is e loop  if e.can_see_starfighter = true and e.alive =true and e.just_spawned = false then e.action_when_starfighetr_is_seen  elseif e.alive = true and e.just_spawned = false then e.action_when_starfighter_not_seen  end end
        across enemy is e loop e.spawn_flag_false end       -- across enemy_projectile is e loop print(e.status.out+"   "+ e.id.out+"  "+e.position.column.out+"%N")  end
        print_enemy_projectiles
        print("ENEMY count: "+enemy.count.out+"%N")
        across enemy  is e loop print("SSSTTTTTT"+e.alive.out+"%N")  end
        rng_gen(board_row,board_column,model_g_threshold,model_f_threshold,model_c_threshold,model_i_threshold,model_p_threshold)

        print_friendly_projectiles
       	print_enemies
                create fire_ans.make_empty
        print_board(fire_ans)



       end

    update_setup_values
       do
           setup.starfighter_status
       end
feature -- queries
	out : STRING
		do
			create Result.make_from_string ("  ")
			if global_play_count ~ 0   then
				Result.append ("state:not started, normal, ok%N")
			    Result.append ("  Welcome to Space Defender Version 2.")
			end
			--if setup is not completed
			if play_flag ~ 1 and setup.setup_count < 6 and toggle_flag ~0 and first_toggle_call ~ 0 then

		        Result.append(setup.out)
			end

			if play_flag ~1 and setup.setup_count > 5 and toggle_flag ~ 0 and first_toggle_call ~ 0 then
				create feedback.make_empty
                feedback.append("state:in game("+i.out+"."+"0)"+", normal"+", ok%N")
                result.append (feedback)
                update_setup_values
			    starfighter_values.append("Starfighter:%N"+"    [0,S]->health:"+setup.health_n.out+"/"+setup.health_d.out+", energy:"+setup.energy_n.out+"/"+setup.energy_d.out+", Regen:"+setup.regen_n.out+"/"+setup.regen_d.out+", Armour:"+setup.armour_v.out+", Vision:"+setup.vision.out+", Move:"+setup.move.out+", Move Cost:"+setup.move_c.out+", location:"+"["+array_row[fighter_pos.r]+",1"+"]")
                setup.projectile_power_string_setter
                result.append ("  "+starfighter_values+"%N"+"      "+setup.projectile_power_string+"%N      score:0%N")
                set_board(play_board)
                set_fog(play_board)
                print_board(play_ans)
			    result.append ("  "+play_ans)
			    create play_ans.make_empty
			    play_flag:=0
			end

			if move_flag ~ 1 and toggle_flag ~ 0  then
				create feedback.make_empty
                feedback.append("state:in game("+i.out+"."+"0)"+", normal"+", ok%N")
                create starfighter_values.make_empty
                starfighter_values.append("Starfighter:%N"+"    [0,S]->health:"+setup.health_n.out+"/"+setup.health_d.out+", energy:"+setup.energy_n.out+"/"+setup.energy_d.out+", Regen:"+setup.regen_n.out+"/"+setup.regen_d.out+", Armour:"+setup.armour_v.out+", Vision:"+setup.vision.out+", Move:"+setup.move.out+", Move Cost:"+setup.move_c.out+", location:"+"["+array_row[fighter_pos.r]+",1"+"]")
                result.append (feedback)
                result.append ("  "+starfighter_values+"%N"+"      "+setup.projectile_power_string+"%N      score:0%N")
			    result.append("  "+move_ans)
				move_flag:=0
			end

			if pass_flag ~ 1 and toggle_flag ~ 0 then
				create feedback.make_empty
                feedback.append("state:in game("+i.out+"."+"0)"+", normal"+", ok%N")
                create starfighter_values.make_empty
                starfighter_values.append("Starfighter:%N"+"    [0,S]->health:"+setup.health_n.out+"/"+setup.health_d.out+", energy:"+setup.energy_n.out+"/"+setup.energy_d.out+", Regen:"+setup.regen_n.out+"/"+setup.regen_d.out+", Armour:"+setup.armour_v.out+", Vision:"+setup.vision.out+", Move:"+setup.move.out+", Move Cost:"+setup.move_c.out+", location:"+"["+array_row[fighter_pos.r]+",1"+"]")
                result.append (feedback)
                result.append ("  "+starfighter_values+"%N"+"      "+setup.projectile_power_string+"      "+"%N      score:0%N")
			    result.append("  "+pass_ans+"%N")
			    --result.append (enemy_toggle_string)
			    --result.append (projectile_toggle_string)
			    result.append (" "+enemy_proj_toggle_string)
			    create enemy_proj_toggle_string.make_empty
				pass_flag:=0
			end

			if fire_flag ~ 1 and toggle_flag ~ 0  then
				create feedback.make_empty
                feedback.append("state:in game("+i.out+"."+"0)"+", normal"+", ok%N")
                create starfighter_values.make_empty
                starfighter_values.append("Starfighter:%N"+"    [0,S]->health:"+setup.health_n.out+"/"+setup.health_d.out+", energy:"+setup.energy_n.out+"/"+setup.energy_d.out+", Regen:"+setup.regen_n.out+"/"+setup.regen_d.out+", Armour:"+setup.armour_v.out+", Vision:"+setup.vision.out+", Move:"+setup.move.out+", Move Cost:"+setup.move_c.out+", location:"+"["+array_row[fighter_pos.r]+",1"+"]")
                result.append (feedback)
                result.append ("  "+starfighter_values+"%N"+"      "+setup.projectile_power_string+"      "+"%N      score:0%N")
			    result.append("  "+fire_ans)
				fire_flag:=0
			end

			if special_flag ~ 1 and toggle_flag ~ 0 then
			    create feedback.make_empty
                feedback.append("state:in game("+i.out+"."+"0)"+", normal"+", ok%N")
                create starfighter_values.make_empty
                starfighter_values.append("Starfighter:%N"+"    [0,S]->health:"+setup.health_n.out+"/"+setup.health_d.out+", energy:"+setup.energy_n.out+"/"+setup.energy_d.out+", Regen:"+setup.regen_n.out+"/"+setup.regen_d.out+", Armour:"+setup.armour_v.out+", Vision:"+setup.vision.out+", Move:"+setup.move.out+", Move Cost:"+setup.move_c.out+", location:"+"["+array_row[fighter_pos.r]+",1"+"]")
                result.append (feedback)
                result.append ("  "+starfighter_values+"%N"+"      "+setup.projectile_power_string+"      "+"%Nscore:0%N")
			    result.append("  "+special_ans)
			    special_flag:=0
			end





		end
end




