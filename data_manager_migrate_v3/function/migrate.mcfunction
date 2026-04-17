# Data Manager v2 → v3 migration
# Copies old central:entity and central:player entries into dm:db perm
# Tags online entities with dm.perm and assigns new IDs
# RUN ONCE — migrate_v3 datapack can be removed after

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Starting v2 → v3 migration...","color":"yellow"}]

# Migrate entity list
execute store result score .migrate_count dm.global run data get storage central:entity data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_entity_loop

# Migrate player list
execute store result score .migrate_count dm.global run data get storage central:player data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_player_loop

# Tag online entities with dm.perm based on stored uuid lookup
execute as @e[tag=c.has_entry] run function data_manager_migrate_v3:tag_online_entity
execute as @a[tag=c.has_entry] run function data_manager_migrate_v3:tag_online_entity

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Migration complete. You may now uninstall data_manager_migrate_v3.","color":"green"}]
