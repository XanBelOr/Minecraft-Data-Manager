schedule function data_manager:tick 1t replace
scoreboard players add $c.entry_number temp 1
execute if score $c.entry_number temp > $c.entries temp run function data_manager:get_entries
execute unless score $c.entries temp matches 1.. run return 1
execute store result storage central:temp data.entry int 1 run scoreboard players get $c.entry_number temp
function data_manager:check_entry with storage central:temp data
#execute if score $c.entries temp matches 1.. run function data_manager:check_entity with storage central:temp data_array[-1]
