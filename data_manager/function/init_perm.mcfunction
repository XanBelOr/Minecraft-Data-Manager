# Initialize @s as a perm-pool entity. After this, @s has dm.id score + dm.perm tag.
# Also populates dm:args.id so caller can immediately use read/write functions.
# If the entity is already in the temp pool, its custom_data is migrated to perm.

# Already perm: just populate dm:args.id
execute if entity @s[tag=dm.perm] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.perm] run return 0

# Currently temp: migrate custom_data from temp pool to a new perm entry
execute if entity @s[tag=dm.temp] run function data_manager:internal/migrate_temp_to_perm
execute if entity @s[tag=dm.temp] run return 0

# Fresh init
tag @s add dm.perm
scoreboard players add .perm_counter dm.global 1
scoreboard players operation @s dm.id = .perm_counter dm.global
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:internal/init_perm_exec with storage dm:args
