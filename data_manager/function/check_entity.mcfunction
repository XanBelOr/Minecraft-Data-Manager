scoreboard players remove $c.entries temp 1
$execute unless score $(uuid) c.has_custom_data matches 1 run data remove storage central:entity data[{uuid:$(uuid)}]
data remove storage central:temp data_array[-1]