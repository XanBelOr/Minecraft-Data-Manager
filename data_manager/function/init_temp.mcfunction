# Initialize @s as a temp-pool entity. After this, @s has dm.id score + dm.temp tag.
# Also populates dm:args.id so caller can immediately use read/write functions.
# If the entity is already in the perm pool, this call is ignored (no downgrade).

# Already temp: just populate dm:args.id
execute if entity @s[tag=dm.temp] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.temp] run return 0

# Already perm: do nothing (perm is not downgraded to temp)
execute if entity @s[tag=dm.perm] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.perm] run return 0

# Fresh init
tag @s add dm.temp
scoreboard players add .temp_counter dm.global 1
#execute unless score .temp_counter dm.global matches 1..2147483647 run scoreboard players set .temp_counter dm.global 1
scoreboard players operation @s dm.id = .temp_counter dm.global
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:internal/init_temp_exec with storage dm:args
data modify storage dm:db temp_index append from storage dm:args id
