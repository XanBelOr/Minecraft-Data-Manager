function data_manager:gu/generate
data modify storage dm:temp match.uuid set from storage gu:main out
scoreboard players operation .scan_min dm.global = .perm_counter dm.global
scoreboard players set .scan_idx dm.global -1

function data_manager_migrate_v3:scan_step_perm
