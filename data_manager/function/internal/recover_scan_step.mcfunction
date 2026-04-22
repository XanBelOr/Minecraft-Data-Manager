# If past the perm counter (we've scanned everything), stop
execute if score .recover_idx dm.global < .recover_min dm.global run return 0

# Try to match at current id
execute store result storage dm:args id int 1 run scoreboard players get .recover_idx dm.global
function data_manager:internal/recover_scan_match with storage dm:args

# If found, @s's dm.id is now set (non-zero) — stop
execute unless score @s dm.id matches 0 run return 0

# Step further negative and continue
scoreboard players remove .recover_idx dm.global 1
function data_manager:internal/recover_scan_step
