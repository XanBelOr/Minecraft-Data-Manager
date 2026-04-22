# Remove @s from perm pool. @s must be the entity being cleared.
execute unless entity @s[tag=dm.perm] run return 0
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:internal/remove_temp_entry with storage dm:args
tag @s remove dm.perm
scoreboard players reset @s dm.id
