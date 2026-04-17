# Initialize @s as a temp-pool entity. After this, @s has dm.id score + dm.temp tag.
# Also populates dm:args.id so caller can immediately use read/write functions.
execute if entity @s[tag=dm.temp] run function data_manager:internal/store_id_to_args
execute if entity @s[tag=dm.temp] run return 0
tag @s add dm.temp

# Increment counter, wrap at int max
scoreboard players add .temp_counter dm.global 1
execute unless score .temp_counter dm.global matches 1..2147483647 run scoreboard players set .temp_counter dm.global 1
scoreboard players operation @s dm.id = .temp_counter dm.global

# Populate dm:args.id for immediate use
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id

# Create empty entry + add to cleanup index
function data_manager:internal/init_temp_exec with storage dm:args
data modify storage dm:db temp_index append from storage dm:args id
