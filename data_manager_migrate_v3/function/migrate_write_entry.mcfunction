# Create new perm entry with uuid and custom_data from old entry
$data modify storage dm:db perm."$(new_id)" set value {uuid:"",custom_data:{}}
$data modify storage dm:db perm."$(new_id)".uuid set from storage dm:temp migrate.entry.uuid
$data modify storage dm:db perm."$(new_id)".custom_data set from storage dm:temp migrate.entry.custom_data
