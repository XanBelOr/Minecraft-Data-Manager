# One-time migration: copies all entries from the flat list into compound keys
# Run once after updating to v2.0, then this function can be ignored
# Usage: /function data_manager:migrate_to_compound

data modify storage central:entity entries set value {}
data modify storage central:player entries set value {}

# Get count of entity entries
execute store result score $migrate.count temp run data get storage central:entity data
scoreboard players set $migrate.index temp 0

# Migrate entities
execute if score $migrate.count temp matches 1.. run function data_manager:migrate_loop

# Get count of player entries
execute store result score $migrate.count temp run data get storage central:player data
scoreboard players set $migrate.index temp 0

# Migrate players
execute if score $migrate.count temp matches 1.. run function data_manager:migrate_loop_player

tellraw @a [{"text":"[Data Manager] ","color":"gold"},{"text":"Migration complete! All entries copied to compound keys.","color":"green"}]
