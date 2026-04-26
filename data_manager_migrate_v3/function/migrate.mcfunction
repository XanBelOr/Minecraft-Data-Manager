# Data Manager v2 → v3.1 migration. Run once.
# central:player data[] → dm:db entries."<negative id>" (perm)
# central:entity data[] → dm:db entries."<positive id>" (temp + temp_index)
# Loaded entities are tagged + scored inline as we iterate. Offline/unloaded
# entities have their data preserved in dm:db entries but won't be tagged —
# they'll be treated as fresh entities on their next init_perm/init_temp call,
# orphaning the migrated data. Run while all important players are online.

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Starting v2 → v3.1 migration...","color":"yellow"}]

# Players → perm (negative ids)
execute store result score .migrate_count dm.global run data get storage central:player data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_player_loop

# Entities → temp (positive ids)
execute store result score .migrate_count dm.global run data get storage central:entity data
scoreboard players set .migrate_idx dm.global 0
execute if score .migrate_count dm.global matches 1.. run function data_manager_migrate_v3:migrate_entity_loop

tellraw @a [{"text":"[Migrate] ","color":"gold"},{"text":"Migration complete. You may now uninstall data_manager_migrate_v3.","color":"green"}]
