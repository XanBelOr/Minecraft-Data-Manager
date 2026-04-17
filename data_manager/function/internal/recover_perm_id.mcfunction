# Run as a player who has dm.perm tag but dm.id=0 (score reset from name change)
# Generate their UUID string and sequentially scan perm entries for matching uuid

function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
scoreboard players operation .recover_max dm.global = .perm_counter dm.global
scoreboard players set .recover_idx dm.global 1

function data_manager:internal/recover_scan_step
