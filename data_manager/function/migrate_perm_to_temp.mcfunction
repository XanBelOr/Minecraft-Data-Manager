# Downgrade @s from perm pool to temp pool. Preserves custom_data.
# Must be called explicitly — init_temp alone will NOT downgrade.
# No-op if @s is not currently in the perm pool.

execute unless entity @s[tag=dm.perm] run return 0

# Stage custom_data from old perm entry
execute store result storage dm:migrate id int 1 run scoreboard players get @s dm.id
function data_manager:internal/stage_temp_data with storage dm:migrate

# Delete old perm entry
function data_manager:internal/remove_temp_entry with storage dm:migrate

# Swap tags
tag @s remove dm.perm
tag @s add dm.temp

# Assign new positive id from temp counter
scoreboard players add .temp_counter dm.global 1
scoreboard players operation @s dm.id = .temp_counter dm.global

# Generate UUID for cleanup check
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id

# Build new temp entry with staged data + add to cleanup index
function data_manager:internal/init_with_staged with storage dm:args
data modify storage dm:db temp_index append from storage dm:args id
