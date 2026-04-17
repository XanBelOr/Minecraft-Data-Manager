# If any entity with this UUID still exists (loaded or unloaded), leave alone
$execute if entity $(uuid) run return 0
# Otherwise, remove the entry and drop from index
$data remove storage dm:db temp."$(id)"
$data remove storage dm:db temp_index[$(idx)]
scoreboard players remove .tick_index dm.global 1
