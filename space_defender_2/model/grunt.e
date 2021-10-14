note
	description: "Summary description for {GRUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRUNT

inherit
	ENEMIES
create
	make

feature-- attributes
    model:SPACE_DEFENDER_2
    model_access:SPACE_DEFENDER_2_ACCESS
    enemy_present:BOOLEAN
    enemy_location:TUPLE[row:INTEGER;column:INTEGER]

feature--Initialization
    make
      do
      	create signature.make_empty
      	create name.make_empty
      	name:="Grunt"
      	signature:="G"
      	type:=1
      	health_n:=100
      	health_d:=100
      	regen:=1
      	armour:=1
      	vision:=5
      	id:=0

      	seen_by_starfighter:=false
        can_see_starfighter:=false
        create seen_by_starfighter_presentation.make_empty
        create can_see_starfighter_presentation.make_empty
        seen_by_starfighter_presentation:="F"
        can_see_starfighter_presentation:="F"

        position:=[0,0]
        enemy_location:=[0,0]
        model:=model_access.m
        action_flag:=0
        just_spawned:=false

        alive:=false
        enemy_present:=false


      end

feature-- Actions
     spawn_flag_true
      do
      	just_spawned:=true
      end
    spawn_flag_false
      do
      	just_spawned:=false
      end
     fires
       do

       end
     assign_id(u:INTEGER)
       do
       	id:=u
       end
    preemptive_action
      do
      	if model.pass_flag ~ 1 then
      		passes
      		model.fill_enemy_action_string ("A Grunt(id:"+id.out+") gains 10 total health.%N")
      	end
      	if model.special_flag~1 then
      		specials
      		model.fill_enemy_action_string ("A Grunt(id:"+id.out+") gains 20 total health.%N")
      	end
      end

    false_true_presenter
      do
         if seen_by_starfighter = false then
         	seen_by_starfighter_presentation:="F"
         	else
         		seen_by_starfighter_presentation:="T"
         end

         if can_see_starfighter =false then
         	can_see_starfighter_presentation:="F"
         	else
         		can_see_starfighter_presentation:="T"
         end
      end
    alive_flag_mutator(l:BOOLEAN)
      do
      	alive:=l
      end
    change_vision
      do
      	 if (position.row-model.fighter_pos.r).abs + (position.column-model.fighter_pos.c).abs > vision then else can_see_starfighter:= true end
      	 if (position.row-model.fighter_pos.r).abs + (position.column-model.fighter_pos.c).abs > model.setup.vision then else seen_by_starfighter:= true end
      end
    health_mutator(l:INTEGER)
    do
    	health_n:=l
    end
    position_setter(r:INTEGER;c:INTEGER)
      do
      	position.row:= r
      	position.column:=c
      	change_vision
      	false_true_presenter
      end
    passes
      do
      	health_n:=health_n+10
      	health_d:=health_d+10
      end
    specials
      do
      	health_n:=health_n+20
      	health_d:=health_d+20
      end
     action_when_starfighter_not_seen
      do
      	action_flag:=1
       change_vision
        advance
      change_vision
      false_true_presenter
        if alive then
      	fire
        end
      end
     action_when_starfighetr_is_seen
      do
      	action_flag:=1
       change_vision
      	advance
       change_vision
       false_true_presenter
      	if alive then
      	fire
        end
      end
     action_flag_reset
      do
      	action_flag:=0
      end
     fire
     local
     	t:INTEGER
      do



       model.enemy_projectile.force((create {GRUNT_PROJECTILE}.make),model.enemy_projectile.count+1)
        -- initialize position of this projectile

        model.enemy_projectile[model.enemy_projectile.count].status_mutator(true)
        model.enemy_projectile[model.enemy_projectile.count].change_position(position.row,position.column-1)
        model.enemy_projectile[model.enemy_projectile.count].set_id(model.total_projectiles)
        model.total_projectile_mutator
        if (position.column -1 ) <= 1 then
            model.enemy_projectile[model.enemy_projectile.count].status_mutator(false)
        end

                                      across model.friendly_projectile is f loop

						                                             if f.position0.row ~ position.row and f.position0.column ~ (position.column-1) and f.status0= true and not( f.id0 = id) and model.enemy_projectile[model.enemy_projectile.count].status = true  then
							                                                     f.update_damage0(f.damage0-model.enemy_projectile[model.enemy_projectile.count].damage)
							                                                  	 if f.damage0 <=0 then f.update_status0(false) end
							                                                  	 model.enemy_projectile[model.enemy_projectile.count]. damage_mutator( model.enemy_projectile[model.enemy_projectile.count]. damage - (f.damage0+ model.enemy_projectile[model.enemy_projectile.count]. damage))
							                                                     if model.enemy_projectile[model.enemy_projectile.count].damage <=0 then
							                                                  	 model.enemy_projectile[model.enemy_projectile.count].status_mutator(false) end

							                                         model.fill_enemy_proj_toggle_string("The projectile collides with friendly projectile(id:<"+f.id0.out+">) at location ["+f.position0.row.out+","+f.position0.column.out+"], negating damage.%N")


							                                         print("  just spawned  projectile collides with friendly projectile damaging  it by "+"15"+"%N")
							                                         print("      new friendly proj health"+ f.damage0.out+"%N")
							                                         print("  new just spawned enemy prjectile health "+model.enemy_projectile[model.enemy_projectile.count].damage.out+"%N")
							                                         end
							                                         if f.position1.row ~ position.row and f.position1.column ~ (position.column-1) and f.status1= true and not( f.id1 = id) and model.enemy_projectile[model.enemy_projectile.count].status = true  then
							                                                     f.update_damage1(f.damage1-model.enemy_projectile[model.enemy_projectile.count].damage)
							                                                  	 if f.damage1 <=0 then f.update_status1(false) end
							                                                  	  model.enemy_projectile[model.enemy_projectile.count]. damage_mutator( model.enemy_projectile[model.enemy_projectile.count]. damage - (f.damage1+ model.enemy_projectile[model.enemy_projectile.count]. damage))
							                                                     if model.enemy_projectile[model.enemy_projectile.count].damage <=0 then
							                                                  	  model.enemy_projectile[model.enemy_projectile.count].status_mutator(false) end

							                                        model.fill_enemy_proj_toggle_string("The projectile collides with friendly projectile(id:<"+f.id1.out+">) at location ["+f.position1.row.out+","+f.position1.column.out+"], negating damage.%N")


							                                         print("      projectile collides with enemy  damaging  it by "+f.damage0.out+"%N")
							                                         end
							                                         if f.position2.row ~ position.row and f.position2.column ~ (position.column-1) and f.status2= true and not( f.id2 = id) and model.enemy_projectile[model.enemy_projectile.count].status = true  then
							                                                     f.update_damage2(f.damage2-model.enemy_projectile[model.enemy_projectile.count].damage)
							                                                  	 if f.damage2 <=0 then f.update_status2(false) end
							                                                  	  model.enemy_projectile[model.enemy_projectile.count]. damage_mutator( model.enemy_projectile[model.enemy_projectile.count]. damage - (f.damage0+ model.enemy_projectile[model.enemy_projectile.count]. damage))
							                                                     if model.enemy_projectile[model.enemy_projectile.count].damage <=0 then
							                                                  	  model.enemy_projectile[model.enemy_projectile.count].status_mutator(false) end

							                                        model.fill_enemy_proj_toggle_string("The projectile collides with friendly projectile(id:<"+f.id2.out+">) at location ["+f.position2.row.out+","+f.position2.column.out+"], negating damage.%N")


							                                         print("      projectile collides with enemy  damaging  it by "+f.damage0.out+"%N")
							                                         end



						              end

						              if position.column-1 ~ model.fighter_pos.c and position.row ~ model.fighter_pos.r and model.enemy_projectile[model.enemy_projectile.count].status= true and alive = true then
							                                               	      model.enemy_projectile[model.enemy_projectile.count].status_mutator(false)

							                                               	      if model.setup.armour_v -model.enemy_projectile[model.enemy_projectile.count].damage< 0 then
							                                               	      	 model.setup.health_mutator (-(health_n-model.setup.armour_v))
							                                               	      	 model.setup.armour_v_mutator (-model.setup.armour_v)
							                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (-(model.setup.health_n)) end
							                                               	      else model.setup.armour_v_mutator (-health_n)
							                                               	      end

							          model.fill_enemy_proj_toggle_string ("The projectile collides with Starfighter(id:0) at location ["+model.fighter_pos.r.out+","+model.fighter_pos.c.out+"], dealing <"+(model.enemy_projectile[model.enemy_projectile.count].damage -model.setup.armour_v).out+"> damage.%N")


					                  print("    Just spawned  enemy projectile collides with starfighter damaging it by "+model.enemy_projectile[model.enemy_projectile.count].damage.out+"%N")
					                  end

						              across model.enemy is y loop

						                                     if position.column-1 ~ y.position.column and position.row ~ y.position.row and model.enemy_projectile[model.enemy_projectile.count].status= true and y.alive = true and not(y.id = id) then

				                                             model.enemy_projectile[model.enemy_projectile.count].status_mutator(false)
				                                              if y.health_n + model.enemy_projectile[model.enemy_projectile.count].damage >= y.health_d then
			                                               	      	 y.health_mutator(y.health_d)
			                                               	  else y.health_mutator(y.health_n + model.enemy_projectile[model.enemy_projectile.count].damage)
			                                               	  end


                                                             model.fill_enemy_proj_toggle_string ("The projectile collides with <"+y.signature.out+">(id:<"+y.id.out+">) at location ["+y.position.row.out+","+y.position.column.out+"], healing <"+model.enemy_projectile[model.enemy_projectile.count].damage.out +"> damage.")


				                                             print("      enemy present at "+y.position.column.out+"%N")
				                                             end

						             end

						             from
						             	t:=1
						             until
						             	t> (model.enemy_projectile.count -1)
						             loop

                                       if position.column-1 ~ model.enemy_projectile[t].position.column and position.row ~ model.enemy_projectile[t].position.row and model.enemy_projectile[model.enemy_projectile.count].status= true  and model.enemy_projectile[t].status= true and not( model.enemy_projectile[t].id = id) then
							                                               	       model.enemy_projectile[t].status_mutator(false)
				                                                                   model.enemy_projectile[model.enemy_projectile.count].damage_mutator(model.enemy_projectile[model.enemy_projectile.count].damage+model.enemy_projectile[t].damage)

				                                model.fill_enemy_proj_toggle_string ("The projectile collides with enemy projectile(id:<"+ model.enemy_projectile[t].id.out+">) at location ["+model.enemy_projectile[t].position.row.out+","+ model.enemy_projectile[t].position.column.out+"], combining damage.%N")

				                                print("      enemy collides with enemy projectile healing it by "+model.enemy_projectile[t].damage.out+"%N")
				                       end
						               t:=t+1
						             end





      end
     advance
     local
     	p:INTEGER
     	interactions:STRING
      do
      	create interactions.make_empty
      	print("Status_seen: "+can_see_starfighter.out+"%N" )
     	 if can_see_starfighter = true then


			 	   	           from
			 	   	           	  p:= -1
			 	   	           until
			 	   	           	  p< -4 or enemy_present = true or alive = false
			 	   	           loop
			 	   	           	   if position.column+p < 1 then
	 		                        alive:=false
	 		                        model.fill_enemy_action_string ("A Grunt(id:"+id.out+") moves: ["+model.array_row[position.row]+","+position.column.out+"] -> out of board%N")
	 	                           end
                                      across model.friendly_projectile is f loop

						                                             if f.position0.row ~ position.row and f.position0.column ~ (position.column+p) and f.status0= true and not( f.id0 = id) and alive = true  then

							                                                  if health_n-(f.damage0-armour) <= 0 then
							                                                  	 f.update_status0(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status0(false) health_n:=health_n-(f.damage0-armour)
							                                                  end
							                                                  if armour - f.damage0 <=0 then
							                                                           armour := 0
							                                                  end

							                                         if alive =false then

							                                         model.fill_enemy_action_string ("A Grunt(id:"+id.out+") moves: ["+model.array_row[position.row]+","+position.column.out+"] -> ["+model.array_row[position.row]+","+(position.column+p).out+"]%N")
                                                                     model.fill_enemy_action_string (interactions)
							                                         model.fill_enemy_action_string ("The Grunt collides with friendly projectile(id:"+f.id0.out+") at location ["+model.array_row[position.row]+","+(position.column+p).out+"], taking "+f.damage0.out+" damage.%N")
							                                         model.fill_enemy_action_string ("The Grunt at location ["+model.array_row[position.row]+","+(position.column+p).out+"] has been destroyed.%N")
							                                         end
							                                        if alive = true then

							                                        interactions.append ("The Grunt collides with friendly projectile(id:"+f.id0.out+") at location ["+model.array_row[position.row]+","+(position.column+p).out+"], taking "+f.damage0.out+" damage.%N")

							                                        end

							                                         end
							                                         if f.position1.row ~ position.row and f.position1.column ~ (position.column+p) and f.status1= true and not( f.id1 = id) and alive = true  then
							                                                  if health_n-(f.damage1-armour) <= 0 then
							                                                  	 f.update_status1(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status1(false) health_n:=health_n-(f.damage1-armour)
							                                                  end
							                                                  if armour - f.damage1 <=0 then
							                                                           armour := 0
							                                                  end

							                                         if alive =false then

							                                         model.fill_enemy_action_string ("A Grunt(id:"+id.out+") moves: ["+model.array_row[position.row]+","+position.column.out+"] -> ["+model.array_row[position.row]+","+(position.column+p).out+"]%N")

							                                         model.fill_enemy_action_string (interactions)
							                                         model.fill_enemy_action_string ("The Grunt collides with friendly projectile(id:"+f.id1.out+") at location ["+model.array_row[position.row]+","+(position.column+p).out+"], taking "+f.damage1.out+" damage.%N")
							                                         model.fill_enemy_action_string ("The Grunt at location ["+model.array_row[position.row]+","+(position.column+p).out+"] has been destroyed.%N")
							                                         end

							                                         if alive = true then

							                                        interactions.append ("The Grunt collides with friendly projectile(id:"+f.id1.out+") at location ["+model.array_row[position.row]+","+(position.column+p).out+"], taking "+f.damage1.out+" damage.%N")

							                                        end


							                                         end
							                                         if f.position2.row ~ position.row and f.position2.column ~ (position.column+p) and f.status2= true and not( f.id2 = id) and alive = true  then
							                                                  if health_n-(f.damage2-armour)<= 0 then
							                                                  	 f.update_status2(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status2(false) health_n:=health_n-(f.damage2-armour)
							                                                  end
							                                                  if armour - f.damage2 <=0 then
							                                                           armour := 0
							                                                  end

							                                          if alive =false then

							                                         model.fill_enemy_action_string ("A Grunt(id:"+id.out+") moves: ["+model.array_row[position.row]+","+position.column.out+"] -> ["+model.array_row[position.row]+","+(position.column+p).out+"]%N")

							                                         model.fill_enemy_action_string (interactions)
							                                         model.fill_enemy_action_string ("The Grunt collides with friendly projectile(id:"+f.id2.out+") at location ["+model.array_row[position.row]+","+(position.column+p).out+"], taking "+f.damage2.out+" damage.%N")
							                                         model.fill_enemy_action_string ("The Grunt at location ["+model.array_row[position.row]+","+(position.column+p).out+"] has been destroyed.%N")
							                                         end

							                                         if alive = true then

							                                        interactions.append ("The Grunt collides with friendly projectile(id:"+f.id2.out+") at location ["+model.array_row[position.row]+","+(position.column+p).out+"], taking "+f.damage2.out+" damage.%N")

							                                        end

							                                         end



						              end

						              if position.column+p ~ model.fighter_pos.c and position.row ~ model.fighter_pos.r and alive= true then
							                                               	      alive:=false
                                         print("This execr##%N")
							                                               	      if model.setup.armour_v - health_n < 0 then
							                                               	      	 model.setup.health_mutator (-(health_n-model.setup.armour_v))
							                                               	      	 model.setup.armour_v_mutator (-model.setup.armour_v)
							                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (-(model.setup.health_n+1)) end
							                                               	      else model.setup.armour_v_mutator (-health_n)
							                                               	      end

					                  print("      enemy collides with starfighter damaging it by "+health_n.out+"%N")
					                  end

						              across model.enemy is y loop

						                                     if position.column+p ~ y.position.column and position.row ~ y.position.row and alive= true and enemy_present= false and y.alive = true and not(y.id = id) then

				                                                                  enemy_present:=true
				                                                                  enemy_location:= [y.position.row, y.position.column]


				                                             print("      enemy present at "+y.position.column.out+"%N")
				                                             end

						             end

						             across model.enemy_projectile is r loop

				                                if position.column+p ~ r.position.column and position.row ~ r.position.row and alive= true and r.status= true and not( r.id = id) then
							                                               	       r.status_mutator(false)
				                                                                   if health_n + r.damage > health_d then
							                                               	      	 health_n:=health_d
							                                               	      else health_n:=health_n + r.damage
							                                               	      end

				                                --interactions.append (s: READABLE_STRING_8)
				                                end


						             end

                             p:=p-1

                          end

				          if enemy_present = true then
				          	if alive = true and not (position.column ~ (enemy_location.column +1) ) then
		                    model.fill_enemy_action_string ("A Grunt(id:"+id.out+") moves: ["+model.array_row[position.row]+","+position.column.out+"] -> ["+model.array_row[position.row]+","+(enemy_location.column +1).out+"]%N")

		                  	model.fill_enemy_action_string (interactions)
		                   elseif alive = true then model.fill_enemy_action_string("A Grunt(id:"+id.out+") stays at: ["+model.array_row[position.row]+","+(position.column).out+"]%N")
		                   end

		                  position.column:=enemy_location.column +1
		                  enemy_location:=[0,0]
		                  enemy_present:=false


				          else
				          	if alive = true then
				          	  model.fill_enemy_action_string ("A Grunt(id:"+id.out+") moves: ["+model.array_row[position.row]+","+position.column.out+"] -> ["+model.array_row[position.row]+","+(position.column-4).out+"]%N")
				          	  model.fill_enemy_action_string (interactions)
				          	end

				          position.column:= position.column- 4
				          end






      	   elseif can_see_starfighter = false then
           print("How many times ...........%N")

			 	   	           from
			 	   	           	  p:= -1
			 	   	           until
			 	   	           	  p< -2 or enemy_present = true or alive = false
			 	   	           loop
			 	   	           	if position.column+p < 1 then
	 		                        alive:=false
	 	                        end
                                      across model.friendly_projectile is f loop

						                                             if f.position0.row ~ position.row and f.position0.column ~ (position.column+p) and f.status0= true and not( f.id0 = id) and alive = true  then
							                                                  if health_n-f.damage0 <= 0 then
							                                                  	 f.update_status0(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status0(false) health_n:=health_n-f.damage0
							                                                  end
							                                         print(" while enemy moving  projectile collides with enemy  damaging  it by "+f.damage0.out+"%N")
							                                         print("new enemy health "+ health_n.out+"%N")
							                                         print("collision at pos :"+(position.column+p).out+"%N")
							                                         end
							                                         if f.position1.row ~ position.row and f.position1.column ~ (position.column+p) and f.status1= true and not( f.id1 = id) and alive = true  then
							                                                  if health_n-f.damage1 <= 0 then
							                                                  	 f.update_status1(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status1(false) health_n:=health_n-f.damage1
							                                                  end
							                                         end
							                                         if f.position2.row ~ position.row and f.position2.column ~ (position.column+p) and f.status2= true and not( f.id2 = id) and alive = true  then
							                                                  if health_n-f.damage2<= 0 then
							                                                  	 f.update_status2(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status2(false) health_n:=health_n-f.damage2
							                                                  end
							                                         end



						              end
                                      print("My Man2"+(position.column+p).out+"   "+alive.out+"%N" )
						              if position.column+p ~ model.fighter_pos.c and position.row ~ model.fighter_pos.r and alive= true then
							                                               	      alive:=false

							                                               	      if model.setup.armour_v - health_n < 0 then
							                                               	      	 model.setup.health_mutator (-(health_n-model.setup.armour_v))
							                                               	      	 model.setup.armour_v_mutator (-model.setup.armour_v)
							                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (-(model.setup.health_n+1)) end
							                                               	      else model.setup.armour_v_mutator (-health_n)
							                                               	      end

					                  print("      enemy collides with starfighter damaging it by "+health_n.out+"%N")
					                  end
                                      print("      enemy present at %N")
						              across model.enemy is y loop

						                                     if position.column+p ~ y.position.column and position.row ~ y.position.row and alive= true and enemy_present= false and y.alive = true then

				                                                                  enemy_present:=true
				                                                                  enemy_location:= [y.position.row, y.position.column]


				                                             print("      enemy present at "+y.position.column.out+"%N")
				                                             end
				                                              print("      enemy present at "+y.position.column.out+"%N")

						             end

						             across model.enemy_projectile is r loop

				                                if position.column+p ~ r.position.column and position.row ~ r.position.row and alive= true and r.status= true and not( r.id = id) then
							                                               	       r.status_mutator(false)
				                                                                   if health_n + r.damage > health_d then
							                                               	      	 health_n:=health_d
							                                               	      else health_n:=health_n + r.damage
							                                               	      end

				                                print("      enemy collides with enemy projectile healing it by "+r.damage.out+"%N")
				                                end


						             end



				              p:=p-1
                           end

				          if enemy_present = true then
		                  position.column:=enemy_location.column +1
		                  enemy_location:=[0,0]
		                  enemy_present:=false
				          else
				          position.column:= position.column- 2
				          end


      	   end

      end

end
