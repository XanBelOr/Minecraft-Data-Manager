# Initialize @s in the perm pool (negative id). Idempotent.
# If @s is currently in the temp pool, migrates its custom_data to a new perm entry.
# After this, @s has dm.id < 0 + dm.perm tag. Also populates dm:args.id.

execute if entity @s[tag=dm.perm] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.perm] run return 0

# Migrate from temp if needed
execute if entity @s[tag=dm.temp] run function data_manager:internal/migrate_temp_to_perm
execute if entity @s[tag=dm.temp] run return 0

tag @s add dm.perm

# Perm counter decrements (so id is negative)
scoreboard players remove .perm_counter dm.global 1
scoreboard players operation @s dm.id = .perm_counter dm.global

function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:internal/init_perm_exec with storage dm:args
