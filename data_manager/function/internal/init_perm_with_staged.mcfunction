$data modify storage dm:db perm."$(id)" set value {uuid:"$(uuid)"}
$data modify storage dm:db perm."$(id)".custom_data set from storage dm:migrate custom_data
