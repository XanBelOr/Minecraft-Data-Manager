execute store result storage dm:temp migrate.idx int 1 run scoreboard players get .migrate_idx dm.global
function data_manager_migrate_v3:migrate_player_copy with storage dm:temp migrate

scoreboard players add .migrate_idx dm.global 1
execute if score .migrate_idx dm.global < .migrate_count dm.global run function data_manager_migrate_v3:migrate_player_loop
