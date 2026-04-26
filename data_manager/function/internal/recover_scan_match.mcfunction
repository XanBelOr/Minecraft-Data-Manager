# If this entry's uuid matches @s's uuid, restore dm.id from the entry's stored id field
$execute if data storage dm:db entries."$(id)"{uuid:"$(uuid)"} run function data_manager:internal/recover_apply with storage dm:db entries."$(id)"
