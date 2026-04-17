# If the entity's score still exists (alive or just unloaded), leave the entry alone.
# Scores auto-clear when non-player entities are removed/killed, and scoreboard.dat
# is always loaded regardless of chunk state.
$execute if score $(uuid) dm.id matches 1.. run return 0
# Otherwise, the entity is gone — remove the entry and drop from index
$data remove storage dm:db temp."$(id)"
$data remove storage dm:db temp_index[$(idx)]
scoreboard players remove .tick_index dm.global 1
