$execute unless entity @s[type=player] run data modify storage data:manager custom_data set from storage central:entity data[{intuuid:$(0)$(1)$(2)$(3)}].custom_data
$execute if entity @s[type=player] run data modify storage data:manager custom_data set from storage central:player data[{intuuid:$(0)$(1)$(2)$(3)}].custom_data