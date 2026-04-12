$execute if score $(uuid) c.has_custom_data matches 1 run return 1
$data remove storage central:entity data[{uuid:$(uuid)}]
$data remove storage central:entity entries."$(intuuid)"
scoreboard players remove $c.entry_number temp 1
scoreboard players remove $c.entries temp 1
