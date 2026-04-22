# @s is a player with dm.perm tag but dm.id=0 (score reset from name change).
# Scan perm entries (ids from -1 down to .perm_counter) for matching uuid.
function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
scoreboard players operation .recover_min dm.global = .perm_counter dm.global
scoreboard players set .recover_idx dm.global -1

function data_manager:internal/recover_scan_step
