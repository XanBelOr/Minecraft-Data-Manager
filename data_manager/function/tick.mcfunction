schedule function data_manager:tick 1t replace

# Perm recovery: any player whose dm.left (leave_game stat, persists across rename)
# differs from dm.left_handled (dummy, resets with name change) needs recovery
execute as @a[tag=dm.perm] unless score @s dm.left = @s dm.left_handled run function data_manager:internal/recover_perm_id

# Temp cleanup
execute store result storage dm:args idx int 1 run scoreboard players get .tick_index dm.global
function data_manager:internal/temp_cleanup_check with storage dm:args
scoreboard players add .tick_index dm.global 1

execute store result score .temp_size dm.global run data get storage dm:db temp_index
execute if score .tick_index dm.global >= .temp_size dm.global run scoreboard players set .tick_index dm.global 0
