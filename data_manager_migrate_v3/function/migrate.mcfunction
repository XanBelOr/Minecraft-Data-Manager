# Data Manager v2 → v3 migration
# Copies central:player entries → dm:db perm (persistent)
# Copies central:entity entries → dm:db temp (ephemeral; also indexed for cleanup)
# Tags online players with dm.perm, online non-players with dm.temp
# RUN ONCE — datapack can be removed after

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Starting v2 → v3 migration...","color":"yellow"}]

# Migrate player list → perm pool
execute store result score .migrate_count dm.global run data get storage central:player data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_player_loop

# Migrate entity list → temp pool
execute store result score .migrate_count dm.global run data get storage central:entity data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_entity_loop

# Tag online entities based on type
execute as @a[tag=c.has_entry] run function data_manager_migrate_v3:tag_online_player
execute as @e[tag=c.has_entry,type=!player] run function data_manager_migrate_v3:tag_online_entity

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Migration complete. You may now uninstall data_manager_migrate_v3.","color":"green"}]
