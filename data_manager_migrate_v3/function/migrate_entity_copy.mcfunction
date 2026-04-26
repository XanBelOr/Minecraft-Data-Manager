$data modify storage dm:temp migrate set value {entry:{},uuid:"",new_id:0}
$data modify storage dm:temp migrate.entry set from storage central:entity data[$(idx)]
data modify storage dm:temp migrate.uuid set from storage dm:temp migrate.entry.uuid

scoreboard players add .temp_counter dm.global 1
execute store result storage dm:temp migrate.new_id int 1 run scoreboard players get .temp_counter dm.global

function data_manager_migrate_v3:migrate_write_entry with storage dm:temp migrate
data modify storage dm:db temp_index append from storage dm:temp migrate.new_id
function data_manager_migrate_v3:tag_loaded_temp with storage dm:temp migrate
