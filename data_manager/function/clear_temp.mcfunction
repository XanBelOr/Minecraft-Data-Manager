# Caller must set dm:args.id, then call: function data_manager:clear_temp with storage dm:args (as @s)
$data remove storage dm:db temp."$(id)"
tag @s remove dm.temp
scoreboard players reset @s dm.id
