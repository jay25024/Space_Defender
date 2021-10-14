note
	description: "Summary description for {FIGHTER_PROJECTILE_ENS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIGHTER_PROJECTILE_ENS


inherit
	ENEMY_PROJECTILES
create
	make

feature
	 make
		 do
		 	  model:=model_access.m
			  move:= 3
			  damage:=20
			  status:=false
			  position:= [0,0]
		 end

	 change_position(row:INTEGER;column:INTEGER)
		 do
		 	position:=[row,column]
		 end

	 set_id(k:INTEGER)
		 do
		 	id:=k
		 end
     status_mutator(l:BOOLEAN)
         do
           status:=l
         end
     damage_mutator(o:INTEGER)
       do
       	damage:=o
       end
     advance
       local
     	interaction:BOOLEAN
         do

               across  1 |..| 3 is p loop
                    if position.column-p < 1 then
	 		        status:=false

	 	            end
		             across model.friendly_projectile is f loop

		                                             if f.position0.row ~ position.row and f.position0.column ~ (position.column-p) and f.status0= true and not( f.id0 = id) and status = true  then
			                                                  if f.damage0 > damage then
			                                                  	 f.update_damage0(f.damage0-damage)
			                                                  	 status:=false
			                                                  elseif damage> f.damage0 then
			                                                  	 damage:=damage-f.damage0
			                                                  	 f.update_status0(false)
			                                                  else f.update_status0(false) status:=false
			                                                  end
			                                         if status = false then
			                                           interaction:=true
			                                         end

			                                         model.fill_enemy_proj_toggle_string("The projectile collides with friendly projectile(id:<"+f.id0.out+">) at location ["+f.position0.row.out+","+f.position0.column.out+"], negating damage.%N")

			                                         print("    enemy  projectile collides with friendly projectile damaging  it by "+damage.out+"%N"+"New damage friendly "+f.damage0.out+"New damage enemy "+ damage.out+"%N")
			                                         end
			                                         if f.position1.row ~ position.row and f.position1.column ~ (position.column-p) and f.status1= true and not( f.id1 = id) and status = true  then
			                                                  if f.damage1 > damage then
			                                                  	 f.update_damage1(f.damage1-damage)
			                                                  	 status:=false
			                                                  elseif damage> f.damage1 then
			                                                  	 damage:=damage-f.damage1
			                                                  	 f.update_status1(false)
			                                                  else f.update_status1(false) status:=false
			                                                  end
			                                           if status = false then
			                                           interaction:=true
			                                           end
			                                          model.fill_enemy_proj_toggle_string("The projectile collides with friendly projectile(id:<"+f.id1.out+">) at location ["+f.position1.row.out+","+f.position1.column.out+"], negating damage.%N")

			                                         end
			                                         if f.position2.row ~ position.row and f.position2.column ~ (position.column-p) and f.status2= true and not( f.id2 = id) and status = true  then
			                                                  if f.damage2 > damage then
			                                                  	 f.update_damage2(f.damage2-damage)
			                                                  	 status:=false
			                                                  elseif damage> f.damage2 then
			                                                  	 damage:=damage-f.damage2
			                                                  	 f.update_status2(false)
			                                                  else f.update_status2(false) status:=false
			                                                  end
			                                            if status = false then
			                                             interaction:=true
			                                             end
			                                          model.fill_enemy_proj_toggle_string("The projectile collides with friendly projectile(id:<"+f.id2.out+">) at location ["+f.position2.row.out+","+f.position2.column.out+"], negating damage.%N")

			                                         end



		              end

		              if position.column-p ~ model.fighter_pos.c and position.row ~ model.fighter_pos.r and status= true then
			                                               	      status:=false

			                                               	      if model.setup.armour_v - damage < 0 then
			                                               	      	 model.setup.health_mutator (-(damage-model.setup.armour_v))
			                                               	      	 model.setup.armour_v_mutator (-model.setup.armour_v)
			                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (-(model.setup.health_n+1)) end
			                                               	      else model.setup.armour_v_mutator(-damage)
			                                               	      end
			           interaction:=true
			          model.fill_enemy_proj_toggle_string ("The projectile collides with Starfighter(id:0) at location ["+model.fighter_pos.r.out+","+model.fighter_pos.c.out+"], dealing <"+(model.enemy_projectile[model.enemy_projectile.count].damage -model.setup.armour_v).out+"> damage.%N")


	                  print("    Enemy projectile collides with starfighter damaging it by: "+damage.out+"Its id: "+id.out+"%N")
	                  end

		              across model.enemy is y loop

		                                     if position.column-p ~ y.position.column and position.row ~ y.position.row and status= true then
			                                               	      status:=false

			                                               	      if y.health_n + damage > y.health_d then
			                                               	      	 y.health_mutator(y.health_d)
			                                               	      else y.health_mutator(y.health_n + damage)
			                                               	      end

			                                 interaction:=true
			                                 model.fill_enemy_proj_toggle_string ("The projectile collides with <"+y.signature.out+">(id:<"+y.id.out+">) at location ["+y.position.row.out+","+y.position.column.out+"], healing <"+model.enemy_projectile[model.enemy_projectile.count].damage.out +"> damage.")


                                             print("      projectile collides with enemy "+y.position.column.out+" healing it by "+damage.out+"%N"+"New health enemy"+y.health_n.out+"%N")
                                             end

		             end

		             across model.enemy_projectile is r loop

                                if position.column-p ~ r.position.column and position.row ~ r.position.row and status= true and r.status= true and not( r.id = id) then
			                                               	       r.status_mutator(false)
                                                                   damage:= r.damage+ damage


                                model.fill_enemy_proj_toggle_string ("The projectile collides with enemy projectile(id:<"+ r.id.out+">) at location ["+r.position.row.out+","+ r.position.column.out+"], combining damage.%N")

                                print("      projectile collides with enemy projectile healing it by "+r.damage.out+"%N")
                                end


		             end


              end


          position.column:= position.column- 3

           if position.column < 1 and( position.column +3)>=1 and interaction =false and status= true then
               model.fill_enemy_proj_toggle_string("A enemy projectile(id:"+id.out+") moves: ["+model.array_row[position.row]+","+position.column.out+"] -> out of board%N")
          elseif interaction = false and status = true then
              	model.fill_enemy_proj_toggle_string("A enemy projectile(id:"+id.out+") moves: ["+model.array_row[position.row]+","+(position.column+3).out+"] -> ["+model.array_row[position.row]+","+(position.column).out+"]%N")
          end

          if position.column+3<1 then

          end


end


end









