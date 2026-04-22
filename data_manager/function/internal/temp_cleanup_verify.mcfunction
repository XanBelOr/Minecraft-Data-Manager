# If entity's score still exists under this uuid holder, keep the entry
$execute if score $(uuid) dm.id matches ..-1 run return 0
$execute if score $(uuid) dm.id matches 1.. run return 0
# Otherwise entity is gone — remove entry + index
$data remove storage dm:db entries."$(id)"
$data remove storage dm:db temp_index[$(idx)]
scoreboard players remove .tick_index dm.global 1
