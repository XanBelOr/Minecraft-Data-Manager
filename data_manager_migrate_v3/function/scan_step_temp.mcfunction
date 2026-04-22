execute if score .scan_idx dm.global > .scan_max dm.global run return 0
execute store result storage dm:temp match.id int 1 run scoreboard players get .scan_idx dm.global
function data_manager_migrate_v3:scan_match with storage dm:temp match

execute unless score @s dm.id matches 0 run tag @s add dm.temp
execute unless score @s dm.id matches 0 run tag @s remove c.has_entry
execute unless score @s dm.id matches 0 run return 0

scoreboard players add .scan_idx dm.global 1
function data_manager_migrate_v3:scan_step_temp
