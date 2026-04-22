schedule function data_manager:tick 1t replace

# Perm recovery: players with perm tag but no dm.id (name change reset scores)
execute as @a[tag=dm.perm,predicate=data_manager:no_id] run function data_manager:internal/recover_perm_id

# Temp cleanup: check one entry per tick
execute store result storage dm:args idx int 1 run scoreboard players get .tick_index dm.global
function data_manager:internal/temp_cleanup_check with storage dm:args
scoreboard players add .tick_index dm.global 1

# Wrap index when past end
execute store result score .temp_size dm.global run data get storage dm:db temp_index
execute if score .tick_index dm.global >= .temp_size dm.global run scoreboard players set .tick_index dm.global 0
