# Initialize @s in the temp pool (positive id). Idempotent.
# After this, @s has dm.id > 0 + dm.temp tag. Also populates dm:args.id.
execute if entity @s[tag=dm.temp] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.temp] run return 0

# Already in perm pool — don't downgrade
execute if entity @s[tag=dm.perm] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.perm] run return 0

tag @s add dm.temp

# Temp counter increments; overflow to Integer.MIN_VALUE is fine (still valid compound key)
scoreboard players add .temp_counter dm.global 1
scoreboard players operation @s dm.id = .temp_counter dm.global

# Generate UUID for cleanup check
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id

# Create entry, add to cleanup index
function data_manager:internal/init_temp_exec with storage dm:args
data modify storage dm:db temp_index append from storage dm:args id
