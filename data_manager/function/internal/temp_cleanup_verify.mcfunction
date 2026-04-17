# If any entity still has this dm.id, leave the entry alone
$execute if entity @e[tag=dm.temp,scores={dm.id=$(id)}] run return 0
# Otherwise, remove the entry and drop from index
$data remove storage dm:db temp."$(id)"
$data remove storage dm:db temp_index[$(idx)]
scoreboard players remove .tick_index dm.global 1
