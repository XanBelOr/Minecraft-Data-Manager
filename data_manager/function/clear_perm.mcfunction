# Caller must set dm:args.id, then call: function data_manager:clear_perm with storage dm:args (as @s)
$data remove storage dm:db perm."$(id)"
tag @s remove dm.perm
scoreboard players reset @s dm.id
