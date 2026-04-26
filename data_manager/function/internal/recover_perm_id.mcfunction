# Run as a player whose dm.left changed since last handled (rename or first sync).
# Generate UUID, scan perm entries (negative ids), restore dm.id from the matching entry.

function data_manager:gu/generate
data modify storage dm:args uuid set from storage gu:main out
scoreboard players operation .recover_min dm.global = .perm_counter dm.global
scoreboard players set .recover_idx dm.global -1

function data_manager:internal/recover_scan_step

# Mark this dm.left value as handled, even if no match was found (prevents re-firing every tick)
scoreboard players operation @s dm.left_handled = @s dm.left
