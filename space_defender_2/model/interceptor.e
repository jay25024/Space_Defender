note
	description: "Summary description for {INTERCEPTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERCEPTOR
inherit
	ENEMIES
create
	make
feature-- attributes
    model:SPACE_DEFENDER_2
    model_access:SPACE_DEFENDER_2_ACCESS




feature--Initialization
    make
      do
      	create signature.make_empty
      	create name.make_empty
      	name:="Interceptor"
      	signature:="I"
      	type:=4
      	health_n:=50
      	health_d:=50
      	regen:=0
      	armour:=0
      	vision:=5
      	seen_by_starfighter:=false
        can_see_starfighter:=false
        create seen_by_starfighter_presentation.make_empty
        create can_see_starfighter_presentation.make_empty
        seen_by_starfighter_presentation:="F"
        can_see_starfighter_presentation:="F"
        position:=[0,0]
        alive:=false
        model:=model_access.m
        action_flag:=0
        just_spawned:=false

      end

feature-- Actions
   alive_flag_mutator(l:BOOLEAN)
     do
      alive:=l
     end
   health_mutator(l:INTEGER)
    do
    	health_n:=l
    end
   assign_id(u:INTEGER)
    do
    	id:=u
    end
    spawn_flag_true
      do
      	just_spawned:=true
      end
    spawn_flag_false
      do
      	just_spawned:=false
      end
    preemptive_action
      do

      	if model.fire_flag ~ 1 then

      	    fires

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
    change_vision
      do
      	 if (position.row-model.fighter_pos.r).abs + (position.column-model.fighter_pos.c).abs > vision then else can_see_starfighter:= true end
      	 if (position.row-model.fighter_pos.r).abs + (position.column-model.fighter_pos.c).abs > model.setup.vision then else seen_by_starfighter:= true end
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


      end
    fires
     local
       	 p:INTEGER
       	 enemy_location: TUPLE[row:INTEGER;column:INTEGER]
       	 enemy_present:BOOLEAN

      do
        enemy_location:=[0,0]
      	if model.fighter_pos.r > position.row then

                   print("CHECKYYYY%N")
     	                      from
			 	   	           	  p:= 1
			 	   	           until
			 	   	           	  p> (model.fighter_pos.r -position.row) or enemy_present = true or alive = false
			 	   	           loop

                                      across model.friendly_projectile is f loop

						                                             if f.position0.row ~ (position.row+p) and f.position0.column ~ (position.column) and f.status0= true and not( f.id0 = id) and alive = true  then
							                                                  if health_n-f.damage0 <= 0 then
							                                                  	 f.update_status0(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status0(false) health_n:=health_n-f.damage0
							                                                  end
							                                         print("      projectile collides with enemy  damaging  it by "+f.damage0.out+"%N")
							                                         print("      new enemy health"+ health_n.out+"%N")
							                                         end
							                                         if f.position1.row ~ (position.row+p) and f.position1.column ~ (position.column) and f.status1= true and not( f.id1 = id) and alive = true  then
							                                                  if health_n-f.damage1 <= 0 then
							                                                  	 f.update_status1(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status1(false) health_n:=health_n-f.damage1
							                                                  end
							                                         print("      projectile1 collides with enemy  damaging  it by "+f.damage1.out+"%N")
							                                         print("      new enemy health"+ health_n.out+"%N")
							                                         print("new status1: "+f.status1.out+"%N")
							                                         end
							                                         if f.position2.row ~ (position.row+p) and f.position2.column ~ (position.column) and f.status2= true and not( f.id2 = id) and alive = true  then
							                                                  if health_n-f.damage2<= 0 then
							                                                  	 f.update_status2(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status2(false) health_n:=health_n-f.damage2
							                                                  end
							                                         end



						              end

						              if position.column ~ model.fighter_pos.c and (position.row+p) ~ model.fighter_pos.r and alive= true then
							                                               	      alive:=false
                                         print("VerticalThis execr##%N")
							                                               	      if model.setup.armour_v - health_n < 0 then
							                                               	      	 model.setup.health_mutator ((model.setup.health_n-(health_n-model.setup.armour_v)))
							                                               	      	 model.setup.armour_v_mutator (0)
							                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (-(model.setup.health_n+1)) end
							                                               	      else model.setup.armour_v_mutator (model.setup.armour_v - health_n )
							                                               	      end

					                  print("      enemy collides with starfighter damaging it by "+health_n.out+"%N")
					                  end

						              across model.enemy is y loop

						                                     if position.column ~ y.position.column and (position.row+p) ~ y.position.row and alive= true and enemy_present= false and y.alive = true and not(y.id = id) then

				                                                                  enemy_present:=true
				                                                                  enemy_location:= [y.position.row, y.position.column]


				                                             print("      enemy present at "+y.position.column.out+"%N")
				                                             end

						             end

						             across model.enemy_projectile is r loop

				                                if position.column ~ r.position.column and (position.row+p) ~ r.position.row and alive= true and r.status= true and not( r.id = id) then
							                                               	       r.status_mutator(false)
				                                                                   if health_n + r.damage > health_d then
							                                               	      	 health_n:=health_d
							                                               	      else health_n:=health_n + r.damage
							                                               	      end

				                                print("      enemy collides with enemy projectile healing it by "+r.damage.out+"%N")
				                                end


						             end

                             p:=p+1

                          end

				          if enemy_present = true then
		                  position.row:=enemy_location.row -1
		                  enemy_location:=[0,0]
		                  enemy_present:=false
				          else
				          position.row:= model.fighter_pos.r
				          end





			elseif position.row > model.fighter_pos.r then
                               from
			 	   	           	  p:= 1
			 	   	           until
			 	   	           	  p > (position.row-model.fighter_pos.r) or enemy_present = true or alive = false
			 	   	           loop

                                      across model.friendly_projectile is f loop

						                                             if f.position0.row ~ (position.row-p) and f.position0.column ~ (position.column) and f.status0= true and not( f.id0 = id) and alive = true  then
							                                                  if health_n-f.damage0 <= 0 then
							                                                  	 f.update_status0(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status0(false) health_n:=health_n-f.damage0
							                                                  end
							                                         print("      projectile collides with enemy  damaging  it by "+f.damage0.out+"%N")
							                                         print("      new enemy health"+ health_n.out+"%N")
							                                         end
							                                         if f.position1.row ~ (position.row-p) and f.position1.column ~ position.column and f.status1= true and not( f.id1 = id) and alive = true  then
							                                                  if health_n-f.damage1 <= 0 then
							                                                  	 f.update_status1(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status1(false) health_n:=health_n-f.damage1
							                                                  end
							                                         print("      projectile1 collides with enemy  damaging  it by "+f.damage1.out+"%N")
							                                         print("      new enemy health"+ health_n.out+"%N")
							                                         print("new status1: "+f.status1.out+"%N")
							                                         end
							                                         if f.position2.row ~ (position.row-p) and f.position2.column ~ (position.column) and f.status2= true and not( f.id2 = id) and alive = true  then
							                                                  if health_n-f.damage2<= 0 then
							                                                  	 f.update_status2(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status2(false) health_n:=health_n-f.damage2
							                                                  end
							                                         end



						              end

						              if position.column ~ model.fighter_pos.c and (position.row-p) ~ model.fighter_pos.r and alive= true then
							                                               	      alive:=false
                                         print("VerticalThis execr##%N")
							                                               	      if model.setup.armour_v - health_n < 0 then
							                                               	      	 model.setup.health_mutator ((model.setup.health_n-(health_n-model.setup.armour_v)))
							                                               	      	 model.setup.armour_v_mutator (0)
							                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (-(model.setup.health_n+1)) end
							                                               	      else model.setup.armour_v_mutator (model.setup.armour_v - health_n )
							                                               	      end

					                  print("      enemy collides with starfighter damaging it by "+health_n.out+"%N")
					                  end

						              across model.enemy is y loop

						                                     if position.column ~ y.position.column and (position.row-p) ~ y.position.row and alive= true and enemy_present= false and y.alive = true and not(y.id = id) then

				                                                                  enemy_present:=true
				                                                                  enemy_location:= [y.position.row, y.position.column]


				                                             print("      enemy present at "+y.position.column.out+"%N")
				                                             end

						             end

						             across model.enemy_projectile is r loop

				                                if position.column ~ r.position.column and (position.row-p) ~ r.position.row and alive= true and r.status= true and not( r.id = id) then
							                                               	       r.status_mutator(false)
				                                                                   if health_n + r.damage > health_d then
							                                               	      	 health_n:=health_d
							                                               	      else health_n:=health_n + r.damage
							                                               	      end

				                                print("      enemy collides with enemy projectile healing it by "+r.damage.out+"%N")
				                                end


						             end

                             p:=p+1

                          end

				          if enemy_present = true then
		                  position.row:=enemy_location.row +1
		                  enemy_location:=[0,0]
		                  enemy_present:=false
		                  print("NOOO((%N")
				          else
				          --	print("NOOO((%N")
				          position.row:= model.fighter_pos.r
				          end



				  else


       end

     end

    specials
      do

      end
    action_when_starfighter_not_seen
      do
      	action_flag:=1
        change_vision
        false_true_presenter
        if model.fire_flag~0 then
        advance
        end
        change_vision
        false_true_presenter


      end
     action_when_starfighetr_is_seen
      do
      	action_flag:=1
      	change_vision
      	false_true_presenter
      	if model.fire_flag~0 then
        advance
        end
      	change_vision
      	false_true_presenter



      end
     action_flag_reset
      do
      	action_flag:=0
      end
     advance
     local
     	p:INTEGER
     	enemy_present:BOOLEAN
     	enemy_location:TUPLE[row:INTEGER;column:INTEGER]
     do
                              enemy_location:=[0,0]
     	                      from
			 	   	           	  p:= -1
			 	   	           until
			 	   	           	  p< -3 or enemy_present = true or alive = false
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
							                                         print("      projectile collides with enemy  damaging  it by "+f.damage0.out+"%N")
							                                         print("      new enemy health"+ health_n.out+"%N")
							                                         end
							                                         if f.position1.row ~ position.row and f.position1.column ~ (position.column+p) and f.status1= true and not( f.id1 = id) and alive = true  then
							                                                  if health_n-f.damage1 <= 0 then
							                                                  	 f.update_status1(false)
							                                                  	 alive:=false
				                                                                 health_n:=0
							                                                  else f.update_status1(false) health_n:=health_n-f.damage1
							                                                  end
							                                         print("      projectile1 collides with enemy  damaging  it by "+f.damage1.out+"%N")
							                                         print("      new enemy health"+ health_n.out+"%N")
							                                         print("new status1: "+f.status1.out+"%N")
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

						              if position.column+p ~ model.fighter_pos.c and position.row ~ model.fighter_pos.r and alive= true then
							                                               	      alive:=false
                                         print("This execr##%N")
							                                               	      if model.setup.armour_v - health_n < 0 then
							                                               	      	 model.setup.health_mutator ((model.setup.health_n-(health_n-model.setup.armour_v)))
							                                               	      	 model.setup.armour_v_mutator (0)
							                                               	      	 if model.setup.health_n<=0 then model.play_board.put("X",model.fighter_pos.r+1,model.fighter_pos.c+1) model.setup.health_mutator (-(model.setup.health_n+1)) end
							                                               	      else model.setup.armour_v_mutator (model.setup.armour_v - health_n )
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
				          position.column:= position.column- 3
				          end

     end



end
