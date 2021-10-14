note
	description: "Summary description for {TOGGLE_DEBUG_MODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TOGGLE_DEBUG_MODE
--inherit
--	ANY
--redefine
--	out
--end
--create
--    make

--feature-- attributes

--      model_access:SPACE_DEFENDER_2_ACCESS
--      model:SPACE_DEFENDER_2

--      enemy: STRING
--      projectile: STRING
--      friendly_projectiles_action:STRING
--      enemy_projectiles_action:STRING
--      starfighter_action:STRING
--      enemy_action:STRING
--      natural_enemy_spawn_:STRING
--feature -- initialization
--    make
--      do
--      	create enemy.make_empty
--      	create projectile.make_empty
--      	create friendly_projectiles_action.make_empty
--     	create enemy_projectiles_action.make_empty
--      	create starfighter_action.make_empty
--      	create enemy_action.make_empty
--      	create natural_enemy_spawn_.make_empty

--        model:=model_access.m

--     end

--feature-- initialize strings
--      initialize_strings
--   do
--     enemy.append ("Enemy:%N")
--     projectile.append ("Projectile:%N")
--     friendly_projectiles_action.append ("Friendly Projectile Action:%N")
--     enemy_projectiles_action.append ("Enemy Projectile Action:%N")
--     starfighter_action.append ("Starfighter Action:%N")
--     enemy_action.append ("Enemy Action:%N")
--     natural_enemy_spawn_.append ("Natural Enemy Spawn:%N")
--   end
--feature-- string_setter
--       string_setter
--           do
--           	across model.enemy is m loop
--           	   m.false_true_presenter
--           	   if (m.position.column +1)< 2 then
--           	   	else
--		       enemy.append ("    [1,"+m.signature+"]->health:"+m.health_n.out+"/"+m.health_d.out+", Regen:"+m.regen.out+", Armour:"+m.armour.out+", Vision:"+m.vision.out+", seen_by_Starfighter:"+m.seen_by_starfighter_presentation.out+", can_see_Starfighter:"+m.can_see_starfighter_presentation.out+", location:["+model.array_row[m.position.row]+","+m.position.column.out+"]%N")
--               end
--            end

--            across model.friendly_and_enemy_projectiles is f loop if (f.value.c <= model.board_column+1 and f.value.c >= 2 )then projectile.append ("    ["+f.key.out+","+f.value.sign+"]->damage:"+f.value.damage.out+", move:"+f.value.m.out+", location:["+model.array_row[f.value.r-1]+","+(f.value.c-1).out+"]%N")end  end

--            across model.enemy is e  loop
--              if e.action_flag ~ 1 then
--            	 if e.projectile_positions.count ~ 1 then
--            	 	else
--                      across 1 |..| (e.projectile_positions.count -1) is h loop
--	                       if (e.projectile_positions[h].column+4) >=1 then
--	                          if e.projectile_positions[h].column >=1 then
--	                            enemy_projectiles_action.append ("    A enemy projectile(id:"+e.projectile_positions[h].id.out+") moves: ["+model.array_row[e.projectile_positions[h].row]+","+(e.projectile_positions[h].column+4).out+"] -> ["+model.array_row[e.projectile_positions[h].row]+","+(e.projectile_positions[h].column).out+"]%N")
--	                          else
--	                          	enemy_projectiles_action.append ("    A enemy projectile(id:"+e.projectile_positions[h].id.out+") moves: ["+model.array_row[e.projectile_positions[h].row]+","+(e.projectile_positions[h].column+4).out+"] -> out of board%N")
--	                          end
--	                       end
--                      end
--                 end
--              end

--            end

--           across model.enemy is e loop
--                     if e.action_flag ~1 and model.special_flag ~ 0 then
--                       --print((model.board_column+1).out+"&&&&&&&&&&&&&&&%N")
--                      if (e.position.column +1)< 2 and e.can_see_starfighter = false then e.action_flag_reset enemy_action.append ("    A Grunt(id:1) gains 10 total health.%N    A Grunt(id:1) moves: ["+model.array_row[e.position.row]+","+(e.position.column+2).out+"] -> out of board%N")
--                      elseif  (e.position.column +1)< 2 and e.can_see_starfighter = true then e.action_flag_reset enemy_action.append ("    A Grunt(id:1) gains 10 total health.%N    A Grunt(id:1) moves: ["+model.array_row[e.position.row]+","+(e.position.column+4).out+"] -> out of board%N")
--                      else
--                      enemy_action.append ("    A Grunt(id:1) gains 10 total health.%N    A Grunt(id:1) moves: ["+model.array_row[e.position.row]+","+(e.position.column+2).out+"] -> ["+model.array_row[e.position.row]+","+(e.position.column).out+"]%N")
--                      end
--                     elseif e.action_flag ~1 and model.special_flag ~ 1 then
--                     	 enemy_action.append("    A Grunt(id:1) gains 20 total health.%N    A Grunt(id:1) moves: ["+model.array_row[e.position.row]+","+(e.position.column+2).out+"] -> ["+model.array_row[e.position.row]+","+(e.position.column).out+"]%N") end

--                     if e.action_flag ~ 1 then
--                           	e.action_flag_reset
--                           	if (e.position.column +1)< 2 then
--                           		else
--                                	enemy_action.append ("      A enemy projectile(id:"+e.projectile_positions[e.projectile_positions.count].id.out+") spawns at location ["+model.array_row[e.position.row]+","+(e.position.column-1).out+"].%N")
--                            end
--                     end

--           end
--           if model.grunt_spawn_flag ~ 1 then

--           	  natural_enemy_spawn_.append("    A Grunt(id:1) spawns at location ["+model.array_row[model.enemy[model.enemy.count].position.row]+","+(model.enemy[model.enemy.count].position.column).out+"].%N")

--           end

--            if model.pass_flag ~1 then
--                   starfighter_action.append ("    The Starfighter(id:0) passes at location ["+model.array_row[model.fighter_pos.r]+","+model.fighter_pos.c.out+"], doubling regen rate.%N")
--            end

--            if model.fire_flag ~1 then
--                   starfighter_action.append ("    The Starfighter(id:0) fires at location ["+model.array_row[model.fighter_pos.r]+","+model.fighter_pos.c.out+"].%N")
--                   starfighter_action.append ("      A friendly projectile(id:"+(model.friendly_projectiles[model.friendly_projectiles.count]).key.out+") spawns at location ["+model.array_row[model.fighter_pos.r]+","+(model.fighter_pos.c+1).out+"].%N")
--                   if model.friendly_projectiles.count ~ 1 then
--                   	 else across 1 |..| (model.friendly_projectiles.count-1) is n loop
--	                   	 	   if model.friendly_projectiles[n].value.c-5 > model.board_column+1 then

--	                   	 	   else
--		                   	 	     if model.friendly_projectiles[n].value.c > model.board_column+1 then
--		                   	 	     	friendly_projectiles_action.append ("    A friendly projectile(id:"+model.friendly_projectiles[n].key.out+") moves: ["+model.array_row[model.friendly_projectiles[n].value.r-1]+","+(model.friendly_projectiles[n].value.c-1-5).out+"] -> out of board%N")
--		                   	 	     else
--		                   	            friendly_projectiles_action.append ("    A friendly projectile(id:"+model.friendly_projectiles[n].key.out+") moves: ["+model.array_row[model.friendly_projectiles[n].value.r-1]+","+(model.friendly_projectiles[n].value.c-1-5).out+"] -> ["+model.array_row[model.friendly_projectiles[n].value.r-1]+","+(model.friendly_projectiles[n].value.c-1).out+"]%N")
--		                   	         end
--	                   	       end
--                   	      end
--                   end
--            else
--                  across model.friendly_projectiles is f loop
--                   if f.value.c -5 > model.board_column+1 then

--                   elseif f.value.c> model.board_column+1 then
--                  	  	   friendly_projectiles_action.append ("    A friendly projectile(id:"+f.key.out+") moves: ["+model.array_row[f.value.r-1]+","+(f.value.c-1-5).out+"] -> out of board%N")
--                  	  else
--                        friendly_projectiles_action.append ("    A friendly projectile(id:"+f.key.out+") moves: ["+model.array_row[f.value.r-1]+","+(f.value.c-1-5).out+"] -> ["+model.array_row[f.value.r-1]+","+(f.value.c-1).out+"]%N")
--                   end
--                  end
--            end

--            if model.move_flag ~1 then
--                   starfighter_action.append ("    The Starfighter(id:0) moves: ["+model.array_row[model.initial_pos.row]+","+model.initial_pos.column.out+"] -> ["+model.array_row[model.fighter_pos.r]+ ","+model.fighter_pos.c.out+"]%N")
--            end

--            if model.special_flag ~ 1 then
--            	   starfighter_action.append ("    The Starfighter(id:0) uses special, teleporting to: ["+model.array_row[model.fighter_pos.r]+","+model.fighter_pos.c.out+"]%N")
--            end


--           end
--feature-- out
--       out:STRING
--       do
--       	initialize_strings
--       	string_setter
--         create result.make_from_string ("  ")
--            result.append (enemy)
--            result.append ("  "+projectile)
--            result.append ("  "+friendly_projectiles_action)
--            result.append ("  "+enemy_projectiles_action)
--            result.append ("  "+starfighter_action)
--            result.append ("  "+enemy_action)
--            result.append ("  "+natural_enemy_spawn_)

--       end


end
