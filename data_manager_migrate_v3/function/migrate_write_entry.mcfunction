$data modify storage dm:db entries."$(new_id)" set value {uuid:""}
$data modify storage dm:db entries."$(new_id)".uuid set from storage dm:temp migrate.entry.uuid
$data modify storage dm:db entries."$(new_id)".custom_data set from storage dm:temp migrate.entry.custom_data
