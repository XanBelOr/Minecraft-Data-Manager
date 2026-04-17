# Initialize @s as a perm-pool entity. After this, @s has dm.id score + dm.perm tag.
# Also populates dm:args.id so caller can immediately use read/write functions.
execute if entity @s[tag=dm.perm] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.perm] run return 0
tag @s add dm.perm

# Increment counter (no wrap)
scoreboard players add .perm_counter dm.global 1
scoreboard players operation @s dm.id = .perm_counter dm.global

# Generate UUID string for recovery
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:internal/init_perm_exec with storage dm:args
