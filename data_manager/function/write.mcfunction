# Pool-agnostic: dispatches to temp or perm based on entity's pool tag.
execute if entity @s[tag=dm.temp] run return run function data_manager:write_temp with storage dm:args
execute if entity @s[tag=dm.perm] run function data_manager:write_perm with storage dm:args
