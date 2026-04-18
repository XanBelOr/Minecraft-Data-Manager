$data modify storage dm:temp migrate.entry set from storage central:player data[$(idx)]

scoreboard players add .perm_counter dm.global 1
execute store result storage dm:temp migrate.new_id int 1 run scoreboard players get .perm_counter dm.global

function data_manager_migrate_v3:migrate_write_entry_perm with storage dm:temp migrate
