# Copy current entry from list to compound
execute store result storage central:temp migrate.idx int 1 run scoreboard players get $migrate.index temp
function data_manager:migrate_copy_player with storage central:temp migrate

# Increment and loop
scoreboard players add $migrate.index temp 1
execute if score $migrate.index temp < $migrate.count temp run function data_manager:migrate_loop_player
