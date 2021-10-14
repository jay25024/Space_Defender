note
	description: "Summary description for {SPREAD_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPREAD_PROJECTILE
inherit
	FRIENDLY_PROJECTILES
create
    make
feature
	make
	 do
	 	move:=1
	 	damage0:= 50
	 	damage1:=50
	 	damage2:=50
	 	id0:=0
	 	id1:=0
	 	id2:=0
	 	position0:=[0,0]
	 	position1:=[0,0]
	 	position2:=[0,0]
	 	cost:=10
	 	status0:=false
	 	status1:=false
	 	status2:=false
	 	model:= model_access.m
	 end

	 set_id(k:INTEGER)
	 do
	 	id0:=k
	 	id1:=k-1
	 	id2:=k-2
	 end

	 change_position(row:INTEGER;column:INTEGER)
	 do
	 	position0:=[row-1,column]
	 	position1:=[row,column]
	 	position2:=[row+1,column]
	 end
    update_status0(j:BOOLEAN)
    do
    	status0:=j
    end
    update_status1(j:BOOLEAN)
    do
    	status1:=j
    end
    update_status2(j:BOOLEAN)
    do
    	status2:=j
    end
    update_damage0(l:INTEGER)
      do
         damage0:=l
      end
    update_damage1(l:INTEGER)
      do
         damage1:=l
      end
    update_damage2(l:INTEGER)
      do
         damage2:=l
      end

   advance
     do
     	if position0.row-1 < 1 then
     		update_status0(false)
     	end
     	if position0.column+1 > model.board_column then
     		update_status0(false)
     	end
     	if position1.column+1 > model.board_column then
     		update_status1(false)
     	end
     	if position2.row+1 > model.board_row then
     		update_status2(false)
     	end
     	if position2.column+1 > model.board_column then
     		update_status2(false)
     	end

     	if status0=true or status1=true or status2=true then

                        across model.friendly_projectile is s loop

                        	if s.position0.row ~ position0.row-1 and s.position0.column ~ position0.column+1  and not(s.id0 = id0) and s.status0=true and status0 = true then s.update_status0(false)  update_damage0(s.damage0+damage0) end
                            if s.position1.row ~ position0.row-1 and s.position1.column ~ position0.column+1  and not(s.id1 = id0) and s.status1=true and status0 = true then s.update_status1(false)  update_damage0(s.damage1+damage0) end
                            if s.position2.row ~ position0.row-1 and s.position2.column ~ position0.column+1  and not(s.id2 = id0) and s.status2=true and status0 = true then s.update_status2(false)  update_damage0(s.damage2+damage0) end

                        	if s.position0.row ~ position1.row   and s.position0.column ~ position1.column+1  and not(s.id0 = id1) and s.status0=true and status1 = true then s.update_status0(false)  update_damage1(s.damage0+damage1) end
                            if s.position1.row ~ position1.row   and s.position1.column ~ position1.column+1  and not(s.id1 = id1) and s.status1=true and status1 = true then s.update_status1(false)  update_damage1(s.damage1+damage1) end
                            if s.position2.row ~ position1.row   and s.position2.column ~ position1.column+1  and not(s.id2 = id1) and s.status2=true and status1 = true then s.update_status2(false)  update_damage1(s.damage2+damage1) end

                            if s.position0.row ~ position2.row+1 and s.position0.column ~ position2.column+1  and not(s.id0 = id2) and s.status0=true and status2 = true then s.update_status0(false)  update_damage2(s.damage0+damage2) end
                            if s.position1.row ~ position2.row+1 and s.position1.column ~ position2.column+1  and not(s.id1 = id2) and s.status1=true and status2 = true then s.update_status1(false)  update_damage2(s.damage1+damage2) end
                            if s.position2.row ~ position2.row+1 and s.position2.column ~ position2.column+1  and not(s.id2 = id2) and s.status2=true and status2 = true then s.update_status2(false)  update_damage2(s.damage2+damage2) end

                         end

                            if position0.column+1 ~ model.fighter_pos.c and (position0.row-1) ~ model.fighter_pos.r and status0= true then
			                        update_status0(false)

			                      if model.setup.armour_v - damage0 < 0 then
			                            model.setup.health_mutator (model.setup.health_n-(damage0-model.setup.armour_v))
			                            model.setup.armour_v_mutator (0)
			                                 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (0) end
			                      end
			                elseif position1.column+1 ~ model.fighter_pos.c and position1.row ~ model.fighter_pos.r and status1= true then
                                    update_status1(false)

			                      if model.setup.armour_v - damage1 < 0 then
			                            model.setup.health_mutator (model.setup.health_n-(damage1-model.setup.armour_v))
			                            model.setup.armour_v_mutator (0)
			                                 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (0) end
			                      end
                            elseif position2.column+1 ~ model.fighter_pos.c and (position2.row+1) ~ model.fighter_pos.r and status2= true then
                                    update_status2(false)

			                      if model.setup.armour_v - damage2 < 0 then
			                            model.setup.health_mutator (model.setup.health_n-(damage1-model.setup.armour_v))
			                            model.setup.armour_v_mutator (0)
			                                 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (0) end
			                      end
	                        end

		              across model.enemy is e loop
		                                            if (e.position.row) ~ position0.row-1 and e.position.column ~ (position0.column+1) and  not( e.id = id0) and status0 = true and e.alive = true  then
			                                                  status0:=false
			                                                  e.health_mutator(e.health_n-damage0)
			                                                  if e.health_n<=0 then
                                                               e.alive_flag_mutator(false)
			                                                  end
                                                    end

		                                            if (e.position.row) ~ position1.row and e.position.column ~ (position1.column+1) and  not( e.id = id1) and status1 = true and e.alive = true  then
			                                                  status1:=false
			                                                  e.health_mutator(e.health_n-damage1)
			                                                  if e.health_n<=0 then
                                                               e.alive_flag_mutator(false)
			                                                  end
                                                    end
		                                            if (e.position.row+1) ~ position1.row and e.position.column ~ (position2.column+1) and  not( e.id = id2) and status2 = true and e.alive = true  then
			                                                  status2:=false
			                                                  e.health_mutator(e.health_n-damage2)
			                                                  if e.health_n<=0 then
                                                               e.alive_flag_mutator(false)
			                                                  end
                                                    end

		              end

		              across model.enemy_projectile is e loop
		                                            if e.position.row ~ position0.row-1 and e.position.column ~ (position0.column+1) and  not( e.id = id0) and status0 = true and e.status= true  then
			                                                 if e.damage> damage0 then
			                                                 	status0:=false
			                                                 	e.damage_mutator(e.damage-damage0)
			                                                 elseif damage0 > e.damage then
			                                                 	 e.status_mutator(false)
			                                                 	 damage0:= damage0-e.damage
			                                                 else  status0:=false  e.status_mutator(false)
			                                                 end
                                                    end
		                                            if e.position.row ~ position1.row and e.position.column ~ (position0.column+1) and  not( e.id = id1) and status1 = true and e.status= true  then
			                                                 if e.damage> damage0 then
			                                                 	status1:=false
			                                                 	e.damage_mutator(e.damage-damage1)
			                                                 elseif damage0 > e.damage then
			                                                 	 e.status_mutator(false)
			                                                 	 damage1:= damage1-e.damage
			                                                 else  status1:=false  e.status_mutator(false)
			                                                 end
                                                    end
		                                            if e.position.row ~ position2.row+1 and e.position.column ~ (position0.column+1) and  not( e.id = id2) and status2 = true and e.status= true  then
			                                                 if e.damage> damage2 then
			                                                 	status2:=false
			                                                 	e.damage_mutator(e.damage-damage2)
			                                                 elseif damage2 > e.damage then
			                                                 	 e.status_mutator(false)
			                                                 	 damage2:= damage2-e.damage
			                                                 else  status2:=false  e.status_mutator(false)
			                                                 end
                                                    end
		              end

    	end


        position0.row:=position0.row-1
        position0.column:=position0.column+1

        position1.column:=position1.column+1

        position2.row:=position2.row+1
        position2.column:=position2.column+1


     end

end
