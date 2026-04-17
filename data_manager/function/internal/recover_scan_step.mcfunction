# If past end of counter, give up
execute if score .recover_idx dm.global > .recover_max dm.global run return 0

# Try to match at current idx
execute store result storage dm:args id int 1 run scoreboard players get .recover_idx dm.global
function data_manager:internal/recover_scan_match with storage dm:args

# If found, dm.id is now set on @s (non-zero) — stop scanning
execute unless score @s dm.id matches 0 run return 0

# Advance and continue
scoreboard players add .recover_idx dm.global 1
function data_manager:internal/recover_scan_step
