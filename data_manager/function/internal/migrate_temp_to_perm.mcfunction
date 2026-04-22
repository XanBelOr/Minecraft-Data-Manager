# Runs as @s, entity currently has dm.temp tag.
# Stages custom_data from temp pool, deletes the temp entry,
# assigns a new perm id, and creates a perm entry with the staged data.

# Stage the temp entry's custom_data into dm:migrate
execute store result storage dm:migrate id int 1 run scoreboard players get @s dm.id
function data_manager:internal/stage_temp_data with storage dm:migrate

# Delete the old temp entry (cleanup tick will drop the orphan index entry)
function data_manager:internal/remove_temp_entry with storage dm:migrate

# Swap tags
tag @s remove dm.temp
tag @s add dm.perm

# Assign new perm id
scoreboard players add .perm_counter dm.global 1
scoreboard players operation @s dm.id = .perm_counter dm.global

# Build perm entry with staged data
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:internal/init_perm_with_staged with storage dm:args
