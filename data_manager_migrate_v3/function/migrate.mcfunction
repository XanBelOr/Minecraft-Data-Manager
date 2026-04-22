# Data Manager v2 → v3.1 migration
# central:player data[] → dm:db entries."<negative id>" (perm, no cleanup)
# central:entity data[] → dm:db entries."<positive id>" (temp, added to temp_index)
# Online players get dm.perm, online non-players get dm.temp
# RUN ONCE — datapack can be uninstalled after

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Starting v2 → v3.1 migration...","color":"yellow"}]

# Migrate player list → perm (negative ids)
execute store result score .migrate_count dm.global run data get storage central:player data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_player_loop

# Migrate entity list → temp (positive ids)
execute store result score .migrate_count dm.global run data get storage central:entity data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_entity_loop

# Tag online entities
execute as @a[tag=c.has_entry] run function data_manager_migrate_v3:tag_online_player
execute as @e[tag=c.has_entry,type=!player] run function data_manager_migrate_v3:tag_online_entity

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Migration complete. You may now uninstall data_manager_migrate_v3.","color":"green"}]
