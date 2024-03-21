execute store result storage central:temp intuuid.0 int 1 run scoreboard players get @s gu.UUID0
execute store result storage central:temp intuuid.1 int 1 run scoreboard players get @s gu.UUID1
execute store result storage central:temp intuuid.2 int 1 run scoreboard players get @s gu.UUID2
execute store result storage central:temp intuuid.3 int 1 run scoreboard players get @s gu.UUID3
data modify storage data:manager custom_data set value {}
execute unless entity @s[tag=c.has_entry] run function data_manager:new_entry
function data_manager:read_macro with storage central:temp intuuid