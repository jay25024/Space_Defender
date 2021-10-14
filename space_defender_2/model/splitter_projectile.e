note
	description: "Summary description for {SPLITTER_PROJECTILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPLITTER_PROJECTILE
inherit
	FRIENDLY_PROJECTILES
create
    make

feature
	make
	 do
	 	move:=0
	 	damage0:= 150
	 	id0:=0
	 	position0:=[0,0]
	 	position1:=[0,0]
	 	position2:=[0,0]
	 	cost:=70
	 	status0:=false
	 	status1:=false
	 	status2:=false
	 	model:= model_access.m
	 end

	 set_id(k:INTEGER)
	 do
	 	id0:=k
	 end

	 change_position(row:INTEGER;column:INTEGER)
	 do
	 	position0:=[row,column]
	 end
	  update_status0(j:BOOLEAN)
      do
    	status0:=j
      end

     update_status1(j:BOOLEAN)
      do

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

      end
      update_damage2(l:INTEGER)
      do

      end

      advance
      do

		              across model.enemy is e loop
		                                            if e.position.row ~ position0.row and e.position.column ~ (position0.column) and  not( e.id = id0) and status0 = true and e.alive = true  then
			                                                  status0:=false
			                                                  e.health_mutator(e.health_n-damage0)
			                                                  if e.health_n<=0 then
                                                               e.alive_flag_mutator(false)
			                                                  end
			                                                  print("friendly proj colliding enemy , new enemy health: "+e.health_n.out+"frpooj stat: "+status0.out+" point of collision "+(position0.column).out+"%N")
                                                    end


		              end

		              if position0.column ~ model.fighter_pos.c and (position0.row) ~ model.fighter_pos.r and status0= true then
			                        update_status0(false)

			                      if model.setup.armour_v - damage0 < 0 then
			                            model.setup.health_mutator (model.setup.health_n-(damage0-model.setup.armour_v))
			                            model.setup.armour_v_mutator (0)
			                                 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (0) end
			                      end
			          end

		              across model.enemy_projectile is e loop
		                                            if e.position.row ~ position0.row and e.position.column ~ (position0.column) and  not( e.id = id0) and status0 = true and e.status= true  then
			                                                 if e.damage> damage0 then
			                                                 	status0:=false
			                                                 	e.damage_mutator(e.damage-damage0)
			                                                 elseif damage0 > e.damage then
			                                                 	 e.status_mutator(false)
			                                                 	 damage0:= damage0-e.damage
			                                                 else  status0:=false  e.status_mutator(false)
			                                                 end

                                                    end


		              end


	  end

end








