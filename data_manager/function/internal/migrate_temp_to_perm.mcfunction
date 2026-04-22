# @s has dm.temp tag. Copy custom_data from its old temp entry to a new perm entry.

# Stage custom_data under old (positive) id
execute store result storage dm:migrate id int 1 run scoreboard players get @s dm.id
function data_manager:internal/stage_temp_data with storage dm:migrate

# Delete old temp entry; cleanup tick will drop the orphan index entry
function data_manager:internal/remove_temp_entry with storage dm:migrate

# Swap tags
tag @s remove dm.temp
tag @s add dm.perm

# Assign new perm id (negative)
scoreboard players remove .perm_counter dm.global 1
scoreboard players operation @s dm.id = .perm_counter dm.global

# Build perm entry under new (negative) id
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:internal/init_with_staged with storage dm:args
