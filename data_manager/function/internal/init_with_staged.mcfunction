$data modify storage dm:db entries."$(id)" set value {uuid:"$(uuid)"}
$data modify storage dm:db entries."$(id)".custom_data set from storage dm:migrate custom_data
