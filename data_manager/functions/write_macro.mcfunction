$execute unless entity @s[type=player] run data modify storage central:entity data[{uuid:$(out)}].custom_data set from storage data:manager custom_data
$execute if entity @s[type=player] run data modify storage central:player data[{uuid:$(out)}].custom_data set from storage data:manager custom_data