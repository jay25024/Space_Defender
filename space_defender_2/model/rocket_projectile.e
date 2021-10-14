note
	description: "Summary description for {ROCKET_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROCKET_PROJECTILE
inherit
	FRIENDLY_PROJECTILES
create
    make
feature
	advance_factor: INTEGER


feature
	make
	 do
	 	move:=1
	 	damage0:= 100
	 	damage1:=100
	 	id0:=0
	 	id1:=0
        status0:=false
        status1:=false
        status2:=false
	 	position0:=[0,0]
	 	position1:=[0,0]
	 	position2:=[0,0]
	 	cost:=10
	 	model:= model_access.m
	 	advance_factor:=1

	 end

	 set_id(k:INTEGER)
	 do
	 	id0:=k
	 	id1:=k-1

	 end

	 change_position(row:INTEGER;column:INTEGER)
	 do
	 	position0:=[row-1,column-1]
	 	position1:=[row+1,column-1]

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

      end
      advance
      do




        if status0= true or status1= true then
                    across 1 |..| advance_factor is p loop
                    	     	if position0.column+ p > model.board_column then
							 		update_status0(false)
							 	end
							 	if position1.column +p> model.board_column then
							 		   update_status1(false)
							    end

                                                    across model.friendly_projectile is f loop
			                                               if f.position0.row ~ position0.row and f.position0.column ~ (position0.column+p) and f.status0= true and status0= true and not ( f.id0 = id0)then f.update_status0(false) print("1!!%N") damage0:=damage0+ f.damage0 end
			                                                  if f.position0.row ~ position1.row and f.position0.column ~ (position1.column+p) and f.status0= true and status1= true and not (f.id0 = id1)  then f.update_status0(false) print("2!!%N") damage1:=damage1+ f.damage0 end
                                                                  if f.position1.row ~ position0.row and f.position1.column ~ (position0.column+p) and f.status1= true and status0=true and not (f.id1 = id0) then f.update_status1(false) print("3!!%N") damage0:=damage0+ f.damage1 end
                                                                  	  if f.position1.row ~ position1.row and f.position1.column ~ (position1.column+p) and f.status1= true and status1=true and not (f.id1 = id1)then f.update_status1(false) print("4!!%N") damage1:=damage1+ f.damage1 end

			                                               if position0.column+p ~ model.fighter_pos.c and position0.row ~ model.fighter_pos.r and status0= true then
			                                               	      update_status0(false)

			                                               	      if model.setup.armour_v - damage0 < 0 then
			                                               	      	 model.setup.health_mutator (model.setup.health_n-(damage0-model.setup.armour_v))
			                                               	      	 model.setup.armour_v_mutator (0)
			                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (0) end
			                                               	      end
			                                               elseif position1.column+p ~ model.fighter_pos.c and position1.row ~ model.fighter_pos.r and status1= true then
                                                                   update_status1(false)

			                                               	      if model.setup.armour_v - damage1 < 0 then
			                                               	      	 model.setup.health_mutator (model.setup.health_n-(damage1-model.setup.armour_v))
			                                               	      	 model.setup.armour_v_mutator (0)
			                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (0) end
			                                               	      end

	                                                       end
		                                              end


									              across model.enemy_projectile is e loop
									                                            if e.position.row ~ position0.row and e.position.column ~ (position0.column+p) and  not( e.id = id0) and status0 = true and e.status= true  then
										                                                 if e.damage> damage0 then
										                                                 	status0:=false
										                                                 	e.damage_mutator(e.damage-damage0)
										                                                 elseif damage0 > e.damage then
										                                                 	 e.status_mutator(false)
										                                                 	 damage0:= damage0-e.damage
										                                                 else  status0:=false  e.status_mutator(false)
										                                                 end
							                                                    end

									                                            if e.position.row ~ position1.row and e.position.column ~ (position1.column+p) and  not( e.id = id1) and status1 = true and e.status= true  then
										                                                 if e.damage> damage1 then
										                                                 	status1:=false
										                                                 	e.damage_mutator(e.damage-damage0)
										                                                 elseif damage0 > e.damage then
										                                                 	 e.status_mutator(false)
										                                                 	 damage1:= damage1-e.damage
										                                                 else  status1:=false  e.status_mutator(false)
										                                                 end
							                                                    end

									              end

								              across model.enemy is e loop
								                                            if e.position.row ~ position0.row and e.position.column ~ (position0.column+p) and  not( e.id = id0) and status0 = true and e.alive = true  then
									                                                  status0:=false
									                                                  e.health_mutator(e.health_n-damage0)
									                                                  if e.health_n<=0 then
						                                                               e.alive_flag_mutator(false)
									                                                  end
						                                                    end

								                                            if e.position.row ~ position1.row and e.position.column ~ (position1.column+p) and  not( e.id = id1) and status1 = true and e.alive = true  then
									                                                  status1:=false
									                                                  e.health_mutator(e.health_n-damage1)
									                                                  if e.health_n<=0 then
						                                                               e.alive_flag_mutator(false)
									                                                  end
						                                                    end

								              end
		             end

	          end

	    position0.column:= position0.column + advance_factor
        position1.column:= position1.column + advance_factor
	    advance_factor:=advance_factor*2

       end

end
