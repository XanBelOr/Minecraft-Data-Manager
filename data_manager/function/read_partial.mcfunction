# Pool-agnostic: dispatches to temp or perm based on entity's pool tag.
# Caller must set dm:args.id and dm:args.path before calling.
# Slightly slower than calling the pool-specific variant directly (one extra tag check).
execute if entity @s[tag=dm.temp] run return run function data_manager:read_partial_temp with storage dm:args
execute if entity @s[tag=dm.perm] run function data_manager:read_partial_perm with storage dm:args
