note
	description: "Summary description for {SETUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SETUP

inherit
	ANY
		redefine
			out
		end

create
	make


feature -- Attributes
    weapon_setup: ARRAY[STRING]
    weapons:ARRAY[STRING]
    armour_setup:ARRAY[STRING]
    armour:ARRAY[STRING]
    engine_setup:ARRAY[STRING]
    engine:ARRAY[STRING]
    power_setup:ARRAY[STRING]
    power:ARRAY[STRING]

    w_selection:INTEGER
    a_selection:INTEGER
    e_selection:INTEGER
    p_selection:INTEGER

    setup_count:INTEGER
    selection_index:INTEGER

    starfighter_stats:STRING
    attributes:ARRAY[ARRAY[INTEGER]]
    projectile_power_string:STRING

    setup_selection_flag:INTEGER
--  setting attributes
    selected_weapon_attributes:ARRAY[INTEGER]
    selected_armour_attributes:ARRAY[INTEGER]
    selected_engine_attributes:ARRAY[INTEGER]
    projectile_attributes:ARRAY[ARRAY[INTEGER]]
    power_attributes:ARRAY[STRING]

    health_n:INTEGER
    health_d:INTEGER
    energy_n:INTEGER
    energy_d:INTEGER
    regen_n:INTEGER
    regen_d:INTEGER
    armour_v:INTEGER
    vision:INTEGER
    move:INTEGER
    move_c:INTEGER

    model: SPACE_DEFENDER_2
    model_access:SPACE_DEFENDER_2_ACCESS

    weapon_energy:INTEGER
feature  -- Initialization
     make
			-- Initialization for `Current'.
		do
			model:=model_access.m
			setup_count:=1
			selection_index:=1
			w_selection:=1
			a_selection:=1
			e_selection:=1
			p_selection:=1
            weapon_setup:=<<"  1:Standard (A single projectile is fired in front)" +"%N"+ "    Health:10, Energy:10, Regen:0/1, Armour:0, Vision:1, Move:1, Move Cost:1,"+"%N"+"    Projectile Damage:70, Projectile Cost:5 (energy)%N",
                            "  2:Spread (Three projectiles are fired in front, two going diagonal)" +"%N"+ "    Health:0, Energy:60, Regen:0/2, Armour:1, Vision:0, Move:0, Move Cost:2,"+"%N"+"    Projectile Damage:50, Projectile Cost:10 (energy)%N",
                            "  3:Snipe (Fast and high damage projectile, but only travels via teleporting)" +"%N"+ "    Health:0, Energy:100, Regen:0/5, Armour:0, Vision:10, Move:3, Move Cost:0,"+"%N"+"    Projectile Damage:1000, Projectile Cost:20 (energy)%N",
                            "  4:Rocket (Two projectiles appear behind to the sides of the Starfighter and accelerates)" +"%N"+ "    Health:10, Energy:0, Regen:10/0, Armour:2, Vision:2, Move:0, Move Cost:3,"+"%N"+"    Projectile Damage:100, Projectile Cost:10 (health)%N",
                            "  5:Splitter (A single mine projectile is placed in front of the Starfighter)" +"%N"+ "    Health:0, Energy:100, Regen:0/10, Armour:0, Vision:0, Move:0, Move Cost:5,"+"%N"+"    Projectile Damage:150, Projectile Cost:70 (energy)%N"
                          >>
                 weapons:=<<"Standard","Spread","Snipe","Rocket","Splitter">>


           armour_setup:=<<"  1:None%N"+"    Health:50, Energy:0, Regen:1/0, Armour:0, Vision:0, Move:1, Move Cost:0%N",
                           "  2:Light%N"+"    Health:75, Energy:0, Regen:2/0, Armour:3, Vision:0, Move:0, Move Cost:1%N",
                           "  3:Medium%N"+"    Health:100, Energy:0, Regen:3/0, Armour:5, Vision:0, Move:0, Move Cost:3%N",
                           "  4:Heavy%N"+"    Health:200, Energy:0, Regen:4/0, Armour:10, Vision:0, Move:-1, Move Cost:5%N"
                         >>
                armour:=<<"None", "Light", "Medium", "Heavy">>


           engine_setup:=<<"  1:Standard%N"+"    Health:10, Energy:60, Regen:0/2, Armour:1, Vision:12, Move:8, Move Cost:2%N",
                           "  2:Light%N"+"    Health:0, Energy:30, Regen:0/1, Armour:0, Vision:15, Move:10, Move Cost:1%N",
                           "  3:Armoured%N"+"    Health:50, Energy:100, Regen:0/3, Armour:3, Vision:6, Move:4, Move Cost:5%N"
                         >>
                engine:=<< "Standard","Light", "Armoured">>


           power_setup:=<<"  1:Recall (50 energy): Teleport back to spawn.%N",
                          "  2:Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.%N",
                          "  3:Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.%N",
                          "  4:Deploy Drones (100 energy): Clear all projectiles.%N",
                          "  5:Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.%N"
                        >>
               power:=<< "Recall" ,"Repair","Overcharge","Deploy Drones", "Orbital Strike">>

      power_attributes:=<<"Recall (50 energy): Teleport back to spawn.",
                          "Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.",
                          "Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.",
                          "Deploy Drones (100 energy): Clear all projectiles.",
                          "Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour."
                        >>

           create starfighter_stats.make_empty
           create selected_weapon_attributes.make_empty
           create selected_armour_attributes.make_empty
           create selected_engine_attributes.make_empty
           create projectile_power_string.make_empty
           create projectile_attributes.make_empty
           projectile_attributes:=<<<<70,5>>,<<50,10>>,<<1000,20>>,<<100,10>>,<<150,70>>>>
           attributes:=<<<<10,10,0,1,0,1,1,1,0,60,0,2,1,0,0,2,0,100,0,5,0,10,3,0,10,0,10,0,2,2,0,3,0,100,0,10,0,0,0,5>>,<<50,0,1,0,0,0,1,0,75,0,2,0,3,0,0,1,100,0,3,0,5,0,0,3,200,0,4,0,10,0,-1,5>>,<<10,60,0,2,1,12,8,2,0,30,0,1,0,15,10,1,50,100,0,3,3,6,4,5>>>>
           across 1 |..| 8 is a loop selected_weapon_attributes.force ((attributes[1])[a],selected_weapon_attributes.count+1)  end
           across 1 |..| 8 is a loop selected_armour_attributes.force ((attributes[2])[a],selected_armour_attributes.count+1)  end
           across 1 |..| 8 is a loop selected_engine_attributes.force ((attributes[3])[a],selected_engine_attributes.count+1)  end

		end

feature -- setup
     setup_count_increment(k:INTEGER)
        do
        	setup_count:=setup_count+k
        end


     setup_count_decrement(k:INTEGER)
        do
        	setup_count:=setup_count-k
        end

     setup_selection_setter(k:INTEGER)
        do
        	selection_index:=k
        	setup_selection_flag:=1
        end

feature -- setting up attributes
     setting_attributes
     local
     	start:INTEGER
     	ending:INTEGER
        do
        	if setup_count ~ 1 then
               if setup_selection_flag ~ 1 then
                	w_selection:= selection_index
                	if w_selection ~ 1 then
                	   create selected_weapon_attributes.make_empty
                	   across 1 |..| 8 is a loop selected_weapon_attributes.force ((attributes[1])[a],selected_weapon_attributes.count+1)  end
                	else
                	   create selected_weapon_attributes.make_empty
                	   start:= 8*(w_selection -1)+1
                	   ending:= 8*(w_selection)
                	   across start |..| ending is a loop selected_weapon_attributes.force ((attributes[1])[a],selected_weapon_attributes.count+1)  end
                    end

                end
        	end
        	if setup_count ~ 2 then
               if setup_selection_flag ~ 1 then
                	a_selection:= selection_index
                    if a_selection ~ 1 then
                	   create selected_armour_attributes.make_empty
                	   across 1 |..| 8 is a loop selected_armour_attributes.force ((attributes[2])[a],selected_armour_attributes.count+1)  end
                	else
                	   create selected_armour_attributes.make_empty
                	   start:= 8*(a_selection -1)+1
                	   ending:= 8*(a_selection)
                	   across start |..| ending is a loop selected_armour_attributes.force ((attributes[2])[a],selected_armour_attributes.count+1)  end
                    end
                end
        	end
        	if setup_count ~ 3 then
               if setup_selection_flag ~ 1 then
                	e_selection:= selection_index
                	if e_selection ~ 1 then
                	   create selected_engine_attributes.make_empty
                	   across 1 |..| 8 is a loop selected_engine_attributes.force ((attributes[3])[a],selected_engine_attributes.count+1)  end
                	else
                	   create selected_engine_attributes.make_empty
                	   start:= 8*(e_selection -1)+1
                	   ending:= 8*(e_selection)
                	   across start |..| ending is a loop selected_engine_attributes.force ((attributes[3])[a],selected_engine_attributes.count+1)  end
                    end
                end
        	end
        	if setup_count ~ 4 then
               if setup_selection_flag ~ 1 then
                	p_selection:=selection_index
                end
        	end
        end

      -- starfighter_stats
     starfighter_status
        do
        	health_n :=selected_weapon_attributes[1]+selected_armour_attributes[1]+selected_engine_attributes[1]
        	health_d :=selected_weapon_attributes[1]+selected_armour_attributes[1]+selected_engine_attributes[1]
        	energy_n :=selected_weapon_attributes[2]+selected_armour_attributes[2]+selected_engine_attributes[2]
        	energy_d :=selected_weapon_attributes[2]+selected_armour_attributes[2]+selected_engine_attributes[2]
        	regen_n  :=selected_weapon_attributes[3]+selected_armour_attributes[3]+selected_engine_attributes[3]
        	regen_d  :=selected_weapon_attributes[4]+selected_armour_attributes[4]+selected_engine_attributes[4]
        	armour_v :=selected_weapon_attributes[5]+selected_armour_attributes[5]+selected_engine_attributes[5]
           	vision   :=selected_weapon_attributes[6]+selected_armour_attributes[6]+selected_engine_attributes[6]
        	move     :=selected_weapon_attributes[7]+selected_armour_attributes[7]+selected_engine_attributes[7]
        	move_c   :=selected_weapon_attributes[8]+selected_armour_attributes[8]+selected_engine_attributes[8]

        end
      -- set projectile_power_string
     projectile_power_string_setter
        do
        	projectile_power_string.append("Projectile Pattern:"+ weapons[w_selection]+", Projectile Damage:"+(projectile_attributes[w_selection])[1].out+", Projectile Cost:"+(projectile_attributes[w_selection])[2].out+" (energy)%N"+"    "+"  Power:"+power_attributes[p_selection])

        end

feature -- attrib mutator
      health_mutator(k:INTEGER)
      do
      	print("YUP%N")
      	health_n:=k
      end
      energy_mutator(k:INTEGER)
      do
      	energy_n:=k
      end
      regen_n_mutator(k:INTEGER)
      do
      	regen_n:=k
      end
      regen_d_mutator(k:INTEGER)
      do
      	regen_d:=k
      end
      armour_v_mutator(k:INTEGER)
      do
      	armour_v:=k
      end

feature -- queries
	out : STRING
		do
			create Result.make_empty
            setting_attributes
           -- starfighter_status

		    if setup_count ~ 1 then
		    	result.append ("state:weapon setup, normal, ok%N")
		    	across weapon_setup is w loop result.append(w) end

		    	result.append ("  Weapon Selected:"+ weapons[w_selection])
		    end

		    if setup_count ~ 2 then
		    	result.append ("state:armour setup, normal, ok%N")
		    	across armour_setup is a loop result.append(a) end

		      	result.append ("  Armour Selected:"+ armour[a_selection])
		    end

		    if setup_count ~ 3 then
		    	result.append ("state:engine setup, normal, ok%N")
		    	across engine_setup is e loop result.append(e) end

		      	result.append ("  Engine Selected:"+ engine[e_selection])
		    end

		    if setup_count ~ 4 then
		    	result.append ("state:power setup, normal, ok%N")
		    	across power_setup is p loop result.append(p) end

		      	result.append ("  Power Selected:"+ power_attributes[p_selection])
		    end

		    if setup_count ~ 5 then
		    	result.append ("state:setup summary, normal, ok%N")
		        result.append ("  Weapon Selected:"+ weapons[w_selection]+"%N")
		        result.append ("  Armour Selected:"+ armour[a_selection]+"%N")
		        result.append ("  Engine Selected:"+ engine[e_selection]+"%N")
		        result.append ("  Power Selected:"+ power_attributes[p_selection])

		    end


            setup_selection_flag:=0
		end

end
